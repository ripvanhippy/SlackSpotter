-- ============================================================================
-- SLACKSPOTTER - ANNOUNCEMENTS MODULE
-- Format and send consume check results to chat
-- ============================================================================

-- ============================================================================
-- UNIVERSAL OUTPUT HANDLER
-- ============================================================================
function SS_Announce_Output(message, chatType)
    chatType = chatType or "RAID"
    
    if SS_DebugMode then
        DEFAULT_CHAT_FRAME:AddMessage(message)
    elseif GetNumRaidMembers() > 0 then
        SendChatMessage(message, chatType)
    else
        DEFAULT_CHAT_FRAME:AddMessage(message)
    end
end

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
    
    if table.getn(lines) == 0 then
        SS_Announce_Output("All raid members have required consumes!")
        return
    end
    
    for i = 1, table.getn(lines) do
        SS_Announce_Output(lines[i])
    end
    
    local totalFailed = 0
    local totalChecked = 0
    for _, data in pairs(raidResults) do
        totalChecked = totalChecked + 1
        if not data.passed then
            totalFailed = totalFailed + 1
        end
    end
    
    SS_Announce_Output(totalFailed .. "/" .. totalChecked .. " players missing consumes")
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
    
    -- Personal buff whispers
    for playerName, buffList in pairs(personalBuffsMissing) do
        local message = "You're missing: " .. table.concat(buffList, ", ")
        if SS_DebugMode then
            DEFAULT_CHAT_FRAME:AddMessage("[Whisper to " .. playerName .. "] " .. message)
        else
            SendChatMessage(message, "WHISPER", nil, playerName)
        end
    end
    
    -- Check if any raid buffs missing
    local hasAnyMissing = false
    for buffName, _ in pairs(raidBuffsMissing) do
        hasAnyMissing = true
        break
    end
    
    if not hasAnyMissing then
        SS_Announce_Output("|cff00ff00All players have their required raid buffs!|r")
        return
    end
    
    -- Announce missing raid buffs
for buffName, playerList in pairs(raidBuffsMissing) do
    if table.getn(playerList) > 12 then
        SS_Announce_Output("|cffffcc00" .. buffName .. "|r: " .. table.getn(playerList) .. " players missing")
    else
    local coloredNames = {}
    for i = 1, table.getn(playerList) do
        local playerData = playerList[i]
        local coloredName = SS_GetColoredName(playerData.name, playerData.class)
        table.insert(coloredNames, "<" .. coloredName .. ">")
    end
    SS_Announce_Output("|cffffcc00" .. buffName .. "|r: " .. table.concat(coloredNames, " "))
end
end
end

-- ============================================================================
-- PROTECTION POTION ANNOUNCEMENTS
-- ============================================================================

function SS_Announce_ProtectionPotions(protectionType, missingPlayers)
    if table.getn(missingPlayers) == 0 then
        SS_Announce_Output("|cff00ff00All players have Greater " .. protectionType .. " Protection!|r")
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
    chunkNames = chunkNames .. (j == startIndex and "<" or " <") .. coloredName .. ">"
end
            
            local msg = protColor .. "Greater " .. protectionType .. " Protection|r (" .. chunk .. "/" .. totalChunks .. "): " .. chunkNames
            SS_Announce_Output(msg)
        end
    else
        SS_Announce_Output(protColor .. "Greater " .. protectionType .. " Protection|r: " .. table.getn(missingPlayers) .. " missing")
    end
end

-- ============================================================================
-- INITIALIZE
-- ============================================================================

function SS_Announce_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Announcements module loaded!|r")
end