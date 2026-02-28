-- ============================================================================
-- SLACKSPOTTER - MASTER/SLAVE SYNCHRONIZATION
-- Addon communication for shared consume/spec configuration
-- ============================================================================
-- ============================================================================
-- GLOBAL STATE
-- ============================================================================
SS_MasterSlave_IsMaster = false
SS_MasterSlave_MasterName = nil  -- Who is current master (nil = local control)
SS_MasterSlave_SlaveNames = {}   -- List of slaves (only tracked by master)
SS_MasterSlave_DetectionTimer = 0
SS_MasterSlave_DetectionWarningShown = {}  -- Track warnings shown this session
SS_MasterSlave_SyncDelayTimer = 0
SS_MasterSlave_PendingSync = false
SS_MasterSlave_MessageQueue = {}
SS_MasterSlave_QueueTimer = 0
-- Communication frame
SS_MasterSlave_CommFrame = nil
-- ============================================================================
-- ADDON MESSAGE PREFIX (max 16 chars)
-- ============================================================================
local PREFIX = "SlackSpotter"
-- ============================================================================
-- MESSAGE TYPES
-- ============================================================================
local MSG_PING = "PING"           -- "I'm here with addon"
local MSG_MASTER_CLAIM = "MCLAIM" -- "I am now master"
local MSG_MASTER_RELEASE = "MREL" -- "I release master control"
local MSG_SYNC_RAID = "SRAID"     -- Sync current raid
local MSG_SYNC_SPECS = "SSPECS"   -- Sync all specs (batched)
local MSG_SYNC_CONSUMES = "SCONS" -- Sync consumes for current raid
-- ============================================================================
-- HELPER: Get player's raid rank
-- ============================================================================
local function SS_MasterSlave_GetRaidRank(playerName)
local numRaid = GetNumRaidMembers()
if numRaid == 0 then return 0 end  -- Not in raid
for i = 1, numRaid do
    local name, rank = GetRaidRosterInfo(i)
    if name == playerName then
        return rank  -- 0=member, 1=assistant, 2=leader
    end
end
return 0
end
-- ============================================================================
-- HELPER: Compare priorities (higher = more authority)
-- ============================================================================
local function SS_MasterSlave_ComparePriority(player1, player2)
local rank1 = SS_MasterSlave_GetRaidRank(player1)
local rank2 = SS_MasterSlave_GetRaidRank(player2)
if rank1 ~= rank2 then
    return rank1 > rank2  -- Leader > Assistant > Member
end

-- Same rank: alphabetical (deterministic)
return player1 < player2
end
-- ============================================================================
-- SEND MESSAGE (queued to avoid throttle)
-- ============================================================================
local function SS_MasterSlave_QueueMessage(msgType, data)
table.insert(SS_MasterSlave_MessageQueue, {
type = msgType,
data = data,
time = GetTime()
})
end
local function SS_MasterSlave_SendQueuedMessages()
if table.getn(SS_MasterSlave_MessageQueue) == 0 then return end
-- Send one message per second
SS_MasterSlave_QueueTimer = SS_MasterSlave_QueueTimer - 1
if SS_MasterSlave_QueueTimer > 0 then return end

local msg = table.remove(SS_MasterSlave_MessageQueue, 1)
if msg then
    local fullMsg = msg.type .. ":" .. (msg.data or "")
    SendAddonMessage(PREFIX, fullMsg, "RAID")
    SS_MasterSlave_QueueTimer = 1.0  -- 1 second throttle
end
end
-- ============================================================================
-- BROADCAST: I am master
-- ============================================================================
function SS_MasterSlave_BroadcastMasterClaim()
local myName = UnitName("player")
SS_MasterSlave_QueueMessage(MSG_MASTER_CLAIM, myName)
end
-- ============================================================================
-- BROADCAST: I release master
-- ============================================================================
function SS_MasterSlave_BroadcastMasterRelease()
SS_MasterSlave_QueueMessage(MSG_MASTER_RELEASE, "")
end
-- ============================================================================
-- BROADCAST: Ping (I have addon installed)
-- ============================================================================
function SS_MasterSlave_BroadcastPing()
local myName = UnitName("player")
SS_MasterSlave_QueueMessage(MSG_PING, myName)
end
-- ============================================================================
-- SYNC: Current raid selection
-- ============================================================================
function SS_MasterSlave_SyncRaid()
if not SS_MasterSlave_IsMaster then return end
local raidName = SS_ConsumeConfig_CurrentRaid or "Kara40"
SS_MasterSlave_QueueMessage(MSG_SYNC_RAID, raidName)
end
-- ============================================================================
-- SYNC: All specs (compressed format)
-- ============================================================================
function SS_MasterSlave_SyncSpecs()
if not SS_MasterSlave_IsMaster then return end
-- Format: "PlayerName:specIndex,PlayerName2:specIndex2"
local parts = {}

