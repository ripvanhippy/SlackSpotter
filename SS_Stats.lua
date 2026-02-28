-- ============================================================================
-- SLACKSPOTTER - STATS MODULE
-- Track missing buffs, consumes, and prot pots over multiple checks
-- ============================================================================

-- SavedVariable (initialized in SS_Stats_Initialize)
SS_StatsDB = SS_StatsDB or nil

-- WORKING MEMORY
SS_Stats_Enabled = false

-- Toggle function
function SS_Stats_Toggle()
    SS_Stats_Enabled = not SS_Stats_Enabled
    SS_StatsDB.enabled = SS_Stats_Enabled
    
    if SS_Stats_Enabled then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Stats recording enabled!|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000Stats recording disabled!|r")
    end
end

-- Helper: Get class that casts this buff
function SS_Stats_GetCasterClass(buffName)
    if string.find(buffName, "Fortitude") then return "Priests" end
    if string.find(buffName, "Spirit") then return "Priests" end
    if string.find(buffName, "Intellect") then return "Mages" end
    if string.find(buffName, "Wild") then return "Druids" end
    if string.find(buffName, "Thorns") then return "Druids" end
    if string.find(buffName, "Emerald Blessing") then return "Druids" end
    if string.find(buffName, "Shadow Protection") then return "Priests" end
    return nil
end

-- ============================================================================
-- RECORD PROT POT CHECK
-- ============================================================================
function SS_Stats_RecordProtPotCheck(protType, missingPlayers)
    if not SS_Stats_Enabled then return end
    
    SS_StatsDB.totalChecks.protPots = SS_StatsDB.totalChecks.protPots + 1
    
    for i = 1, table.getn(missingPlayers) do
        local player = missingPlayers[i]
        if not SS_StatsDB.protPotStats[player.name] then
            SS_StatsDB.protPotStats[player.name] = {potTypes = {}, count = 0, checks = 0}
        end
        
        SS_StatsDB.protPotStats[player.name].potTypes[protType] = true
        SS_StatsDB.protPotStats[player.name].count = SS_StatsDB.protPotStats[player.name].count + 1
        SS_StatsDB.protPotStats[player.name].checks = SS_StatsDB.totalChecks.protPots
    end
end

-- ============================================================================
-- RECORD CONSUME CHECK
-- ============================================================================
function SS_Stats_RecordConsumeCheck(consumeResults)
    if not SS_Stats_Enabled then return end
    
    SS_StatsDB.totalChecks.consumes = SS_StatsDB.totalChecks.consumes + 1
    
    for playerName, data in pairs(consumeResults) do
        if not SS_StatsDB.consumeStats[playerName] then
            SS_StatsDB.consumeStats[playerName] = {found = 0, expected = 0, additional = 0, checks = 0}
        end
        
        local found = 0
        local expected = 0
        local additional = 0
        
        if data.usesAnyX and data.minRequired > 0 then
            -- "Any X" mode
            found = math.min(data.found, data.minRequired)
            expected = data.minRequired
            
            -- Count ALL consumes running (from master list), then subtract found
            local totalRunning = SS_Stats_CountAllConsumesRunning(playerName)
            additional = totalRunning - found
        else
            -- Normal mode
            found = data.found
            expected = data.required
            
            -- Count consumes NOT in checked list
            additional = SS_Stats_CountUncheckedConsumes(playerName, data.spec)
        end
        
        SS_StatsDB.consumeStats[playerName].found = SS_StatsDB.consumeStats[playerName].found + found
        SS_StatsDB.consumeStats[playerName].expected = SS_StatsDB.consumeStats[playerName].expected + expected
        SS_StatsDB.consumeStats[playerName].additional = SS_StatsDB.consumeStats[playerName].additional + additional
        SS_StatsDB.consumeStats[playerName].checks = SS_StatsDB.totalChecks.consumes
    end
end

-- Helper: Count all consumes from master list currently running on player
function SS_Stats_CountAllConsumesRunning(playerName)
    local unitID = SS_Stats_GetUnitID(playerName)
    if not unitID then return 0 end
    
    local detectedConsumes = SS_Check_ScanPlayerBuffs(unitID)
    local count = 0
    
    for consumeName, _ in pairs(detectedConsumes) do
        count = count + 1
    end
    
    return count
end

-- Helper: Count consumes NOT in the checked list
function SS_Stats_CountUncheckedConsumes(playerName, specName)
    local unitID = SS_Stats_GetUnitID(playerName)
    if not unitID or not specName then return 0 end
    
    local detectedConsumes = SS_Check_ScanPlayerBuffs(unitID)
    local requiredData = SS_Check_GetRequiredConsumes(SS_ConsumeConfig_CurrentRaid, specName)
    
    if not requiredData or not requiredData.consumes then return 0 end
    
    -- Build checked list lookup
    local checkedLookup = {}
    for i = 1, table.getn(requiredData.consumes) do
        checkedLookup[requiredData.consumes[i]] = true
    end
    
    local count = 0
    for consumeName, _ in pairs(detectedConsumes) do
        if not checkedLookup[consumeName] then
            count = count + 1
        end
    end
    
    return count
