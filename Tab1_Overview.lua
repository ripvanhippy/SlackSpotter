-- ============================================================================
-- SLACKSPOTTER - Tab 1 Coding
-- ============================================================================

-- ============================================================================
-- GLOBAL STATE VARIABLES
-- ============================================================================

SS_RaidBuffs_Selected = {
    Thorns = false,
    ShadowProtection = false,
    EmeraldBlessing = false
}

-- Protection potion list mode
SS_ListEveryoneProtection = false

-- ============================================================================
-- TAB 1: RAID BUFF CHECK PANEL FUNCTIONS (TOP-LEFT)
-- ============================================================================

function SS_Tab1_RaidBuffCheckPanel_ThornsCheckbox_OnClick()
    SS_RaidBuffs_Selected.Thorns = this:GetChecked()
end

function SS_Tab1_RaidBuffCheckPanel_ShadowProtCheckbox_OnClick()
    SS_RaidBuffs_Selected.ShadowProtection = this:GetChecked()
end

function SS_Tab1_RaidBuffCheckPanel_EmeraldBlessCheckbox_OnClick()
    SS_RaidBuffs_Selected.EmeraldBlessing = this:GetChecked()
end

function SS_Tab1_RaidBuffCheckPanel_RaidBuffCheckButton_OnClick()
    local consumeResults, buffResults, raidInstance = SS_Tab1_RefreshAndCheckAll()
    
    -- Announce raid buffs only
    SS_RaidBuffAnnounce_SendToRaid(buffResults)
end

function SS_Tab1_RaidBuffCheckPanel_ConsumeCheckButton_OnClick()
    local consumeResults, buffResults, raidInstance = SS_Tab1_RefreshAndCheckAll()
    
    -- Announce consumes only
    SS_Announce_SendToRaid(consumeResults, raidInstance)
    
    -- Record stats if enabled
    if SS_Stats_RecordConsumeCheck then
        SS_Stats_RecordConsumeCheck(consumeResults)
    end
end

-- ============================================================================
-- HELPER: Check for Greater Protection Potions
-- ============================================================================
function SS_CheckGreaterProtectionPotion(protectionType)
    -- Get raid size
    local numRaidMembers = GetNumRaidMembers()
    local totalMembers = (numRaidMembers > 0) and numRaidMembers or (GetNumPartyMembers() + 1)
    
    local missingPlayers = {}
    
    -- Check each member
    for i = 1, totalMembers do
        local name, class, unitID
        
        if numRaidMembers > 0 then
            name, _, _, _, class = GetRaidRosterInfo(i)
            class = SS_ConfigSpecs_ProperCase(class)
            unitID = "raid" .. i
        else
            if i == 1 then
                name = UnitName("player")
                _, class = UnitClass("player")
                class = SS_ConfigSpecs_ProperCase(class)
                unitID = "player"
            else
                name = UnitName("party" .. (i-1))
                _, class = UnitClass("party" .. (i-1))
                class = SS_ConfigSpecs_ProperCase(class)
                unitID = "party" .. (i-1)
            end
        end
        
        if name and UnitIsConnected(unitID) then
            local hasGreaterProt = false
            
            -- Scan buffs
            for buffIndex = 1, 32 do
                local buffTexture = UnitBuff(unitID, buffIndex)
                if not buffTexture then break end
                
                -- Create tooltip if needed
                if not SS_TooltipScanner then
                    SS_TooltipScanner = CreateFrame("GameTooltip", "SS_TooltipScanner", nil, "GameTooltipTemplate")
                    SS_TooltipScanner:SetOwner(WorldFrame, "ANCHOR_NONE")
                end
                
                SS_TooltipScanner:ClearLines()
                SS_TooltipScanner:SetUnitBuff(unitID, buffIndex)
                local buffNameText = getglobal("SS_TooltipScannerTextLeft1")
                local buffName = buffNameText and buffNameText:GetText()
                
                -- Check if it matches protection type
                if buffName and string.find(buffName, protectionType) and string.find(buffName, "Protection") then
                    -- Check tooltip for "Absorbs 1950" (Greater version)
                    local isGreater = false
                    for line = 1, SS_TooltipScanner:NumLines() do
                        local lineText = getglobal("SS_TooltipScannerTextLeft" .. line)
                        if lineText and lineText:GetText() then
                            if string.find(lineText:GetText(), "Absorbs 1950") then
                                isGreater = true
                                break
                            end
                        end
                    end
                    
                    if isGreater then
                        hasGreaterProt = true
                        break
                    end
                end
            end
            
            if not hasGreaterProt then
                table.insert(missingPlayers, {name = name, class = class})
            end
        end
    end
    
    -- Announce results
    SS_Announce_ProtectionPotions(protectionType, missingPlayers)
	-- record stats
	SS_Stats_RecordProtPotCheck(protectionType, missingPlayers)
