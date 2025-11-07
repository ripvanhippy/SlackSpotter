-- ============================================================================
-- SLACKSPOTTER - CONFIG SPECS MODULE (Tab 5)
-- Guild spec configuration and raid member spec selection
-- ============================================================================

-- ============================================================================
-- SAVED VARIABLES
-- ============================================================================
-- SS_GuildSpecsDB = { ["PlayerName"] = specIndex }
SS_GuildSpecsDB = SS_GuildSpecsDB or {}

-- ============================================================================
-- WORKING MEMORY
-- ============================================================================
SS_ConfigSpecs_RaidMembers = {}  -- Current raid member list
SS_ConfigSpecs_SelectedSpecs = {}  -- [playerName] = specIndex
SS_ConfigSpecs_ScrollOffset = 0
SS_ConfigSpecs_MaxVisibleRows = 25
SS_ConfigSpecs_RowHeight = 20

-- Auto-load flag (0 = not loaded, 1 = loaded this session)
SS_SpecsLoadedThisSession = 0

-- Whisper Spec System
SS_ConfigSpecs_WhisperSpecEnabled = false
SS_ConfigSpecs_WhisperUnassignedEnabled = false
SS_ConfigSpecs_WhisperSpecFrame = nil

-- ============================================================================
-- CLASS SPECS DEFINITION
-- ============================================================================
SS_ConfigSpecs_ClassSpecs = {
    ["Warrior"] = {"DPS", "Tank"},
    ["Paladin"] = {"Retri", "Holy", "Tank"},
    ["Hunter"] = {"Surv", "MM"},
    ["Shaman"] = {"EnhDPS", "EleNat", "EleFire", "Resto", "EnhTank"},
    ["Rogue"] = {"DPS"},
    ["Druid"] = {"Cat", "Owl", "Tree", "Bear"},
    ["Priest"] = {"Disc", "Shadow", "Holy"},
    ["Warlock"] = {"Shadow", "Fire"},
    ["Mage"] = {"Arcane", "Fire", "Frost"}
}

