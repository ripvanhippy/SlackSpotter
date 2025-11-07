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
    
    -- Initialize raid tab highlights (default Kara40)
    SS_UpdateRaidTabHighlights()
    
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
    elseif tabNum == 2 then
        -- Show Tab 2
        if SS_Shoutouts_ShowTab then
            SS_Shoutouts_ShowTab()
        end
    elseif tabNum == 3 then
        if SS_Cooldowns_ShowTab then
            SS_Cooldowns_ShowTab()
        end
	elseif tabNum == 4 then
        -- Show Tab 4 (Tactics)
        if SS_Tactics_ShowTab then
            SS_Tactics_ShowTab()
        end
    elseif tabNum == 5 then
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
	elseif tabNum == 7 then	
	    -- Show Tab 7 Stats Tab
		if SS_Cooldowns_ShowTab then
			SS_Cooldowns_ShowTab()
		end
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
    if SS_Tab1_StatsPanel then SS_Tab1_StatsPanel:Hide() end
    if SS_Tab1_RaidListPanel then SS_Tab1_RaidListPanel:Hide() end
    
    -- Hide Tab 2 panels
    if SS_Tab2_ChannelPanel then SS_Tab2_ChannelPanel:Hide() end
    if SS_Tab2_ColorPanel then SS_Tab2_ColorPanel:Hide() end
    if SS_Tab2_MessagePanel then SS_Tab2_MessagePanel:Hide() end
    if SS_Tab2_CountdownPanel then SS_Tab2_CountdownPanel:Hide() end
	
	-- Hide Tab 3 panels
    if SS_Cooldowns_HideTab then
        SS_Cooldowns_HideTab()
    end
    
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
	
	-- Hide Tab 8 panels
	if SS_Tab8_HelpPanel then SS_Tab8_HelpPanel:Hide() end
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
            {name = "Shoutouts", func = SS_Shoutouts_Initialize},
            {name = "ConfigSpecs", func = SS_ConfigSpecs_Initialize},
            {name = "ConsumeConfig", func = SS_ConsumeConfig_Initialize},
            {name = "Tactics", func = SS_Tactics_Initialize},
            {name = "CheckConsumes", func = SS_Check_Initialize},
            {name = "RaidBuff", func = SS_RaidBuff_Initialize},
            {name = "Display", func = SS_Display_Initialize},
            {name = "Announcements", func = SS_Announce_Initialize},
			{name = "Help", func = SS_Help_Initialize},
			{name = "Cooldowns", func = SS_Cooldowns_Initialize}
			
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