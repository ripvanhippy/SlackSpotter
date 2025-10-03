-- ============================================================================
-- SLACKSPOTTER - Core Lua File
-- All functions and variables use SS_ prefix for namespace isolation
-- ============================================================================

-- ============================================================================
-- GLOBAL STATE VARIABLES
-- ============================================================================
SS_CurrentTab = 1  -- Currently selected tab (1-6)

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
    DEFAULT_CHAT_FRAME:AddMessage("Thorns checkbox clicked (placeholder)")
    -- TODO: Implement thorns checking logic
end

function SS_Tab1_RaidBuffCheckPanel_ShadowProtCheckbox_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Shadow Protection checkbox clicked (placeholder)")
    -- TODO: Implement shadow prot checking logic
end

function SS_Tab1_RaidBuffCheckPanel_EmeraldBlessCheckbox_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Emerald Blessing checkbox clicked (placeholder)")
    -- TODO: Implement emerald blessing checking logic
end

function SS_Tab1_RaidBuffCheckPanel_RaidBuffCheckButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Raid Buff Check clicked (placeholder)")
    -- TODO: Check and announce raid buffs
end

function SS_Tab1_RaidBuffCheckPanel_ConsumeCheckButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage("Consume Check clicked - announcing to raid (placeholder)")
    -- TODO: This triggers the old "To Raid" logic (announce missing consumes)
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
    DEFAULT_CHAT_FRAME:AddMessage("Refresh clicked - loading raid and checking (placeholder)")
    -- TODO: This triggers old "Consumecheck" logic:
    -- 1. Load current raid members
    -- 2. Check all consumes
    -- 3. Check all raid buffs
    -- 4. Update the table display
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

local SS_EventFrame = CreateFrame("Frame")
SS_EventFrame:RegisterEvent("ADDON_LOADED")
SS_EventFrame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "SlackSpotter" then
        -- Initialize main frame (after XML loaded)
        SS_InitializeFrame()
        
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
        
        -- Auto-load consume config from SavedVariables
        if SS_ConsumeConfig_AutoLoad then
            SS_ConsumeConfig_AutoLoad()
        end
        
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter addon loaded successfully!|r")
    end
end)