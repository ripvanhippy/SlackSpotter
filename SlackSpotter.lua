-- ============================================================================
-- SLACKSPOTTER - Core Lua File
-- All functions and variables use SS_ prefix for namespace isolation
-- ============================================================================

-- ============================================================================
-- GLOBAL STATE VARIABLES
-- ============================================================================
SS_CurrentTab = 1  -- Currently selected tab (1-6)
--Selected raid buffs for checking

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
    
    -- Initialize raid tab highlights (default Kara40)
    SS_UpdateRaidTabHighlights()
	
	-- Style header tabs
    local leftHeader = getglobal("SS_LeftTab_Header")
    if leftHeader then
        leftHeader:Disable()
        leftHeader:LockHighlight()
        leftHeader:SetAlpha(1.0)
        local textRegion = SS_LeftTab_Header:GetFontString()
if textRegion then
    textRegion:SetTextColor(1.0, 0.5, 0.0)
end

    end
    
    local raidHeader = getglobal("SS_RaidTab_Header")
    if raidHeader then
        raidHeader:Disable()
        raidHeader:LockHighlight()
        raidHeader:SetAlpha(1.0)
		local textRegion = SS_RaidTab_Header:GetFontString()
if textRegion then
    textRegion:SetTextColor(1.0, 0.5, 0.0)
end

    end
	
	-- Initialize left tab highlights
    if SS_UpdateLeftTabHighlights then
        SS_UpdateLeftTabHighlights()
    end
    
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
            GameTooltip:AddLine("Advanced Functionality", 1, 1, 1)
			GameTooltip:AddLine("- upcomming: do consume or buffchecks with '/ss <Buff>' etc.", 0.8, 0.8, 0.8)
			GameTooltip:AddLine("- this is placeholder text!", 0.8, 0.8, 0.8)
        else
            GameTooltip:AddLine("Click to toggle addon or type /ss", 1, 1, 1)
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
    for i = 1, 8 do
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
		-- Auto-refresh overview (includes raid list refresh)
		if SS_Tab1_RefreshAndCheckAll then
            SS_Tab1_RefreshAndCheckAll()
		end
    elseif tabNum == 2 then
        -- Show Tab 2
        if SS_Shoutouts_ShowTab then
            SS_Shoutouts_ShowTab()
        end
    elseif tabNum == 3 then
        if SS_Tab3_CooldownPanel then SS_Tab3_CooldownPanel:Show() end
        if SS_Tab3_CDTrackerPanel then SS_Tab3_CDTrackerPanel:Show() end
        if SS_Cooldowns_UpdateDisplay then
            SS_Cooldowns_UpdateDisplay()
        end
	elseif tabNum == 4 then
        -- Show Tab 4 (Tactics)
        if SS_Tactics_ShowTab then
            SS_Tactics_ShowTab()
        end
    elseif tabNum == 5 then
		-- Auto-refresh raid list BEFORE showing tab
        if SS_ConfigSpecs_RefreshRaid then
            SS_ConfigSpecs_RefreshRaid()
		end
        if SS_ConfigSpecs_ShowTab then
            SS_ConfigSpecs_ShowTab()
        end
    elseif tabNum == 6 then
        -- Show Tab 6
        if SS_Tab6_ControlPanel then SS_Tab6_ControlPanel:Show() end
        if SS_Tab6_ConsumeListPanel then SS_Tab6_ConsumeListPanel:Show() end
        
        -- Update spec button highlights
        if SS_ConsumeConfig_UpdateSpecButtons then
            SS_ConsumeConfig_UpdateSpecButtons()
        end
        
        -- Update display
        if SS_ConsumeConfig_UpdateDisplay then
            SS_ConsumeConfig_UpdateDisplay()
        end
        
        -- Update Tab 4 boss buttons if raid changed (for next time Tab 4 is opened)
        if SS_Tactics_SyncRaidSelection and SS_ConsumeConfig_CurrentRaid then
            SS_Tactics_SyncRaidSelection(SS_ConsumeConfig_CurrentRaid)
        end
		-- Update master/slave UI
        if SS_ConsumeConfig_UpdateMasterSlaveUI then
            SS_ConsumeConfig_UpdateMasterSlaveUI()
        end
	elseif tabNum == 7 then	
	    -- Show Tab 7 Stats Tab
		SS_ShowTab7Content()

		--PLACEHOLDER END
		
	elseif tabNum == 8 then	
	    -- Show Tab 8 Help Tab Frame
		SS_ShowTab8Content()
	
    end
    
    SS_CurrentTab = tabNum