end 

-- ============================================================================
-- TAB 1: PROTECTION POTION PANEL FUNCTIONS (MIDDLE-LEFT)
-- ============================================================================

function SS_Tab1_ProtectionPotionPanel_ProtPotArcaneButton_OnClick()
    SS_CheckGreaterProtectionPotion("Arcane")
end

function SS_Tab1_ProtectionPotionPanel_ProtPotFireButton_OnClick()
    SS_CheckGreaterProtectionPotion("Fire")
end

function SS_Tab1_ProtectionPotionPanel_ProtPotFrostButton_OnClick()
    SS_CheckGreaterProtectionPotion("Frost")
end

function SS_Tab1_ProtectionPotionPanel_ProtPotNatureButton_OnClick()
    SS_CheckGreaterProtectionPotion("Nature")
end

function SS_Tab1_ProtectionPotionPanel_ProtPotShadowButton_OnClick()
    SS_CheckGreaterProtectionPotion("Shadow")
end

function SS_Tab1_ProtectionPotionPanel_ProtPotHolyButton_OnClick()
    SS_CheckGreaterProtectionPotion("Holy")
end

function SS_Tab1_ProtectionPotionPanel_ListEveryoneCheckbox_OnClick()
    SS_ListEveryoneProtection = not SS_ListEveryoneProtection
end

-- ============================================================================
-- HELPER: Check for Greater Protection Potions (with stats recording)
-- ============================================================================
function SS_CheckGreaterProtectionPotion(protectionType)
    -- Get raid size
    local numRaidMembers = GetNumRaidMembers()
    local totalMembers = (numRaidMembers > 0) and numRaidMembers or (GetNumPartyMembers() + 1)
    
    local missingPlayers = {}
    
    -- Check each member
    for i = 1, totalMembers do
        local name, class, unitID
        
        if numRaidMembers > 0 then
            name, _, _, _, class = GetRaidRosterInfo(i)
            class = SS_ConfigSpecs_ProperCase(class)
            unitID = "raid" .. i
        else
            if i == 1 then
                name = UnitName("player")
                _, class = UnitClass("player")
                class = SS_ConfigSpecs_ProperCase(class)
                unitID = "player"
            else
                name = UnitName("party" .. (i-1))
                _, class = UnitClass("party" .. (i-1))
                class = SS_ConfigSpecs_ProperCase(class)
                unitID = "party" .. (i-1)
            end
        end
        
        if name and UnitIsConnected(unitID) then
            local hasGreaterProt = false
            
            -- Scan buffs
            for buffIndex = 1, 32 do
                local buffTexture = UnitBuff(unitID, buffIndex)
                if not buffTexture then break end
                
                -- Create tooltip if needed
                if not SS_TooltipScanner then
                    SS_TooltipScanner = CreateFrame("GameTooltip", "SS_TooltipScanner", nil, "GameTooltipTemplate")
                    SS_TooltipScanner:SetOwner(WorldFrame, "ANCHOR_NONE")
                end
                
                SS_TooltipScanner:ClearLines()
                SS_TooltipScanner:SetUnitBuff(unitID, buffIndex)
                local buffNameText = getglobal("SS_TooltipScannerTextLeft1")
                local buffName = buffNameText and buffNameText:GetText()
                
                -- Check if it matches protection type
                if buffName and string.find(buffName, protectionType) and string.find(buffName, "Protection") then
                    -- Check tooltip for "Absorbs 1950" (Greater version)
                    local isGreater = false
                    for line = 1, SS_TooltipScanner:NumLines() do
                        local lineText = getglobal("SS_TooltipScannerTextLeft" .. line)
                        if lineText and lineText:GetText() then
                            if string.find(lineText:GetText(), "Absorbs 1950") then
                                isGreater = true
                                break
                            end
                        end
                    end
                    
                    if isGreater then
                        hasGreaterProt = true
                        break
                    end
                end
            end
            
            if not hasGreaterProt then
                table.insert(missingPlayers, {name = name, class = class})
            end
        end
    end
    
    -- Announce results
    SS_Announce_ProtectionPotions(protectionType, missingPlayers)
    
    -- Record stats if enabled
    if SS_Stats_RecordProtPotCheck then
        SS_Stats_RecordProtPotCheck(protectionType, missingPlayers)
    end