-- ============================================================================
-- CLASS COLORS
-- ============================================================================
SS_ConfigSpecs_ClassColors = {
    ["Warrior"] = "|cffc79c6e",
    ["Paladin"] = "|cfff58cba",
    ["Hunter"] = "|cffa9d271",
    ["Shaman"] = "|cff0070dd",
    ["Rogue"] = "|cfffff569",
    ["Druid"] = "|cffff7d0a",
    ["Priest"] = "|cffffffff",
    ["Warlock"] = "|cff9482c9",
    ["Mage"] = "|cff69ccf0"
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Convert UPPERCASE class to Proper Case (WARRIOR -> Warrior)
function SS_ConfigSpecs_ProperCase(str)
    if not str or str == "" then return "" end
    return string.upper(string.sub(str, 1, 1)) .. string.lower(string.sub(str, 2))
end

-- ============================================================================
-- REFRESH RAID MEMBERS
-- ============================================================================
function SS_ConfigSpecs_RefreshRaid()
    SS_ConfigSpecs_RaidMembers = {}
    
    local numRaidMembers = GetNumRaidMembers()
    if numRaidMembers > 0 then
        for i = 1, numRaidMembers do
            local name, _, _, _, class = GetRaidRosterInfo(i)
            if name and class then
                local properClass = SS_ConfigSpecs_ProperCase(class)
                table.insert(SS_ConfigSpecs_RaidMembers, {
                    name = name,
                    class = properClass,
                    originalIndex = i
                })
            end
        end
    else
        -- Solo or party
        local playerName = UnitName("player")
        local _, englishClass = UnitClass("player")
        local properClass = SS_ConfigSpecs_ProperCase(englishClass)
        table.insert(SS_ConfigSpecs_RaidMembers, {
            name = playerName,
            class = properClass,
            originalIndex = 1
        })
    end
    
		-- Sort by class order, then by name
local classOrder = {
    ["Warrior"] = 1, ["Paladin"] = 2, ["Hunter"] = 3, ["Shaman"] = 4,
    ["Rogue"] = 5, ["Druid"] = 6, ["Priest"] = 7, ["Mage"] = 8, ["Warlock"] = 9
}
	
	table.sort(SS_ConfigSpecs_RaidMembers, function(a, b)
    local orderA = classOrder[a.class] or 99
    local orderB = classOrder[b.class] or 99
    
    if orderA == orderB then
        return a.name < b.name  -- Same class: sort by name
    else
        return orderA < orderB  -- Different class: sort by class order
    end
end)
	
    SS_ConfigSpecs_ScrollOffset = 0
    SS_ConfigSpecs_UpdateDisplay()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Loaded " .. table.getn(SS_ConfigSpecs_RaidMembers) .. " raid members.|r")
end

-- Auto-populate SelectedSpecs from saved guild specs
-- ONLY loads saved spec if player is NEW (not already in working memory)
function SS_ConfigSpecs_AutoLoadSavedSpecs()
    if not SS_GuildSpecsDB then return end
    
    for i = 1, table.getn(SS_ConfigSpecs_RaidMembers) do
        local member = SS_ConfigSpecs_RaidMembers[i]
        
        -- ONLY apply saved spec if this player has NO spec assigned yet
        if not SS_ConfigSpecs_SelectedSpecs[member.name] then
            if SS_GuildSpecsDB[member.name] then
                SS_ConfigSpecs_SelectedSpecs[member.name] = SS_GuildSpecsDB[member.name]
            end
        end
        -- If player already has a spec in working memory, DO NOT overwrite
    end
	
	-- Update Tab 5 UI display
    SS_ConfigSpecs_UpdateDisplay()
end

-- ============================================================================
-- AUTO-LOAD SPECS FROM SAVEDVARIABLES (Once per session)
-- ============================================================================
function SS_ConfigSpecs_AutoLoad()
    if SS_SpecsLoadedThisSession == 1 then
        return  -- Already loaded this session
    end
    
    local loadedCount = 0
    for playerName, specIndex in pairs(SS_GuildSpecsDB) do
        SS_ConfigSpecs_SelectedSpecs[playerName] = specIndex
        loadedCount = loadedCount + 1
    end
    
    SS_SpecsLoadedThisSession = 1
    
    if loadedCount > 0 then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Auto-loaded " .. loadedCount .. " guild member specs.|r")
    end
end

-- ============================================================================
-- SAVE GUILD MEMBER SPECS
-- ============================================================================
function SS_ConfigSpecs_SaveGuildSpecs()
    local savedCount = 0
    
    for i = 1, table.getn(SS_ConfigSpecs_RaidMembers) do
        local member = SS_ConfigSpecs_RaidMembers[i]
        local playerName = member.name
        local specIndex = SS_ConfigSpecs_SelectedSpecs[playerName]
        
        -- Only save if spec is selected and player is in guild
        if specIndex and SS_ConfigSpecs_IsInGuild(playerName) then
            SS_GuildSpecsDB[playerName] = specIndex
            savedCount = savedCount + 1
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Saved " .. savedCount .. " guild member specs.|r")
end

-- ============================================================================
-- CHECK IF PLAYER IS IN GUILD
-- ============================================================================
function SS_ConfigSpecs_IsInGuild(playerName)
    if not IsInGuild() then return false end
    
    local numGuildMembers = GetNumGuildMembers()
    for i = 1, numGuildMembers do
        local name = GetGuildRosterInfo(i)
        if name == playerName then
            return true
        end
    end
    return false
end

-- ============================================================================
-- SPEC CHECKBOX CLICK HANDLER
-- ============================================================================
function SS_ConfigSpecs_SpecCheckbox_OnClick(playerName, class, specIndex)
    -- Toggle or select spec
    if SS_ConfigSpecs_SelectedSpecs[playerName] == specIndex then
        -- Deselect if clicking same spec
        SS_ConfigSpecs_SelectedSpecs[playerName] = nil
    else
        -- Select new spec (mutually exclusive)
        SS_ConfigSpecs_SelectedSpecs[playerName] = specIndex
    end
    
    SS_ConfigSpecs_UpdateDisplay()
end

-- ============================================================================
-- UPDATE DISPLAY
-- ============================================================================
function SS_ConfigSpecs_UpdateDisplay()
    local content = getglobal("SS_Tab5_RaidListPanel_Content")
    if not content then return end
    
    -- Clear existing rows
    for i = 1, SS_ConfigSpecs_MaxVisibleRows do
        local row = getglobal("SS_Tab5_SpecRow"..i)
        if row then row:Hide() end
    end
    
    -- Create/update visible rows
    for i = 1, SS_ConfigSpecs_MaxVisibleRows do
        local dataIndex = i + SS_ConfigSpecs_ScrollOffset
        if dataIndex <= table.getn(SS_ConfigSpecs_RaidMembers) then
            local member = SS_ConfigSpecs_RaidMembers[dataIndex]
            SS_ConfigSpecs_CreateOrUpdateRow(i, member)
        end
    end
end

-- ============================================================================
-- CREATE OR UPDATE A SINGLE ROW
-- ============================================================================
function SS_ConfigSpecs_CreateOrUpdateRow(rowIndex, member)
    local content = getglobal("SS_Tab5_RaidListPanel_Content")
    if not content then return end
    
    local rowName = "SS_Tab5_SpecRow"..rowIndex
    local row = getglobal(rowName)
    
    -- Create row if doesn't exist
    if not row then
        row = CreateFrame("Frame", rowName, content)
        row:SetWidth(480)
        row:SetHeight(SS_ConfigSpecs_RowHeight)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(rowIndex-1) * SS_ConfigSpecs_RowHeight)
        
        -- Player name label
        row.nameLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.nameLabel:SetPoint("LEFT", row, "LEFT", 0, 0)
        row.nameLabel:SetWidth(100)
        row.nameLabel:SetJustifyH("LEFT")
        
        -- Spec checkboxes (create max 5 for Shaman)
        row.checkboxes = {}
        for i = 1, 5 do
            local cb = CreateFrame("CheckButton", rowName.."_Checkbox"..i, row, "UICheckButtonTemplate")
            cb:SetWidth(16)
            cb:SetHeight(16)
            if i == 1 then
                cb:SetPoint("LEFT", row.nameLabel, "RIGHT", 10, 0)
            else
                cb:SetPoint("LEFT", row.checkboxes[i-1], "RIGHT", 60, 0)
            end
            
            -- Label next to checkbox
            cb.label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            cb.label:SetPoint("LEFT", cb, "RIGHT", 5, 0)
            
            table.insert(row.checkboxes, cb)
        end
    end
    
    -- Update row data
    local playerName = member.name
    local class = member.class
    local colorCode = SS_ConfigSpecs_ClassColors[class] or "|cffffffff"
    
    row.nameLabel:SetText(colorCode .. playerName .. "|r")
    
    -- Get specs for this class
    local specs = SS_ConfigSpecs_ClassSpecs[class]
    if not specs then
        -- Class not found - this should not happen now
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ERROR: No specs for class '" .. (class or "nil") .. "'|r")
        specs = {}
    end
    
    local selectedSpec = SS_ConfigSpecs_SelectedSpecs[playerName]
    
    -- Update checkboxes
    for i = 1, 5 do
        local cb = row.checkboxes[i]
        if i <= table.getn(specs) then
            cb:Show()
            
            -- Set checked state
            local isChecked = (selectedSpec == i)
            cb:SetChecked(isChecked)
            
            -- Color the label based on selection state
            if not selectedSpec then
                -- No spec selected - all red
                cb.label:SetTextColor(1, 0, 0)
            elseif isChecked then
                -- This spec is selected - normal white
                cb.label:SetTextColor(1, 1, 1)
            else
                -- Other specs - light grey
                cb.label:SetTextColor(0.5, 0.5, 0.5)
            end
            
            cb.label:SetText(specs[i])
            
            -- Set OnClick handler (capture values in closure)
            local capturedPlayerName = playerName
            local capturedClass = class
            local capturedSpecIndex = i
            cb:SetScript("OnClick", function()
                SS_ConfigSpecs_SpecCheckbox_OnClick(capturedPlayerName, capturedClass, capturedSpecIndex)
            end)
        else
            cb:Hide()
            cb.label:SetText("")
        end
    end
    
    row:Show()
