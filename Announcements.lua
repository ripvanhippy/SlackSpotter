-- ============================================================================
-- SLACKSPOTTER - ANNOUNCEMENTS MODULE
-- Format and send consume check results to chat
-- ============================================================================

-- ============================================================================
-- FORMAT MISSING CONSUMES FOR ANNOUNCEMENT
-- ============================================================================

function SS_Announce_FormatMissingConsumes(raidResults)
    -- Group missing consumes by consume name
    local missingByConsume = {}
    
    for playerName, data in pairs(raidResults) do
        if not data.passed and data.missing then
            for i = 1, table.getn(data.missing) do
                local missingItem = data.missing[i]
                local consumeName = missingItem.name
                
                if not missingByConsume[consumeName] then
                    missingByConsume[consumeName] = {}
                end
                table.insert(missingByConsume[consumeName], {name = playerName, class = data.class})
            end
        end
    end
    
    -- Build announcement lines
    local lines = {}
    
    for consumeName, playerList in pairs(missingByConsume) do
        -- Sort by player name
        table.sort(playerList, function(a, b) return a.name < b.name end)
        
        -- Build colored names
        local coloredNames = {}
        for i = 1, table.getn(playerList) do
            local player = playerList[i]
            local classUpper = string.upper(player.class)
            local coloredName = SS_GetColoredName(player.name, classUpper)
            table.insert(coloredNames, coloredName)
        end
        
        -- Format: RED consume name + class-colored players
        -- Build line with colored names
local playerString = table.concat(coloredNames, " ")
local shortName = SS_ConsumeShortNames[consumeName] or consumeName
table.insert(lines, "|cffff0000" .. shortName .. ":|r " .. playerString)
    end
    
    -- Sort lines alphabetically
    table.sort(lines)
    
    return lines
end

-- ============================================================================
-- SEND ANNOUNCEMENT TO CHAT consumes
-- ============================================================================

function SS_Announce_SendToRaid(raidResults, raidInstance)
    local lines = SS_Announce_FormatMissingConsumes(raidResults)
    
    if SS_DebugMode then
        DEFAULT_CHAT_FRAME:AddMessage("=== Missing Consumes (" .. raidInstance .. ") ===")
        if table.getn(lines) == 0 then
            DEFAULT_CHAT_FRAME:AddMessage("All raid members have required consumes!")
        else
            for i = 1, table.getn(lines) do
                DEFAULT_CHAT_FRAME:AddMessage(lines[i])
            end
            
            local totalFailed = 0
            local totalChecked = 0
            for _, data in pairs(raidResults) do
                totalChecked = totalChecked + 1
                if not data.passed then
                    totalFailed = totalFailed + 1
                end
            end
            DEFAULT_CHAT_FRAME:AddMessage(totalFailed .. "/" .. totalChecked .. " players missing consumes")
        end
        return
    end
    
    if table.getn(lines) == 0 then
        SendChatMessage("All raid members have required consumes!", "RAID")
        return
    end
    
    for i = 1, table.getn(lines) do
        SendChatMessage(lines[i], "RAID")
    end
    
    local totalFailed = 0
    local totalChecked = 0
    for _, data in pairs(raidResults) do
        totalChecked = totalChecked + 1
        if not data.passed then
            totalFailed = totalFailed + 1
        end
    end
    
    SendChatMessage(totalFailed .. "/" .. totalChecked .. " players missing consumes", "RAID")
end

-- ============================================================================
-- SEND TO SELF (DEBUG) consumes
-- ============================================================================

function SS_Announce_SendToSelf(raidResults, raidInstance)
    local lines = SS_Announce_FormatMissingConsumes(raidResults)
    
    DEFAULT_CHAT_FRAME:AddMessage("=== Missing Consumes (" .. raidInstance .. ") ===")
    
    if table.getn(lines) == 0 then
        DEFAULT_CHAT_FRAME:AddMessage("All raid members have required consumes!")
        return
    end
    
    for i = 1, table.getn(lines) do
        DEFAULT_CHAT_FRAME:AddMessage(lines[i])
    end
