-- ============================================================================
-- SLACKSPOTTER - ANNOUNCEMENTS MODULE
-- Format and send consume check results to chat
-- ============================================================================

-- ============================================================================
-- FORMAT MISSING CONSUMES FOR ANNOUNCEMENT
-- ============================================================================

function SS_Announce_FormatMissingConsumes(raidResults)
    -- Group missing consumes by consume name
    local missingByConsume = {}  -- [consumeName] = {player1, player2, ...}
    
    for playerName, data in pairs(raidResults) do
        if not data.passed and data.missing then
            for i = 1, table.getn(data.missing) do
                local missingItem = data.missing[i]
                local consumeName = missingItem.name
                
                if not missingByConsume[consumeName] then
                    missingByConsume[consumeName] = {}
                end
                table.insert(missingByConsume[consumeName], playerName)
            end
        end
    end
    
    -- Build announcement lines
    local lines = {}
    
    for consumeName, playerList in pairs(missingByConsume) do
    -- Sort player names
    table.sort(playerList)
    
    -- Build colored names
    local coloredNames = {}
    for i = 1, table.getn(playerList) do
        local playerName = playerList[i]
        -- Get class from raidResults
        local playerClass = raidResults[playerName] and raidResults[playerName].class
        if playerClass then
            table.insert(coloredNames, SS_GetColoredName(playerName, playerClass))
        else
            table.insert(coloredNames, playerName)
        end
    end
    
    -- Build line with colored names
    local playerString = table.concat(coloredNames, " ")
    table.insert(lines, consumeName .. ": " .. playerString)
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
    
    if table.getn(lines) == 0 then
        SendChatMessage("All raid members have required consumes!", "RAID")
        return
    end
    
    -- Header
    SendChatMessage("=== Missing Consumes (" .. raidInstance .. ") ===", "RAID")
    
    -- Send each line
    for i = 1, table.getn(lines) do
        SendChatMessage(lines[i], "RAID")
    end
    
    -- Footer with summary
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
    
    -- Send personal buff whispers
    for playerName, buffList in pairs(personalBuffsMissing) do
        local message = "You're missing: " .. table.concat(buffList, ", ")
        SendChatMessage(message, "WHISPER", nil, playerName)
    end
    
    -- Check if any raid buffs missing
    local hasAnyMissing = false
    for buffName, _ in pairs(raidBuffsMissing) do
        hasAnyMissing = true
        break
    end
    
    if not hasAnyMissing then
        SendChatMessage("|cff00ff00All players have their required raid buffs!|r", "RAID")
        return
    end
    
    -- Announce missing raid buffs
    for buffName, playerList in pairs(raidBuffsMissing) do
        if table.getn(playerList) > 12 then
            -- Too many players - show count instead
            SendChatMessage("|cffffcc00-->|r|cffffcc00" .. buffName .. "|r " .. table.getn(playerList) .. " players missing", "RAID")
        else
            -- Show individual names
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
        if GetNumRaidMembers() > 0 then
            SendChatMessage("|cff00ff00All players have Greater " .. protectionType .. " Protection!|r", "RAID")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00All players have Greater " .. protectionType .. " Protection!|r")
        end
        return
    end
    
    -- Color codes for protection types
    local protColor = "|cffffffff"
    if protectionType == "Fire" then protColor = "|cffff4500"
    elseif protectionType == "Frost" then protColor = "|cff00bfff"
    elseif protectionType == "Nature" then protColor = "|cff00ff00"
    elseif protectionType == "Shadow" then protColor = "|cff9932cc"
    elseif protectionType == "Holy" then protColor = "|cffffffe0"
    elseif protectionType == "Arcane" then protColor = "|cffff69b4"
    end
    
    local channel = (GetNumRaidMembers() > 0) and "RAID" or nil
    
    if SS_ListEveryoneProtection then
        -- List everyone: 10 per message
        local chunkSize = 10
        local totalChunks = math.ceil(table.getn(missingPlayers) / chunkSize)
        
        for chunk = 1, totalChunks do
            local startIndex = (chunk - 1) * chunkSize + 1
            local endIndex = math.min(chunk * chunkSize, table.getn(missingPlayers))
            
            local chunkNames = ""
            for j = startIndex, endIndex do
                local playerData = missingPlayers[j]
                local coloredName = SS_GetColoredName(playerData.name, string.upper(playerData.class))
                if j == startIndex then
                    chunkNames = "<" .. coloredName .. ">"
                else
                    chunkNames = chunkNames .. " <" .. coloredName .. ">"
                end
            end
            
            local message = protColor .. "-->Greater " .. protectionType .. " Protection|r "
            if totalChunks > 1 then
                message = message .. "(" .. chunk .. "/" .. totalChunks .. ") "
            end
            message = message .. chunkNames
            
            if channel then
                SendChatMessage(message, channel)
            else
                DEFAULT_CHAT_FRAME:AddMessage(message)
            end
        end
    elseif table.getn(missingPlayers) <= 10 then
        -- 10 or fewer: show names
        local playerNames = ""
        for j = 1, table.getn(missingPlayers) do
            local playerData = missingPlayers[j]
            local coloredName = SS_GetColoredName(playerData.name, string.upper(playerData.class))
            if j == 1 then
                playerNames = "<" .. coloredName .. ">"
            else
                playerNames = playerNames .. " <" .. coloredName .. ">"
            end
        end
        
        local message = protColor .. "-->Greater " .. protectionType .. " Protection|r " .. playerNames
        if channel then
            SendChatMessage(message, channel)
        else
            DEFAULT_CHAT_FRAME:AddMessage(message)
        end
    else
        -- 11+: group by class
        local classCounts = {}
        for j = 1, table.getn(missingPlayers) do
            local playerData = missingPlayers[j]
            local class = string.upper(playerData.class)
            if not classCounts[class] then
                classCounts[class] = 0
            end
            classCounts[class] = classCounts[class] + 1
        end
        
        local classText = ""
        local first = true
        for class, count in pairs(classCounts) do
            local classColor = SS_ClassColors[class]
            local coloredClass = class
            if classColor then
                coloredClass = string.format("|cff%02x%02x%02x%s|r", 
                    classColor.r * 255, classColor.g * 255, classColor.b * 255, class)
            end
            
            if first then
                classText = coloredClass .. "(" .. count .. ")"
                first = false
            else
                classText = classText .. " " .. coloredClass .. "(" .. count .. ")"
            end
        end
        
        local message = protColor .. "-->Greater " .. protectionType .. " Protection|r " .. table.getn(missingPlayers) .. " missing: " .. classText
        if channel then
            SendChatMessage(message, channel)
        else
            DEFAULT_CHAT_FRAME:AddMessage(message)
        end
    end
end

-- ============================================================================
-- INITIALIZE
-- ============================================================================

function SS_Announce_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Announcements module loaded!|r")
end