end

-- RAID SELECTION (RIGHT-SIDE TABS)
function SS_SelectRaid(raidName)
    -- Update global raid selection variable
    SS_ConsumeConfig_CurrentRaid = raidName
    
    -- Update right-side raid tab highlights
    SS_UpdateRaidTabHighlights()
    
    -- Update Tab 6 (Consume Config) if currently visible
    if SS_CurrentTab == 6 then
        if SS_ConsumeConfig_UpdateSpecButtons then
            SS_ConsumeConfig_UpdateSpecButtons()
        end
        if SS_ConsumeConfig_LoadSpecData then
            SS_ConsumeConfig_LoadSpecData()
        end
        if SS_ConsumeConfig_UpdateDisplay then
            SS_ConsumeConfig_UpdateDisplay()
        end
    end
    
    -- Update Tab 1 if currently visible (future use)
    if SS_CurrentTab == 1 then
        -- Future: refresh consume checks for new raid
    end
	
	-- Sync to Tactics tab 4
    if SS_Tactics_SyncRaidSelection then
        SS_Tactics_SyncRaidSelection(raidName)
    end
	
	-- Trigger sync if master
    if SS_MasterSlave_IsMaster then
        SS_MasterSlave_TriggerSync()
    end
end

function SS_UpdateRaidTabHighlights()
    local raidTabs = {"Kara40", "Naxx", "AQ40", "BWL", "MC", "ES", "Ony", "ZG", "AQ20", "Kara10"}
    
    for i = 1, table.getn(raidTabs) do
        local raidName = raidTabs[i]
        local tabButton = getglobal("SS_RaidTab_" .. raidName)
        
        if tabButton then
            if raidName == SS_ConsumeConfig_CurrentRaid then
                tabButton:SetAlpha(1.0)
                tabButton:LockHighlight()
            else
                tabButton:SetAlpha(0.6)
                tabButton:UnlockHighlight()
            end
        end
    end
end

function SS_HideAllTabContent()
    -- Hide Tab 1 panels
    if SS_Tab1_RaidBuffCheckPanel then SS_Tab1_RaidBuffCheckPanel:Hide() end
    if SS_Tab1_ProtectionPotionPanel then SS_Tab1_ProtectionPotionPanel:Hide() end
	if SS_Tab1_ConsumeButtonCheckPanel then SS_Tab1_ConsumeButtonCheckPanel:Hide() end
    if SS_Tab1_RaidListPanel then SS_Tab1_RaidListPanel:Hide() end
    
    -- Hide Tab 2 panels
    if SS_Tab2_ChannelPanel then SS_Tab2_ChannelPanel:Hide() end
    if SS_Tab2_ColorPanel then SS_Tab2_ColorPanel:Hide() end
    if SS_Tab2_MessagePanel then SS_Tab2_MessagePanel:Hide() end
    if SS_Tab2_CountdownPanel then SS_Tab2_CountdownPanel:Hide() end
	
	-- Hide Tab 3 panels
    if SS_Tab3_CooldownPanel then SS_Tab3_CooldownPanel:Hide() end
    if SS_Tab3_CDTrackerPanel then SS_Tab3_CDTrackerPanel:Hide() end
    
    -- Hide Tab 4 panels
    if SS_Tab4_BossPanel then SS_Tab4_BossPanel:Hide() end
    if SS_Tab4_StrategyPanel then SS_Tab4_StrategyPanel:Hide() end
    if SS_Tab4_RolePanel then SS_Tab4_RolePanel:Hide() end
    if SS_Tab4_ImagesPanel then SS_Tab4_ImagesPanel:Hide() end
	if SS_Tab4_TrashPanel then SS_Tab4_TrashPanel:Hide() end
	if SS_Tab4_PortPanel then SS_Tab4_PortPanel:Hide() end
    
    -- Hide Tab 5 panels
    if SS_ConfigSpecs_HideTab then
        SS_ConfigSpecs_HideTab()
    end
    
    -- Hide Tab 6 panels
    if SS_Tab6_ControlPanel then SS_Tab6_ControlPanel:Hide() end
    if SS_Tab6_ConsumeListPanel then SS_Tab6_ConsumeListPanel:Hide() end
	
	-- Hide Tab 7 panels
	if SS_Tab7_StatsPanel then SS_Tab7_StatsPanel:Hide() end
	
	-- Hide Tab 8 panels
	if SS_Tab8_HelpPanel then SS_Tab8_HelpPanel:Hide() end