end

-- ============================================================================
-- HELPER: Refresh raid data and check consumes + buffs
-- ============================================================================
function SS_Tab1_RefreshAndCheckAll()
    -- Auto-refresh Tab 5 specs first
    if SS_ConfigSpecs_RefreshRaid then
        SS_ConfigSpecs_RefreshRaid()
    end
    if SS_ConfigSpecs_AutoLoadSavedSpecs then
        SS_ConfigSpecs_AutoLoadSavedSpecs()
    end
    
    local raidInstance = SS_ConsumeConfig_CurrentRaid or "Kara40"
    
    -- Run consume check
    local consumeResults = SS_Check_CheckEntireRaid(raidInstance)
    
    -- Run raid buff check
    local buffResults = SS_RaidBuff_CheckEntireRaid()
    
    -- Merge results for display
    for playerName, consumeData in pairs(consumeResults) do
        local buffData = buffResults[playerName]
        if buffData then
            consumeData.buffsFound = buffData.buffsFound
            consumeData.buffsRequired = buffData.buffsRequired
            consumeData.buffsMissing = buffData.missing
            consumeData.class = buffData.class
        end
    end
    
    -- Add players who have buff results but no consume results
    for playerName, buffData in pairs(buffResults) do
        if not consumeResults[playerName] then
            consumeResults[playerName] = {
                class = buffData.class,
                spec = buffData.spec,
                found = 0,
                required = 0,
                missing = {},
                passed = true,
                buffsFound = buffData.buffsFound,
                buffsRequired = buffData.buffsRequired,
                buffsMissing = buffData.missing
            }
        end
    end
    
    -- Store merged results and display
    SS_Display_RaidResults = consumeResults
    SS_Display_UpdateRaidList()
    
	SS_Tab1_UpdateInfoLabels()
	
    return consumeResults, buffResults, raidInstance
end

-- ============================================================================
-- UPDATE TAB 1 INFO LABELS
-- ============================================================================
function SS_Tab1_UpdateInfoLabels()
    local raidLabel = getglobal("SS_Tab1_ConsumeButtonCheckPanel_RaidLabel")
    local specLabel = getglobal("SS_Tab1_ConsumeButtonCheckPanel_SpecLabel")
    
    if raidLabel then
        raidLabel:SetText("Current Raid: " .. (SS_ConsumeConfig_CurrentRaid or "Kara40"))
    end
    
    if specLabel then
        local noSpecCount = 0
        if SS_ConfigSpecs_RaidMembers then
            for i = 1, table.getn(SS_ConfigSpecs_RaidMembers) do
                local member = SS_ConfigSpecs_RaidMembers[i]
                if member and not SS_ConfigSpecs_SelectedSpecs[member.name] then
                    noSpecCount = noSpecCount + 1
                end
            end
        end
        specLabel:SetText("Missing Specs: " .. noSpecCount)
    end
end

-- ============================================================================
-- TAB 1: RAID LIST PANEL FUNCTIONS (RIGHT-SIDE)
-- ============================================================================

function SS_Tab1_RaidListPanel_RefreshButton_OnClick()
    local consumeResults, buffResults, raidInstance = SS_Tab1_RefreshAndCheckAll()
    
	-- Store results for display
    SS_Display_RaidResults = consumeResults
	
    -- Show summary in chat
    local totalPassed = 0
    local totalChecked = 0
    for _, data in pairs(consumeResults) do
        totalChecked = totalChecked + 1
        if data.passed then totalPassed = totalPassed + 1 end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Check complete: " .. totalPassed .. "/" .. totalChecked .. " passed consumes|r")
end

function SS_Tab1_RaidListPanel_ScrollFrame_Update()
    SS_Display_UpdateRaidList()
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function Tab1_Overview_Initialize()
--    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Tab 1 Overview module loaded!|r")
end