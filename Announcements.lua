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
        
        -- Build line: "Flask of the Titans: PlayerA PlayerB PlayerC"
        local playerString = table.concat(playerList, " ")
        table.insert(lines, consumeName .. ": " .. playerString)
    end
    
    -- Sort lines alphabetically
    table.sort(lines)
    
    return lines
end

-- ============================================================================
-- SEND ANNOUNCEMENT TO CHAT
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
-- SEND TO SELF (DEBUG)
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
-- INITIALIZE
-- ============================================================================

function SS_Announce_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Announcements module loaded!|r")
end