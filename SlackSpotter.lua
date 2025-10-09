-- ============================================================================
-- SLACKSPOTTER - Core Lua File
-- All functions and variables use SS_ prefix for namespace isolation
-- ============================================================================

-- ============================================================================
-- GLOBAL STATE VARIABLES
-- ============================================================================
SS_CurrentTab = 1  -- Currently selected tab (1-6)
--Selected raid buffs for checking
SS_RaidBuffs_Selected = {
    Thorns = false,
    ShadowProtection = false,
    EmeraldBlessing = false
}

-- Protection potion list mode
SS_ListEveryoneProtection = false

-- Debug mode
SS_DebugMode = false

-- ============================================================================
-- FRAME INITIALIZATION
-- ============================================================================

function SS_InitializeFrame()
    -- Set frame alpha
    SS_Frame:SetAlpha(0.75)
    
    -- Set custom background alpha if it exists
    if SS_Frame_CustomBG then
        SS_Frame_CustomBG:SetAlpha(0.6)
    end
    
    -- Enable dragging
    SS_Frame:SetMovable(true)
    SS_Frame:EnableMouse(true)
    SS_Frame:RegisterForDrag("LeftButton")
    SS_Frame:SetScript("OnDragStart", function()
        SS_Frame:StartMoving()
    end)
    SS_Frame:SetScript("OnDragStop", function()
        SS_Frame:StopMovingOrSizing()
    end)
    
    -- Initialize to Tab 1
    SS_SelectTab(1)
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter loaded!|r Type /ss to open.")
end

-- ============================================================================
-- MINIMAP BUTTON
-- ============================================================================