end

-- ============================================================================
-- SCROLL FUNCTIONS
-- ============================================================================
function SS_ConfigSpecs_ScrollUp()
    if SS_ConfigSpecs_ScrollOffset > 0 then
        SS_ConfigSpecs_ScrollOffset = SS_ConfigSpecs_ScrollOffset - 3
        if SS_ConfigSpecs_ScrollOffset < 0 then
            SS_ConfigSpecs_ScrollOffset = 0
        end
        SS_ConfigSpecs_UpdateDisplay()
    end
end

function SS_ConfigSpecs_ScrollDown()
    local maxOffset = table.getn(SS_ConfigSpecs_RaidMembers) - SS_ConfigSpecs_MaxVisibleRows
    if maxOffset < 0 then maxOffset = 0 end
    
    if SS_ConfigSpecs_ScrollOffset < maxOffset then
        SS_ConfigSpecs_ScrollOffset = SS_ConfigSpecs_ScrollOffset + 3
        if SS_ConfigSpecs_ScrollOffset > maxOffset then
            SS_ConfigSpecs_ScrollOffset = maxOffset
        end
        SS_ConfigSpecs_UpdateDisplay()
    end
end

-- ============================================================================
-- UPDATE LIST (FOR SCROLL CALLBACK)
-- ============================================================================
function SS_ConfigSpecs_UpdateList()
    SS_ConfigSpecs_UpdateDisplay()