if SS_ConfigSpecs_SelectedSpecs then
    for playerName, specIndex in pairs(SS_ConfigSpecs_SelectedSpecs) do
        table.insert(parts, playerName .. ":" .. specIndex)
    end
end

local data = table.concat(parts, ",")

-- Split into chunks if > 240 chars
local maxLen = 240
if string.len(data) <= maxLen then
    SS_MasterSlave_QueueMessage(MSG_SYNC_SPECS, data)
else
    -- Split into multiple messages
    local remaining = data
    local chunkNum = 1
    while string.len(remaining) > 0 do
        local chunk = string.sub(remaining, 1, maxLen)
        SS_MasterSlave_QueueMessage(MSG_SYNC_SPECS, chunkNum .. "/" .. chunk)
        remaining = string.sub(remaining, maxLen + 1)
        chunkNum = chunkNum + 1
    end
end
end
-- ============================================================================
-- SYNC: Consumes for current raid (use ID mapping)
-- ============================================================================
function SS_MasterSlave_SyncConsumes()
if not SS_MasterSlave_IsMaster then return end
local raidName = SS_ConsumeConfig_CurrentRaid or "Kara40"
local specName = SS_ConsumeConfig_CurrentSpec or "WarriorDPS"

-- Get working memory for this raid+spec
local specData = SS_ConsumeConfig_WorkingMemory[raidName] and 
                 SS_ConsumeConfig_WorkingMemory[raidName][specName]

if not specData then return end

-- Convert consume names to IDs
local consumeIDs = {}
if specData.consumes then
    for consumeName, isChecked in pairs(specData.consumes) do
        if isChecked then
            local id = SS_ConsumeData_NameToID[consumeName]
            if id then
                table.insert(consumeIDs, tostring(id))
            end
        end
    end
end

local minReq = specData.minRequired or 0

-- Format: "RaidName|SpecName|ID1,ID2,ID3|minRequired"
local data = raidName .. "|" .. specName .. "|" .. table.concat(consumeIDs, ",") .. "|" .. minReq

SS_MasterSlave_QueueMessage(MSG_SYNC_CONSUMES, data)
end
-- ============================================================================
-- BATCH SYNC: Send all data (raid + specs + consumes)
-- ============================================================================
function SS_MasterSlave_SendBatchSync()
if not SS_MasterSlave_IsMaster then return end
SS_MasterSlave_SyncRaid()
SS_MasterSlave_SyncSpecs()

-- Sync consumes for ALL specs in current raid
local raidName = SS_ConsumeConfig_CurrentRaid or "Kara40"
if SS_ConsumeConfig_WorkingMemory[raidName] then
    for specName, specData in pairs(SS_ConsumeConfig_WorkingMemory[raidName]) do
        -- Temporarily set current spec to sync it
        local oldSpec = SS_ConsumeConfig_CurrentSpec
        SS_ConsumeConfig_CurrentSpec = specName
        SS_MasterSlave_SyncConsumes()
        SS_ConsumeConfig_CurrentSpec = oldSpec
    end
end
end
-- ============================================================================
-- RECEIVE: Handle incoming addon messages
-- ============================================================================
local function SS_MasterSlave_OnReceive(prefix, message, channel, sender)
if prefix ~= PREFIX then return end
if sender == UnitName("player") then return end  -- Ignore own messages
-- Parse message: "TYPE:data"
local msgType, data = string.match(message, "^([^:]+):(.*)$")
if not msgType then return end

-- Handle message types
if msgType == MSG_PING then
        -- Someone has addon installed
        if SS_MasterSlave_IsMaster then
            -- Track this slave
            SS_MasterSlave_SlaveNames[sender] = true
        elseif not SS_MasterSlave_MasterName then
            -- I'm in local mode and detected another instance
            -- Show warning once per session per user
            if not SS_MasterSlave_DetectionWarningShown then
                SS_MasterSlave_DetectionWarningShown = {}
            end
            
            if not SS_MasterSlave_DetectionWarningShown[sender] then
                SS_MasterSlave_DetectionWarningShown[sender] = true
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[SlackSpotter] Other instance detected (" .. sender .. "). Type '/ss master on' to take control of consume/spec config.|r")
            end
        end
    