end

function SS_ShowTab1Content()
    -- Show all Tab 1 panels
    if SS_Tab1_RaidBuffCheckPanel then SS_Tab1_RaidBuffCheckPanel:Show() end
    if SS_Tab1_ProtectionPotionPanel then SS_Tab1_ProtectionPotionPanel:Show() end
    if SS_Tab1_ConsumeButtonCheckPanel then SS_Tab1_ConsumeButtonCheckPanel:Show() end
    if SS_Tab1_RaidListPanel then SS_Tab1_RaidListPanel:Show() end
	
	SS_Tab1_UpdateInfoLabels()
end

function SS_ShowTab7Content()
    if SS_Tab7_StatsPanel then SS_Tab7_StatsPanel:Show() end
end

-- ============================================================================
-- LEFT-SIDE SHORTCUT TAB FUNCTIONS
-- ============================================================================

function SS_LeftTab_ToggleWhisperSpec()
    local checkbox = getglobal("SS_Tab5_WhisperSpecPanel_EnableCheckbox")
    if checkbox then
        local newState = not checkbox:GetChecked()
        checkbox:SetChecked(newState)
        SS_ConfigSpecs_WhisperSpecEnabled = newState
        
        -- Save to DB
        if not SS_GuildSpecsDB then
            SS_GuildSpecsDB = {}
        end
        SS_GuildSpecsDB["_whisperSpecEnabled"] = newState
        
        -- Update Tab 5 UI
        if SS_ConfigSpecs_WhisperSpec_UpdateUI then
            SS_ConfigSpecs_WhisperSpec_UpdateUI()
        end
        
        -- Update left tab highlight
        SS_UpdateLeftTabHighlights()
    end
end

function SS_LeftTab_ToggleCDTracker()
    -- Toggle CD tracking for Tab 3 only (not RL Helper)
    if SS_Cooldowns_Enabled then
        SS_Cooldowns_Disable()
    else
        SS_Cooldowns_Enable()
    end
    
    -- Update left tab highlight
    SS_UpdateLeftTabHighlights()
end

function SS_LeftTab_ToggleRLHelper()
    -- Check both windows state
    local displayOpen = SS_RLHelper_IsOpen
    local optionsOpen = SS_RLHelper_OptionsIsOpen
    
    if displayOpen and optionsOpen then
        -- Both open → close both
        if SS_RLHelper_Toggle then SS_RLHelper_Toggle() end
        if SS_RLHelper_ToggleOptions then SS_RLHelper_ToggleOptions() end
    elseif not displayOpen and not optionsOpen then
        -- Both closed → open both
        if SS_RLHelper_Toggle then SS_RLHelper_Toggle() end
        if SS_RLHelper_ToggleOptions then SS_RLHelper_ToggleOptions() end
    elseif displayOpen and not optionsOpen then
        -- Display open, options closed → open options
        if SS_RLHelper_ToggleOptions then SS_RLHelper_ToggleOptions() end
    elseif not displayOpen and optionsOpen then
        -- Options open, display closed → open display
        if SS_RLHelper_Toggle then SS_RLHelper_Toggle() end
    end
