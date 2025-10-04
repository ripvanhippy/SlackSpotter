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
    if SS_Tab1_StatsPanel then SS_Tab1_StatsPanel:Show() end
    if SS_Tab1_RaidListPanel then SS_Tab1_RaidListPanel:Show() end
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
    -- Auto-refresh: check buffs before announcing
    local buffResults = SS_RaidBuff_CheckEntireRaid()
    
    -- Send announcements
    if GetNumRaidMembers() > 0 then
        SS_RaidBuffAnnounce_SendToRaid(buffResults)
    else
        SS_RaidBuffAnnounce_SendToSelf(buffResults)
    end
end

function SS_Tab1_RaidBuffCheckPanel_ConsumeCheckButton_OnClick()
    -- Auto-refresh: Run consume check before announcing
    -- This ensures we always have current data even if user forgot to click Refresh
    local raidInstance = SS_ConsumeConfig_CurrentRaid or "Kara40"
    local results = SS_Check_CheckEntireRaid(raidInstance)
    
    -- Store results for display
    SS_Display_RaidResults = results
    SS_Display_UpdateRaidList()
    
    -- Check if we have any results
    if not results or not next(results) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000No raid members to check!|r")
        return
    end
    
    -- Send announcement to appropriate channel
    if GetNumRaidMembers() > 0 then
        -- In raid: send to raid chat
        SS_Announce_SendToRaid(results, raidInstance)
    else
        -- Solo: send to self (chat window)
        SS_Announce_SendToSelf(results, raidInstance)
    end
end

-- ============================================================================
-- TAB 1: PROTECTION POTION PANEL FUNCTIONS (MIDDLE-LEFT)
-- ============================================================================

function SS_Tab1_ProtectionPotionPanel_ProtPotArcaneButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Checking Arcane Protection Potions (placeholder)")
    -- TODO: Implement arcane protection check
end

function SS_Tab1_ProtectionPotionPanel_ProtPotFireButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Checking Fire Protection Potions (placeholder)")
    -- TODO: Implement fire protection check
end

function SS_Tab1_ProtectionPotionPanel_ProtPotFrostButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Checking Frost Protection Potions (placeholder)")
    -- TODO: Implement frost protection check
end

function SS_Tab1_ProtectionPotionPanel_ProtPotNatureButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Checking Nature Protection Potions (placeholder)")
    -- TODO: Implement nature protection check
end

function SS_Tab1_ProtectionPotionPanel_ProtPotShadowButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Checking Shadow Protection Potions (placeholder)")
    -- TODO: Implement shadow protection check
end

function SS_Tab1_ProtectionPotionPanel_ProtPotHolyButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Checking Holy Protection Potions (placeholder)")
    -- TODO: Implement holy protection check
end

function SS_Tab1_ProtectionPotionPanel_ListEveryoneCheckbox_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("List Everyone checkbox clicked (placeholder)")
    -- TODO: Toggle list everyone mode
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
-- TAB 1: RAID LIST PANEL FUNCTIONS (RIGHT-SIDE)
-- ============================================================================

function SS_Tab1_RaidListPanel_RefreshButton_OnClick()
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
            consumeData.class = buffData.class  -- Ensure class is set
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
    -- TODO: Update visible raid member rows based on scroll position
    DEFAULT_CHAT_FRAME:AddMessage("Scroll update (placeholder)")
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
        
        -- Initialize RaidBuffAnnounce module
        if SS_RaidBuffAnnounce_Initialize then
            SS_RaidBuffAnnounce_Initialize()
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