end

-- ============================================================================
-- SCROLL FUNCTIONS
-- ============================================================================
function SS_Tab5_ScrollUp()
    if SS_ConfigSpecs_ScrollOffset > 0 then
        SS_ConfigSpecs_ScrollOffset = SS_ConfigSpecs_ScrollOffset - 3
        if SS_ConfigSpecs_ScrollOffset < 0 then
            SS_ConfigSpecs_ScrollOffset = 0
        end
        SS_ConfigSpecs_UpdateDisplay()
    end
end

function SS_Tab5_ScrollDown()
    local totalMembers = table.getn(SS_ConfigSpecs_RaidMembers)
    if SS_ConfigSpecs_ScrollOffset < totalMembers - SS_ConfigSpecs_MaxVisibleRows then
        SS_ConfigSpecs_ScrollOffset = SS_ConfigSpecs_ScrollOffset + 3
        SS_ConfigSpecs_UpdateDisplay()
    end
end

-- ============================================================================
-- WHISPER SPEC SYSTEM
-- ============================================================================

function SS_ConfigSpecs_WhisperSpec_Initialize()    
    -- Create event frame
    local frame = CreateFrame("Frame")
    SS_ConfigSpecs_WhisperSpecFrame = frame
    
    frame:RegisterEvent("CHAT_MSG_WHISPER")
    
    frame:SetScript("OnEvent", function()
        if event == "CHAT_MSG_WHISPER" then
            SS_ConfigSpecs_WhisperSpec_OnWhisper(arg1, arg2)
        end
    end)
end

function SS_ConfigSpecs_WhisperSpec_ToggleCheckbox()
    local checkbox = getglobal("SS_Tab5_WhisperSpecPanel_EnableCheckbox")
    if checkbox then
        SS_ConfigSpecs_WhisperSpecEnabled = checkbox:GetChecked()
        
        -- Save to DB
        if not SS_GuildSpecsDB then
            SS_GuildSpecsDB = {}
        end
        SS_GuildSpecsDB["_whisperSpecEnabled"] = SS_ConfigSpecs_WhisperSpecEnabled
        
        -- Update button state
        SS_ConfigSpecs_WhisperSpec_UpdateUI()
    end
end

function SS_ConfigSpecs_WhisperSpec_ToggleWhisperUnassigned()
    local checkbox = getglobal("SS_Tab5_WhisperSpecPanel_WhisperUnassignedCheckbox")
    if checkbox then
        SS_ConfigSpecs_WhisperUnassignedEnabled = checkbox:GetChecked()
        
        -- Save to DB
        if not SS_GuildSpecsDB then
            SS_GuildSpecsDB = {}
        end
        SS_GuildSpecsDB["_whisperUnassignedEnabled"] = SS_ConfigSpecs_WhisperUnassignedEnabled
    end
