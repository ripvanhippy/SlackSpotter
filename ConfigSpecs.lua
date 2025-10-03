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

-- ============================================================================
-- CLASS SPECS DEFINITION
-- ============================================================================
SS_ConfigSpecs_ClassSpecs = {
    ["Warrior"] = {"DPS", "Tank"},
    ["Paladin"] = {"Retri", "Holy", "Tank"},
    ["Hunter"] = {"Surv", "MM"},
    ["Shaman"] = {"EnhDPS", "Ele (Nat)", "Ele (Fire)", "Resto", "EnhTank"},
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
local function SS_ConfigSpecs_ProperCase(str)
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
    
    SS_ConfigSpecs_ScrollOffset = 0
    SS_ConfigSpecs_UpdateDisplay()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Loaded " .. table.getn(SS_ConfigSpecs_RaidMembers) .. " raid members.|r")
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
        row.nameLabel:SetPoint("LEFT", row, "LEFT", 5, 0)
        row.nameLabel:SetWidth(120)
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
                cb:SetPoint("LEFT", row.checkboxes[i-1], "RIGHT", 80, 0)
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
-- INITIALIZATION
-- ============================================================================
function SS_ConfigSpecs_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Config Specs module loaded!|r")
end