end

function SS_LeftTab_ToggleStatsRec()
    SS_Stats_Toggle()
    
    -- Update left tab highlight
    if SS_UpdateLeftTabHighlights then
        SS_UpdateLeftTabHighlights()
    end
end

function SS_UpdateLeftTabHighlights()
    -- Whisper Spec tab
    local wsTab = getglobal("SS_LeftTab_WhisperSpec")
    if wsTab then
        if SS_ConfigSpecs_WhisperSpecEnabled then
            wsTab:SetAlpha(1.0)
            wsTab:LockHighlight()
        else
            wsTab:SetAlpha(0.6)
            wsTab:UnlockHighlight()
        end
    end
    
    -- CD Tracker tab
    local cdTab = getglobal("SS_LeftTab_CDTracker")
    if cdTab then
        if SS_Cooldowns_Enabled then
            cdTab:SetAlpha(1.0)
            cdTab:LockHighlight()
        else
            cdTab:SetAlpha(0.6)
            cdTab:UnlockHighlight()
        end
    end
	
	-- Stats Recorder tab
    local statsTab = getglobal("SS_LeftTab_StatsRec")
    if statsTab then
        if SS_Stats_Enabled then
            statsTab:SetAlpha(1.0)
            statsTab:LockHighlight()
        else
            statsTab:SetAlpha(0.6)
            statsTab:UnlockHighlight()
        end
    end
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
    
	-- Try MasterSlave command handler first
    if SS_MasterSlave_Command and SS_MasterSlave_Command(args) then
        return
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
SS_EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
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
        
        -- Initialize all modules
        local modules = {
            {name = "MappingData", func = SS_MappingData_Initialize},
			{name = "Overview", func = Tab1_Overview_Initialize},
            {name = "Shoutouts", func = SS_Shoutouts_Initialize},
            {name = "ConfigSpecs", func = SS_ConfigSpecs_Initialize},
            {name = "ConsumeConfig", func = SS_ConsumeConfig_Initialize},
            {name = "Tactics", func = SS_Tactics_Initialize},
            {name = "CheckConsumes", func = SS_Check_Initialize},
            {name = "RaidBuff", func = SS_RaidBuff_Initialize},
            {name = "Display", func = SS_Display_Initialize},
            {name = "Announcements", func = SS_Announce_Initialize},
			{name = "RLHelper", func = SS_RLHelper_Initialize},
			{name = "Cooldowns", func = SS_Cooldowns_Initialize},
			{name = "MasterSlave", func = SS_MasterSlave_Initialize},
			{name = "Stats", func = SS_Stats_Initialize},
			{name = "Help", func = SS_Help_Initialize}
			
        }
        
        local loaded = 0
        local failed = {}
        
        for i = 1, table.getn(modules) do
            if modules[i].func then
                modules[i].func()
                loaded = loaded + 1
            else
                table.insert(failed, modules[i].name)
            end
        end
        
        local statusMsg = "|cff00ff00SlackSpotter modules loaded: " .. loaded .. "/" .. table.getn(modules) .. "|r"
        DEFAULT_CHAT_FRAME:AddMessage(statusMsg)
        
        if table.getn(failed) > 0 then
            local failedMsg = "|cffff0000Failed to load: " .. table.concat(failed, ", ") .. "|r"
            DEFAULT_CHAT_FRAME:AddMessage(failedMsg)
        end
        
        -- Auto-load consume config from SavedVariables
        if SS_ConsumeConfig_AutoLoad then
            SS_ConsumeConfig_AutoLoad()
        end
		
		-- Preselect Kara40
        SS_SelectRaid("Kara40")
		
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Create boss buttons when player fully loaded
        if SS_Tactics_CreateBossButtons then
            SS_Tactics_CreateBossButtons()
        end
    end
end)
