-- ============================================================================
-- SLACKSPOTTER - RAID BUFF ANNOUNCEMENTS
-- Format and send raid buff check results to chat
-- ============================================================================

-- ============================================================================
-- FORMAT MISSING RAID BUFFS
-- ============================================================================

function SS_RaidBuffAnnounce_Format(raidResults)
    
	-- DEBUG
    DEFAULT_CHAT_FRAME:AddMessage("=== Announce Format DEBUG ===")
    for playerName, data in pairs(raidResults) do
        DEFAULT_CHAT_FRAME:AddMessage("Player: " .. playerName)
        if data.buffsMissing then
            DEFAULT_CHAT_FRAME:AddMessage("  buffsMissing table exists, count: " .. table.getn(data.buffsMissing))
        else
            DEFAULT_CHAT_FRAME:AddMessage("  buffsMissing is NIL")
        end
    end
	
	-- Separate raid buffs from personal buffs
    local raidBuffsMissing = {}  -- [buffName] = {player1, player2, ...}
    local personalBuffsMissing = {}  -- [playerName] = {buff1, buff2, ...}
    
    for playerName, data in pairs(raidResults) do
        if data.buffsMissing then
            for i = 1, table.getn(data.buffsMissing) do
                local missingBuff = data.buffsMissing[i]
                
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
-- SEND TO RAID CHAT
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
-- SEND TO SELF (DEBUG)
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
-- INITIALIZATION
-- ============================================================================

function SS_RaidBuffAnnounce_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Raid Buff Announcements module loaded!|r")
end