elseif msgType == MSG_MASTER_CLAIM then
    -- Someone claims master
    local claimant = data
    
    if SS_MasterSlave_IsMaster then
        -- I am master, check priority
        if SS_MasterSlave_ComparePriority(claimant, UnitName("player")) then
            -- They outrank me, step down
            SS_MasterSlave_IsMaster = false
            SS_MasterSlave_MasterName = claimant
            SS_MasterSlave_SlaveNames = {}
            DEFAULT_CHAT_FRAME:AddMessage("|cffff8000[SlackSpotter] " .. claimant .. " is now master. You are now in slave mode.|r")
            SS_MasterSlave_UpdateUI()
        else
            -- I outrank them, re-broadcast my claim
            SS_MasterSlave_BroadcastMasterClaim()
        end
    else
        -- I am slave or local, accept new master
        SS_MasterSlave_MasterName = claimant
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[SlackSpotter] " .. claimant .. " is now master.|r")
        SS_MasterSlave_UpdateUI()
    end
    
elseif msgType == MSG_MASTER_RELEASE then
    -- Master released control
    if SS_MasterSlave_MasterName == sender then
        SS_MasterSlave_MasterName = nil
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000[SlackSpotter] Master control released. Local control restored.|r")
        SS_MasterSlave_UpdateUI()
    end
    
elseif msgType == MSG_SYNC_RAID then
    -- Sync raid selection
    if SS_MasterSlave_MasterName == sender then
        local raidName = data
        if raidName and raidName ~= "" then
            SS_SelectRaid(raidName)
        end
    end
    
elseif msgType == MSG_SYNC_SPECS then
    -- Sync specs (handle chunked messages)
    if SS_MasterSlave_MasterName == sender then
        -- Parse: "PlayerName:specIndex,PlayerName2:specIndex2"
        if string.find(data, "/") then
            -- Chunked message: "chunkNum/data"
            -- TODO: Implement chunk reassembly if needed
            -- For now, assume messages fit in one chunk
            return
        end
        
        -- Single message
        for pair in string.gfind(data, "[^,]+") do
            local playerName, specIndex = string.match(pair, "([^:]+):(%d+)")
            if playerName and specIndex then
                SS_ConfigSpecs_SelectedSpecs[playerName] = tonumber(specIndex)
            end
        end
        
        -- Update Tab 5 display if visible
        if SS_CurrentTab == 5 then
            SS_ConfigSpecs_UpdateDisplay()
        end
    end
    
elseif msgType == MSG_SYNC_CONSUMES then
    -- Sync consumes
    if SS_MasterSlave_MasterName == sender then
        -- Parse: "RaidName|SpecName|ID1,ID2,ID3|minRequired"
        local raidName, specName, consumeIDs, minReq = string.match(data, "([^|]+)|([^|]+)|([^|]*)|(%d+)")
        
        if raidName and specName then
            -- Ensure working memory structure exists
            if not SS_ConsumeConfig_WorkingMemory[raidName] then
                SS_ConsumeConfig_WorkingMemory[raidName] = {}
            end
            
            -- Build consumes table from IDs
            local consumes = {}
            if consumeIDs and consumeIDs ~= "" then
                for idStr in string.gfind(consumeIDs, "[^,]+") do
                    local id = tonumber(idStr)
                    if id and SS_ConsumeData_IDMapping[id] then
                        local consumeName = SS_ConsumeData_IDMapping[id]
                        consumes[consumeName] = true
                    end
                end
            end
            
            -- Store in working memory
            SS_ConsumeConfig_WorkingMemory[raidName][specName] = {
                consumes = consumes,
                minRequired = tonumber(minReq) or 0
            }
            
            -- Update Tab 6 display if on this spec
            if SS_CurrentTab == 6 and 
               SS_ConsumeConfig_CurrentRaid == raidName and 
               SS_ConsumeConfig_CurrentSpec == specName then
                SS_ConsumeConfig_LoadSpecData()
                SS_ConsumeConfig_UpdateDisplay()
            end
        end
    end
end
end
-- ============================================================================
-- UPDATE UI: Show master/slave status
-- ============================================================================
function SS_MasterSlave_UpdateUI()
-- Update Tab 5 (Specs)
if SS_CurrentTab == 5 then
SS_ConfigSpecs_UpdateMasterSlaveUI()
end
-- Update Tab 6 (Consumes)
if SS_CurrentTab == 6 then
    SS_ConsumeConfig_UpdateMasterSlaveUI()