function SS_CreateMinimapButton()
    local button = CreateFrame("Button", "SlackSpotterMinimapButton", Minimap)
    button:SetFrameStrata("MEDIUM")
    button:SetWidth(32)
    button:SetHeight(32)
    button:SetFrameLevel(8)
    
    -- Position (pfUI compatible)
    button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -15, 15)
    
    -- Icon
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetWidth(20)
    icon:SetHeight(20)
    icon:SetPoint("CENTER", 0, 1)
    icon:SetTexture("Interface\\AddOns\\SlackSpotter\\slackericoncircle")
    
    -- Border (Blizzard style)
    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetWidth(52)
    overlay:SetHeight(52)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT", 0, 0)
    
    -- Highlight
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    button:SetScript("OnClick", function()
        SS_ToggleFrame()
    end)
    
    button:SetScript("OnEnter", function()
    -- Create update function
    local function UpdateTooltip()
        GameTooltip:ClearLines()
        GameTooltip:AddLine("SlackSpotter", 0.2, 0.8, 1)
        if IsShiftKeyDown() then
            GameTooltip:AddLine("Advanced Options:", 1, 1, 1)
            GameTooltip:AddLine("- Scan all zones", 0.8, 0.8, 0.8)
            GameTooltip:AddLine("- Export report", 0.8, 0.8, 0.8)
        else
            GameTooltip:AddLine("Click to toggle addon", 1, 1, 1)
            GameTooltip:AddLine("Hold Shift for advanced options", 1, 0.5, 0)
        end
        GameTooltip:Show()
    end
    
    GameTooltip:SetOwner(button, "ANCHOR_LEFT")
    UpdateTooltip()
    
    -- Update tooltip on modifier key change
    button:SetScript("OnUpdate", function()
        if GameTooltip:IsOwned(button) then
            UpdateTooltip()
        else
            button:SetScript("OnUpdate", nil)
        end
    end)
end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

-- ============================================================================
-- DEBUG MODE TOGGLE
-- ============================================================================

function SS_Debug_Toggle()
    SS_DebugMode = not SS_DebugMode
    
    local checkbox = getglobal("SS_DebugButton")
    if checkbox then
        checkbox:SetChecked(SS_DebugMode)
    end
    
    -- Update Tab 6 display if currently visible
    if SS_CurrentTab == 6 and SS_ConsumeConfig_UpdateDisplay then
        SS_ConsumeConfig_UpdateDisplay()
    end
    
    if SS_DebugMode then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000Debug mode enabled|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000Debug mode disabled|r")
    end
end

-- ============================================================================
-- TAB MANAGEMENT
-- ============================================================================

function SS_SelectTab(tabNum)
    -- Dim all tabs
    for i = 1, 6 do
        local tab = getglobal("SS_Tab"..i)
        if tab then
            tab:SetAlpha(0.6)
            local tabText = getglobal("SS_Tab"..i.."Text")
            if tabText then
                tabText:SetTextColor(0.8, 0.8, 0.8)
            end
        end
    end
    
    -- Highlight selected tab
    local selectedTab = getglobal("SS_Tab"..tabNum)
    if selectedTab then
        selectedTab:SetAlpha(1.0)
        local selectedText = getglobal("SS_Tab"..tabNum.."Text")
        if selectedText then
            selectedText:SetTextColor(1, 1, 1)
        end
    end
    
    -- Hide all tab content
    SS_HideAllTabContent()
    
    -- Show selected tab content
    if tabNum == 1 then
        SS_ShowTab1Content()
    elseif tabNum == 2 then
        -- Show Tab 2
        local frame = getglobal("SS_Tab2_ShoutoutsFrame")
        if not frame then
            SS_Shoutouts_CreateUI()
            frame = getglobal("SS_Tab2_ShoutoutsFrame")
        end
        if frame then
            frame:Show()
        end
    elseif tabNum == 3 then
        -- TODO: SS_ShowTab3Content()
    elseif tabNum == 4 then
        -- TODO: SS_ShowTab4Content()
    elseif tabNum == 5 then
        -- Show Tab 5
        if SS_Tab5_ButtonPanel then SS_Tab5_ButtonPanel:Show() end
        if SS_Tab5_RaidListPanel then SS_Tab5_RaidListPanel:Show() end
        
        -- Auto-load specs on first view
        if SS_ConfigSpecs_AutoLoad then
            SS_ConfigSpecs_AutoLoad()
        end
    elseif tabNum == 6 then
        -- Show Tab 6
        if SS_Tab6_ControlPanel then SS_Tab6_ControlPanel:Show() end
        if SS_Tab6_ConsumeListPanel then SS_Tab6_ConsumeListPanel:Show() end
        
        -- Update button highlights
        if SS_ConsumeConfig_UpdateRaidButtons then
            SS_ConsumeConfig_UpdateRaidButtons()
        end
        if SS_ConsumeConfig_UpdateSpecButtons then
            SS_ConsumeConfig_UpdateSpecButtons()
        end
        
        -- Update display
        if SS_ConsumeConfig_UpdateDisplay then
            SS_ConsumeConfig_UpdateDisplay()
        end
    end
    
    SS_CurrentTab = tabNum
end

function SS_HideAllTabContent()
    -- Hide Tab 1 panels
    if SS_Tab1_RaidBuffCheckPanel then SS_Tab1_RaidBuffCheckPanel:Hide() end
    if SS_Tab1_ProtectionPotionPanel then SS_Tab1_ProtectionPotionPanel:Hide() end
	if SS_Tab1_ConsumeButtonCheckPanel then SS_Tab1_ConsumeButtonCheckPanel:Hide() end
    if SS_Tab1_StatsPanel then SS_Tab1_StatsPanel:Hide() end
    if SS_Tab1_RaidListPanel then SS_Tab1_RaidListPanel:Hide() end
    
    -- Hide Tab 2 panel
    if SS_Tab2_ShoutoutsFrame then SS_Tab2_ShoutoutsFrame:Hide() end
    
    -- Hide Tab 5 panels
    if SS_Tab5_ButtonPanel then SS_Tab5_ButtonPanel:Hide() end
    if SS_Tab5_RaidListPanel then SS_Tab5_RaidListPanel:Hide() end
    
    -- Hide Tab 6 panels
    if SS_Tab6_ControlPanel then SS_Tab6_ControlPanel:Hide() end
    if SS_Tab6_ConsumeListPanel then SS_Tab6_ConsumeListPanel:Hide() end
end

function SS_ShowTab1Content()
    -- Show all Tab 1 panels
    if SS_Tab1_RaidBuffCheckPanel then SS_Tab1_RaidBuffCheckPanel:Show() end
    if SS_Tab1_ProtectionPotionPanel then SS_Tab1_ProtectionPotionPanel:Show() end
    if SS_Tab1_ConsumeButtonCheckPanel then SS_Tab1_ConsumeButtonCheckPanel:Show() end
    if SS_Tab1_StatsPanel then SS_Tab1_StatsPanel:Show() end
    if SS_Tab1_RaidListPanel then SS_Tab1_RaidListPanel:Show() end
	
	SS_Tab1_UpdateInfoLabels()
end

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
-- TAB 1: STATS PANEL FUNCTIONS (BOTTOM-LEFT)
-- ============================================================================

function SS_Tab1_StatsPanel_RepPlusButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Rep+ clicked (placeholder)")
    -- TODO: Announce players with highest found consume count
end

function SS_Tab1_StatsPanel_RepMinusButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Rep- clicked (placeholder)")
    -- TODO: Announce players with highest missing consume count
end

function SS_Tab1_StatsPanel_ResetButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Reset Stats clicked (placeholder)")
    -- TODO: Reset all stats tracking
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
-- SLASH COMMANDS
-- ============================================================================

function SS_ToggleFrame()
    if SS_Frame:IsVisible() then
        SS_Frame:Hide()
    else
        SS_Frame:Show()
    end
end

SLASH_SS1 = "/ss"
SlashCmdList["SS"] = function(msg)
    
    if msg == "" then
        SS_ToggleFrame()
        return
    end
    
    -- Parse arguments
    local args = {}
    local _, _, remainder = string.find(msg, "^%s*(.*)")
    if remainder then
        local pattern = "([^%s]+)"
        local start = 1
        while start <= string.len(remainder) do
            local _, finish, match = string.find(remainder, pattern, start)
            if not match then break end
            table.insert(args, match)
            start = finish + 1
            -- Skip spaces
            while start <= string.len(remainder) and string.sub(remainder, start, start) == " " do
                start = start + 1
            end
        end
    end
    
    -- Try Shoutouts command handler first (for colored messages)
    if SS_Shoutouts_HandleCommand and SS_Shoutouts_HandleCommand(args) then
        return
    end
    
    -- Unknown command
    DEFAULT_CHAT_FRAME:AddMessage("|cffFF8000SlackSpotter:|r Unknown command.")
    DEFAULT_CHAT_FRAME:AddMessage("|cffFFFFFF/ss|r - Toggle addon")
    DEFAULT_CHAT_FRAME:AddMessage("|cffFFFFFF/ss <channel> <color> <message>|r - Send colored message")
end

-- ============================================================================
-- EVENT HANDLING
-- ============================================================================

-- Prevent double-initialization
if not SlackSpotter_Initialized then
    SlackSpotter_Initialized = false
end

local SS_EventFrame = CreateFrame("Frame")
SS_EventFrame:RegisterEvent("ADDON_LOADED")
SS_EventFrame:SetScript("OnEvent", function()



    if event == "ADDON_LOADED" and arg1 == "SlackSpotter" then
	        -- Check if already initialized this session
        if SlackSpotter_Initialized then
            return
        end
        SlackSpotter_Initialized = true
        -- Unregister immediately to prevent double-fire
        SS_EventFrame:UnregisterEvent("ADDON_LOADED")
        
        -- Initialize main frame (after XML loaded)
        SS_InitializeFrame()
		
		-- Create minimap button
    SS_CreateMinimapButton()
        
        -- Initialize MappingData module
        if SS_MappingData_Initialize then
            SS_MappingData_Initialize()
        end
		
		-- Initialize Shoutouts module
        if SS_Shoutouts_Initialize then
            SS_Shoutouts_Initialize()
        end
        
        -- Initialize ConfigSpecs module
        if SS_ConfigSpecs_Initialize then
            SS_ConfigSpecs_Initialize()
        end
        
        -- Initialize ConsumeConfig module
        if SS_ConsumeConfig_Initialize then
            SS_ConsumeConfig_Initialize()
        end
        
        -- Initialize CheckConsumes module
        if SS_Check_Initialize then
            SS_Check_Initialize()
        end
		
		-- Initialize RaidBuff module
        if SS_RaidBuff_Initialize then
            SS_RaidBuff_Initialize()
        end
        
        -- Initialize Display module
        if SS_Display_Initialize then
            SS_Display_Initialize()
        end
        
        -- Initialize Announcements module
        if SS_Announce_Initialize then
            SS_Announce_Initialize()
        end
        
        -- Auto-load consume config from SavedVariables
        if SS_ConsumeConfig_AutoLoad then
            SS_ConsumeConfig_AutoLoad()
        end
        
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter addon loaded successfully!|r")
    end
end)