end

-- ============================================================================
-- FORMAT MISSING RAID BUFFS
-- ============================================================================

function SS_RaidBuffAnnounce_Format(raidResults)
	-- Separate raid buffs from personal buffs
    local raidBuffsMissing = {}  -- [buffName] = {player1, player2, ...}
    local personalBuffsMissing = {}  -- [playerName] = {buff1, buff2, ...}
    
    for playerName, data in pairs(raidResults) do
        if data.missing then
            for i = 1, table.getn(data.missing) do
                local missingBuff = data.missing[i]
                
                if missingBuff.personal then
                    -- Personal buff - whisper
                    if not personalBuffsMissing[playerName] then
                        personalBuffsMissing[playerName] = {}
                    end
                    table.insert(personalBuffsMissing[playerName], missingBuff.name)
                else
                    -- Raid buff - announce to raid
                    if not raidBuffsMissing[missingBuff.name] then
                        raidBuffsMissing[missingBuff.name] = {}
                    end
                    table.insert(raidBuffsMissing[missingBuff.name], {
                        name = playerName,
                        class = data.class
                    })
                end
            end
        end
    end
    
    return raidBuffsMissing, personalBuffsMissing
end

-- ============================================================================
-- SEND TO RAID CHAT raidbuffs
-- ============================================================================

function SS_RaidBuffAnnounce_SendToRaid(raidResults)
    local raidBuffsMissing, personalBuffsMissing = SS_RaidBuffAnnounce_Format(raidResults)
    
    if SS_DebugMode then
    DEFAULT_CHAT_FRAME:AddMessage("=== Missing Raid Buffs ===")
    
    for playerName, buffList in pairs(personalBuffsMissing) do
        DEFAULT_CHAT_FRAME:AddMessage("[Whisper to " .. playerName .. "] You're missing: " .. table.concat(buffList, ", "))
    end
    
    local hasAnyMissing = false
    for buffName, playerList in pairs(raidBuffsMissing) do
        hasAnyMissing = true
        
        if table.getn(playerList) > 12 then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00" .. buffName .. "|r: " .. table.getn(playerList) .. " players missing")
        else
            local coloredNames = {}
            for i = 1, table.getn(playerList) do
                local playerData = playerList[i]
                local coloredName = SS_GetColoredName(playerData.name, playerData.class)
                table.insert(coloredNames, coloredName)
            end
            DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00" .. buffName .. "|r: " .. table.concat(coloredNames, ", "))
        end
    end
        
        if not hasAnyMissing then
            DEFAULT_CHAT_FRAME:AddMessage("All players have their required raid buffs!")
        end
        return
    end
    
    for playerName, buffList in pairs(personalBuffsMissing) do
        local message = "You're missing: " .. table.concat(buffList, ", ")
        SendChatMessage(message, "WHISPER", nil, playerName)
    end
    
    local hasAnyMissing = false
    for buffName, _ in pairs(raidBuffsMissing) do
        hasAnyMissing = true
        break
    end
    
    if not hasAnyMissing then
        SendChatMessage("|cff00ff00All players have their required raid buffs!|r", "RAID")
        return
    end
    
    for buffName, playerList in pairs(raidBuffsMissing) do
        if table.getn(playerList) > 12 then
            SendChatMessage("|cffffcc00-->|r|cffffcc00" .. buffName .. "|r " .. table.getn(playerList) .. " players missing", "RAID")
        else
            local playerNames = ""
            for i = 1, table.getn(playerList) do
                local playerData = playerList[i]
                local coloredName = SS_GetColoredName(playerData.name, playerData.class)
                if i == 1 then
                    playerNames = "<" .. coloredName .. ">"
                else
                    playerNames = playerNames .. " <" .. coloredName .. ">"
                end
            end
            SendChatMessage("|cffffcc00-->|r|cffffcc00" .. buffName .. "|r " .. playerNames, "RAID")
        end
    end
end

-- ============================================================================
-- SEND TO SELF (DEBUG) raidbuffs
-- ============================================================================