end

-- Helper: Get unitID for player
function SS_Stats_GetUnitID(playerName)
    local numRaid = GetNumRaidMembers()
    
    if numRaid > 0 then
        for i = 1, numRaid do
            local name = GetRaidRosterInfo(i)
            if name == playerName then
                return "raid" .. i
            end
        end
    else
        if UnitName("player") == playerName then
            return "player"
        end
        for i = 1, GetNumPartyMembers() do
            if UnitName("party" .. i) == playerName then
                return "party" .. i
            end
        end
    end
    
    return nil
end

-- ============================================================================
-- POPULATE PROT POT STATS TABLE
-- ============================================================================
function SS_Tab7_PopulateProtPotStats()
    local editBox = getglobal("SS_Tab7_ProtPotStatsEditBox")
    if not editBox then return end
    
    local totalChecks = SS_StatsDB.totalChecks.protPots or 0
    
    -- Build sorted list
    local sortedList = {}
    for name, data in pairs(SS_StatsDB.protPotStats or {}) do
        local potTypes = {}
        for potType, _ in pairs(data.potTypes) do
            table.insert(potTypes, potType)
        end
        table.insert(sortedList, {name = name, count = data.count, potTypes = potTypes})
    end
    table.sort(sortedList, function(a, b) return a.name < b.name end)
    
    -- Create text output
    local output = string.format("===> Total Checks: %d\n\n", totalChecks)
    
    for i = 1, table.getn(sortedList) do
        local entry = sortedList[i]
        local pots = table.concat(entry.potTypes, ", ")
        output = output .. string.format("%s: %d times - Missing: %s\n", entry.name, entry.count, pots)
    end
    
    editBox:SetText(output)
    editBox:HighlightText(0, 0)
end

-- ============================================================================
-- POPULATE CONSUME STATS TABLE
-- ============================================================================
function SS_Tab7_PopulateConsumeStats()
    local editBox = getglobal("SS_Tab7_ConsumeStatsEditBox")
    if not editBox then return end
    
    local totalChecks = SS_StatsDB.totalChecks.consumes or 0
    
    -- Build sorted list
    local sortedList = {}
    for name, data in pairs(SS_StatsDB.consumeStats or {}) do
        table.insert(sortedList, {name = name, found = data.found, expected = data.expected, additional = data.additional})
    end
    table.sort(sortedList, function(a, b) return a.name < b.name end)
    
    -- Create text output
    local output = string.format("===> Total Checks: %d\n\n", totalChecks)
    
    for i = 1, table.getn(sortedList) do
        local entry = sortedList[i]
        output = output .. string.format("%s: found: %d expected: %d additional: %d\n", 
            entry.name, entry.found, entry.expected, entry.additional)
    end
    
    editBox:SetText(output)
    editBox:HighlightText(0, 0)
end

-- ============================================================================
-- REFRESH ALL STATS DISPLAYS
-- ============================================================================
function SS_Tab7_RefreshAllStats()
    SS_Tab7_PopulateProtPotStats()
    SS_Tab7_PopulateConsumeStats()
end

-- ============================================================================
-- CLEAR STATS BUTTON
-- ============================================================================
function SS_Tab7_ClearStats_OnClick()
    SS_Stats_Clear()
    SS_Tab7_RefreshAllStats()
end

-- ============================================================================
-- TAB 7 SHOW HANDLER
-- ============================================================================
function SS_Tab7_OnShow()
    SS_Tab7_RefreshAllStats()
end

-- ============================================================================
-- CLEAR STATS
-- ============================================================================
function SS_Stats_Clear()
    SS_StatsDB = {
        enabled = SS_Stats_Enabled,
        protPotStats = {},
        consumeStats = {},
        totalChecks = {protPots = 0, consumes = 0}
    }
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8000All stats cleared|r")
end

function SS_Stats_Initialize()
    -- Ensure SS_StatsDB exists first
    if not SS_StatsDB then
        SS_StatsDB = {
            enabled = false,
            protPotStats = {},
            consumeStats = {},
            totalChecks = {protPots = 0, consumes = 0}
        }
    end
    
    -- Ensure sub-tables exist (in case old saved data is incomplete)
    if not SS_StatsDB.protPotStats then SS_StatsDB.protPotStats = {} end
    if not SS_StatsDB.consumeStats then SS_StatsDB.consumeStats = {} end
    if not SS_StatsDB.totalChecks then 
        SS_StatsDB.totalChecks = {protPots = 0, consumes = 0}
    end
    
    -- Migrate old data if present
    if SS_StatsDB.consumeStats then
        for name, data in pairs(SS_StatsDB.consumeStats) do
            if data.required and not data.found then
                -- Old format detected, reset this player's stats
                SS_StatsDB.consumeStats[name] = {found = 0, expected = 0, additional = 0, checks = 0}
            end
        end
    end
    
    SS_Stats_Enabled = SS_StatsDB.enabled or false
    
    -- Update left tab highlight
    if SS_UpdateLeftTabHighlights then
        SS_UpdateLeftTabHighlights()
    end
end