end

function SS_ConfigSpecs_WhisperSpec_UpdateUI()
    local mainCheckbox = getglobal("SS_Tab5_WhisperSpecPanel_EnableCheckbox")
    local unassignedCheckbox = getglobal("SS_Tab5_WhisperSpecPanel_WhisperUnassignedCheckbox")
    local button = getglobal("SS_Tab5_WhisperSpecPanel_ConfirmButton")
    
    if mainCheckbox then
        mainCheckbox:SetChecked(SS_ConfigSpecs_WhisperSpecEnabled)
    end
    
    if unassignedCheckbox then
        unassignedCheckbox:SetChecked(SS_ConfigSpecs_WhisperUnassignedEnabled)
        if SS_ConfigSpecs_WhisperSpecEnabled then
            unassignedCheckbox:Enable()
            unassignedCheckbox:SetAlpha(1.0)
        else
            unassignedCheckbox:Disable()
            unassignedCheckbox:SetAlpha(0.5)
        end
    end
    
    if button then
        if SS_ConfigSpecs_WhisperSpecEnabled then
            button:Enable()
            button:SetAlpha(1.0)
        else
            button:Disable()
            button:SetAlpha(0.5)
        end
    end
end

function SS_ConfigSpecs_WhisperSpec_ConfirmSpecs()
    if not SS_ConfigSpecs_WhisperSpecEnabled then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Whisper Spec is disabled!|r")
        return
    end
    
    -- Refresh raid first
    SS_ConfigSpecs_RefreshRaid()
    
    -- Auto-assign single-spec classes
    SS_ConfigSpecs_AutoAssignSingleSpecs()
    
    -- Update display
    SS_ConfigSpecs_UpdateDisplay()
    
    -- Send raid announcement
    local raidMsg = "|cff00ffffTo check your saved spec whisper me: -spec|r"
    SS_Announce_Output(raidMsg, "RAID")
    
    local changeMsg = "|cff00ffffTo change your spec whisper me: -spec <name> (example: -spec Tree)|r"
    SS_Announce_Output(changeMsg, "RAID")
    
    -- Whisper unassigned players if checkbox enabled
    if SS_ConfigSpecs_WhisperUnassignedEnabled then
        local unassignedCount = 0
        for i = 1, table.getn(SS_ConfigSpecs_RaidMembers) do
            local member = SS_ConfigSpecs_RaidMembers[i]
            if member and not SS_ConfigSpecs_SelectedSpecs[member.name] then
                SS_ConfigSpecs_WhisperSpec_SendInfo(member.name, member.class)
                unassignedCount = unassignedCount + 1
            end
        end
        if unassignedCount > 0 then
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Whispered " .. unassignedCount .. " unassigned players.|r")
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Confirmed specs and refreshed raid list.|r")
end

function SS_ConfigSpecs_AutoAssignSingleSpecs()
    for i = 1, table.getn(SS_ConfigSpecs_RaidMembers) do
        local member = SS_ConfigSpecs_RaidMembers[i]
        if member then
            local specs = SS_ConfigSpecs_ClassSpecs[member.class]
            if specs and table.getn(specs) == 1 then
                -- Only 1 spec available - auto-assign
                SS_ConfigSpecs_SelectedSpecs[member.name] = 1
                
                -- Save to guild DB if in guild
                if SS_ConfigSpecs_IsInGuild(member.name) then
                    SS_GuildSpecsDB[member.name] = 1
                end
            end
        end
    end
end

function SS_ConfigSpecs_WhisperSpec_SendInfo(playerName, class)
    local properClass = SS_ConfigSpecs_ProperCase(class)
    local specs = SS_ConfigSpecs_ClassSpecs[properClass]
    
    if not specs then
        return
    end
    
    -- Get current spec
    local currentSpecIndex = SS_ConfigSpecs_SelectedSpecs[playerName]
    local currentSpecName = "None"
    if currentSpecIndex and specs[currentSpecIndex] then
        currentSpecName = specs[currentSpecIndex]
    end
    
    -- Build spec list
    local specList = ""
    for i = 1, table.getn(specs) do
        if i > 1 then
            specList = specList .. ", "
        end
        specList = specList .. "'" .. specs[i] .. "'"
    end
    
    -- Build message
    local message = "Your current spec is saved as: '" .. currentSpecName .. "'. Available specs for your class: " .. specList .. ". To change your saved spec whisper me: \"-spec <name>\"."
    
    -- Send whisper
    SendChatMessage(message, "WHISPER", nil, playerName)