function SS_RaidBuffAnnounce_SendToSelf(raidResults)
    local raidBuffsMissing, personalBuffsMissing = SS_RaidBuffAnnounce_Format(raidResults)
    
    DEFAULT_CHAT_FRAME:AddMessage("=== Missing Raid Buffs ===")
    
    -- Personal buffs
    for playerName, buffList in pairs(personalBuffsMissing) do
        DEFAULT_CHAT_FRAME:AddMessage("[Whisper to " .. playerName .. "] You're missing: " .. table.concat(buffList, ", "))
    end
    
    -- Raid buffs
    local hasAnyMissing = false
    for buffName, playerList in pairs(raidBuffsMissing) do
        hasAnyMissing = true
        
        if table.getn(playerList) > 12 then
            DEFAULT_CHAT_FRAME:AddMessage(buffName .. ": " .. table.getn(playerList) .. " players missing")
        else
            local names = {}
            for i = 1, table.getn(playerList) do
                table.insert(names, playerList[i].name)
            end
            DEFAULT_CHAT_FRAME:AddMessage(buffName .. ": " .. table.concat(names, ", "))
        end
    end
    
    if not hasAnyMissing then
        DEFAULT_CHAT_FRAME:AddMessage("All players have their required raid buffs!")
    end
end

-- ============================================================================
-- PROTECTION POTION ANNOUNCEMENTS
-- ============================================================================

function SS_Announce_ProtectionPotions(protectionType, missingPlayers)
    if table.getn(missingPlayers) == 0 then
        local msg = "|cff00ff00All players have Greater " .. protectionType .. " Protection!|r"
        if SS_DebugMode then
            DEFAULT_CHAT_FRAME:AddMessage(msg)
        elseif GetNumRaidMembers() > 0 then
            SendChatMessage(msg, "RAID")
        else
            DEFAULT_CHAT_FRAME:AddMessage(msg)
        end
        return
    end
    
    local protColor = "|cffffffff"
    if protectionType == "Fire" then protColor = "|cffff4500"
    elseif protectionType == "Frost" then protColor = "|cff00bfff"
    elseif protectionType == "Nature" then protColor = "|cff00ff00"
    elseif protectionType == "Shadow" then protColor = "|cff9932cc"
    elseif protectionType == "Holy" then protColor = "|cffffffe0"
    elseif protectionType == "Arcane" then protColor = "|cffff69b4"
    end
    
    if SS_ListEveryoneProtection then
        local chunkSize = 10
        local totalChunks = math.ceil(table.getn(missingPlayers) / chunkSize)
        
        for chunk = 1, totalChunks do
            local startIndex = (chunk - 1) * chunkSize + 1
            local endIndex = math.min(chunk * chunkSize, table.getn(missingPlayers))
            
            local chunkNames = ""
            for j = startIndex, endIndex do
                local coloredName = SS_GetColoredName(missingPlayers[j].name, missingPlayers[j].class)
                if j == startIndex then
                    chunkNames = coloredName
                else
                    chunkNames = chunkNames .. " " .. coloredName
                end
            end
            
            local msg = protColor .. "Greater " .. protectionType .. " Protection|r (" .. chunk .. "/" .. totalChunks .. "): " .. chunkNames
            if SS_DebugMode then
                DEFAULT_CHAT_FRAME:AddMessage(msg)
            elseif GetNumRaidMembers() > 0 then
                SendChatMessage(msg, "RAID")
            else
                DEFAULT_CHAT_FRAME:AddMessage(msg)
            end
        end
    else
        local msg = protColor .. "Greater " .. protectionType .. " Protection|r: " .. table.getn(missingPlayers) .. " missing"
        if SS_DebugMode then
            DEFAULT_CHAT_FRAME:AddMessage(msg)
        elseif GetNumRaidMembers() > 0 then
            SendChatMessage(msg, "RAID")
        else
            DEFAULT_CHAT_FRAME:AddMessage(msg)
        end
    end
end

-- ============================================================================
-- INITIALIZE
-- ============================================================================

function SS_Announce_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Announcements module loaded!|r")
end