end
end
-- ============================================================================
-- DETECTION LOOP: Ping every 10 seconds
-- ============================================================================
-- Robust OnUpdate handler (works if called as (self, elapsed) or (elapsed))
local function SS_MasterSlave_OnUpdate(self, elapsed, ...)
--DEFAULT_CHAT_FRAME:AddMessage(string.format("[SS] OnUpdate called; self=%s elapsed=%s", tostring(type(self)), tostring(elapsed)))

    -- Handle the case where the function was called as SS_MasterSlave_OnUpdate(elapsed)
    if type(self) == "number" then
        elapsed = self
        self = nil
    end

    -- As a last resort, ensure elapsed is a number
    if not elapsed or type(elapsed) ~= "number" then
        elapsed = 0
    end

    -- Detection timer (ping every 10 seconds)
    SS_MasterSlave_DetectionTimer = SS_MasterSlave_DetectionTimer + elapsed
    if SS_MasterSlave_DetectionTimer >= 10 then
        SS_MasterSlave_DetectionTimer = 0
        -- Only ping if in raid
        if GetNumRaidMembers() > 0 then
            SS_MasterSlave_BroadcastPing()
            -- (rest of your logic unchanged)
            if not SS_MasterSlave_IsMaster and not SS_MasterSlave_MasterName then
                local othersDetected = false
                for _ in pairs(SS_MasterSlave_SlaveNames) do
                    othersDetected = true
                    break
                end
                -- note: slaves don't track other slaves
            end
        else
            -- Not in raid: reset to local control
            if SS_MasterSlave_IsMaster or SS_MasterSlave_MasterName then
                SS_MasterSlave_IsMaster = false
                SS_MasterSlave_MasterName = nil
                SS_MasterSlave_SlaveNames = {}
                SS_MasterSlave_UpdateUI()
            end
        end
    end

    -- Sync delay timer (batch changes after 5 sec idle)
    if SS_MasterSlave_PendingSync then
        SS_MasterSlave_SyncDelayTimer = SS_MasterSlave_SyncDelayTimer - elapsed
        if SS_MasterSlave_SyncDelayTimer <= 0 then
            SS_MasterSlave_SendBatchSync()
            SS_MasterSlave_PendingSync = false
        end
    end

    -- Message queue processor (keep this as-is)
    SS_MasterSlave_SendQueuedMessages()
end

-- ============================================================================
-- TRIGGER SYNC: Mark pending and reset timer
-- ============================================================================
function SS_MasterSlave_TriggerSync()
if not SS_MasterSlave_IsMaster then return end
SS_MasterSlave_PendingSync = true
SS_MasterSlave_SyncDelayTimer = 5.0  -- 5 seconds
end
-- ============================================================================
-- SLASH COMMAND: /ss master on/off
-- ============================================================================
function SS_MasterSlave_Command(args)
if args[1] == "master" then
if args[2] == "on" then
-- Claim master
if GetNumRaidMembers() == 0 then
DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[SlackSpotter] You must be in a raid to use master mode.|r")
return true
end
        SS_MasterSlave_IsMaster = true
        SS_MasterSlave_MasterName = UnitName("player")
        SS_MasterSlave_BroadcastMasterClaim()
        
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[SlackSpotter] Master mode enabled. Type '/ss master off' to release control.|r")
        SS_MasterSlave_UpdateUI()
        
        -- Send initial sync
        SS_MasterSlave_SendBatchSync()
        
        return true
        
    elseif args[2] == "off" then
        -- Release master
        if not SS_MasterSlave_IsMaster then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[SlackSpotter] You are not currently master.|r")
            return true
        end
        
        SS_MasterSlave_IsMaster = false
        SS_MasterSlave_MasterName = nil
        SS_MasterSlave_SlaveNames = {}
        SS_MasterSlave_BroadcastMasterRelease()
        
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000[SlackSpotter] Master mode disabled. Local control restored.|r")
        SS_MasterSlave_UpdateUI()
        
        return true
    end
end

return false  -- Not handled
end
-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function SS_MasterSlave_Initialize()
-- Create communication frame
SS_MasterSlave_CommFrame = CreateFrame("Frame")
SS_MasterSlave_CommFrame:RegisterEvent("CHAT_MSG_ADDON")
SS_MasterSlave_CommFrame:SetScript("OnEvent", function()
    if event == "CHAT_MSG_ADDON" then
        SS_MasterSlave_OnReceive(arg1, arg2, arg3, arg4)
    end
end)

SS_MasterSlave_UpdateFrame = CreateFrame("Frame")
SS_MasterSlave_UpdateFrame:SetScript("OnUpdate", function()
    SS_MasterSlave_OnUpdate(this, arg1)
end)


if SS_MasterSlave_OnUpdate then
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[SS Debug] OnUpdate is defined: " .. tostring(SS_MasterSlave_OnUpdate) .. "|r")
else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[SS Debug] OnUpdate is NIL!|r")
end


DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[SlackSpotter] Master/Slave system initialized.|r")
end