end

function SS_ConfigSpecs_WhisperSpec_OnWhisper(message, sender)
    -- Only process if enabled
    if not SS_ConfigSpecs_WhisperSpecEnabled then
        return
    end
    
    -- Check if sender is in raid
    local numRaidMembers = GetNumRaidMembers()
    if numRaidMembers == 0 then
        return
    end
    
    local senderClass = nil
    local isInRaid = false
    
    for i = 1, numRaidMembers do
        local name, _, _, _, class = GetRaidRosterInfo(i)
        if name == sender then
            isInRaid = true
            senderClass = SS_ConfigSpecs_ProperCase(class)
            break
        end
    end
    
    if not isInRaid then
        return
    end
    
    -- Check for "-spec" alone (query current spec)
    if string.lower(message) == "-spec" then
        SS_ConfigSpecs_WhisperSpec_SendInfo(sender, senderClass)
        return
    end
    
    -- Parse message for "-spec <specname>"
    local specName = string.match(message, "^%-spec%s+(.+)$")
    if not specName then
        return
    end
    
    -- Find matching spec (case-insensitive)
    local specs = SS_ConfigSpecs_ClassSpecs[senderClass]
    if not specs then
        return
    end
    
    local matchedIndex = nil
    for i = 1, table.getn(specs) do
        if string.lower(specs[i]) == string.lower(specName) then
            matchedIndex = i
            break
        end
    end
    
    if matchedIndex then
        -- Valid spec - update working memory
        SS_ConfigSpecs_SelectedSpecs[sender] = matchedIndex
		
        -- Save to guild DB if sender is in guild
        if SS_ConfigSpecs_IsInGuild(sender) then
            SS_GuildSpecsDB[sender] = matchedIndex
        end
        
        -- Update display if on Tab 5
        if SS_CurrentTab == 5 then
            SS_ConfigSpecs_UpdateDisplay()
        end
        
        -- Send confirmation
        SendChatMessage("Spec set to: " .. specs[matchedIndex], "WHISPER", nil, sender)
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00" .. sender .. " changed spec to " .. specs[matchedIndex] .. "|r")
    else
        -- Invalid spec - send error
        
        local specList = ""
        for i = 1, table.getn(specs) do
            if i > 1 then
                specList = specList .. ", "
            end
            specList = specList .. specs[i]
        end
        
        local errorMsg = "Invalid spec. Available specs to you: " .. specList .. ". Example: '-spec " .. specs[1] .. "'"
        SendChatMessage(errorMsg, "WHISPER", nil, sender)
    end
end

-- ============================================================================
-- SHOW/HIDE TAB 5
-- ============================================================================

function SS_ConfigSpecs_ShowTab()
    if SS_Tab5_ButtonPanel then SS_Tab5_ButtonPanel:Show() end
    if SS_Tab5_WhisperSpecPanel then SS_Tab5_WhisperSpecPanel:Show() end
    if SS_Tab5_RaidListPanel then SS_Tab5_RaidListPanel:Show() end
    
    -- Auto-load specs on first view
    if SS_ConfigSpecs_AutoLoad then
        SS_ConfigSpecs_AutoLoad()
    end
    
    -- Update whisper spec UI
    SS_ConfigSpecs_WhisperSpec_UpdateUI()
end

function SS_ConfigSpecs_HideTab()
    if SS_Tab5_ButtonPanel then SS_Tab5_ButtonPanel:Hide() end
    if SS_Tab5_WhisperSpecPanel then SS_Tab5_WhisperSpecPanel:Hide() end
    if SS_Tab5_RaidListPanel then SS_Tab5_RaidListPanel:Hide() end
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function SS_ConfigSpecs_Initialize()
    SS_ConfigSpecs_WhisperSpec_Initialize()
--    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Config Specs module loaded!|r")
end