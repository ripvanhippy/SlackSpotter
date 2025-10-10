-- ============================================================================
-- SLACKSPOTTER - CONSUME CONFIG MODULE (Tab 6)
-- Consumable assignment system per spec and raid
-- NOTE: Consumable data is in ConsumeData.lua, Presets in ConsumePresets.lua
-- ============================================================================

-- ============================================================================
-- SAVED VARIABLES
-- ============================================================================
SS_ConsumeConfigDB = SS_ConsumeConfigDB or {}

-- ============================================================================
-- WORKING MEMORY (Session-only, not saved to disk)
-- ============================================================================
SS_ConsumeConfig_CurrentRaid = "Kara40"
SS_ConsumeConfig_CurrentSpec = "WarriorDPS"

-- Working memory structure: [RaidInstance][SpecName] = {consumes = {}, minRequired = X}
SS_ConsumeConfig_WorkingMemory = {}

SS_ConsumeConfig_CheckedConsumes = {}  -- Current UI state for selected spec
SS_ConsumeConfig_MinRequired = 0  -- Selected "Any X Consume" checkbox (0-4)
SS_ConsumeConfig_ShowAll = false  -- Show all consumes or filtered by role
SS_ConsumeConfig_ScrollOffset = 0
SS_ConsumeConfig_MaxVisibleRows = 25
SS_ConsumeConfig_RowHeight = 18

-- Auto-load flag
SS_ConsumeConfigLoadedThisSession = 0

-- ============================================================================
-- SPEC TO ROLE MAPPING
-- ============================================================================
SS_ConsumeConfig_SpecRoles = {
    -- Warrior
    ["WarriorDPS"] = "Physical",
    ["WarriorTank"] = "Tanks",
    
    -- Paladin
    ["PaladinRetri"] = "Physical",
    ["PaladinHoly"] = "Healers",
    ["PaladinTank"] = "Tanks",
    
    -- Hunter
    ["HunterSurv"] = "PhysRanged",
    ["HunterMM"] = "PhysRanged",
    
    -- Shaman
    ["ShamanEnhDPS"] = "Physical",
    ["ShamanEle (Nat)"] = "CastersNature",
    ["ShamanEle (Fire)"] = "CastersFire",
    ["ShamanResto"] = "Healers",
    ["ShamanEnhTank"] = "Tanks",
    
    -- Rogue
    ["RogueDPS"] = "Physical",
    
    -- Druid
    ["DruidCat"] = "Physical",
    ["DruidOwl"] = "Casters",
    ["DruidTree"] = "Healers",
    ["DruidBear"] = "Tanks",
    
    -- Priest
    ["PriestDisc"] = "Healers",
    ["PriestShadow"] = "CastersShadow",
    ["PriestHoly"] = "Healers",
    
    -- Warlock
    ["WarlockShadow"] = "CastersShadow",
    ["WarlockFire"] = "CastersFire",
    
    -- Mage
    ["MageArcane"] = "Casters",
    ["MageFire"] = "CastersFire",
    ["MageFrost"] = "CastersFrost"
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Check if consumable should be shown for current spec
local function SS_ConsumeConfig_ShouldShowConsume(consumeName)
    -- Show All = show everything UNFILTERED
    if SS_ConsumeConfig_ShowAll then
        return true
    end
    
    -- Default (Show All OFF) = apply role filtering
    local specRole = SS_ConsumeConfig_SpecRoles[SS_ConsumeConfig_CurrentSpec]
    if not specRole then
        return true  -- Show all if spec role unknown
    end
    
    local consumeRoles = SS_ConsumeData_ConsumableRoles[consumeName]
    if not consumeRoles or table.getn(consumeRoles) == 0 then
        return true  -- Show if no role restrictions
    end
    
    -- Check if spec role matches any consumable role
    for i = 1, table.getn(consumeRoles) do
        if consumeRoles[i] == specRole then
            return true
        end
    end
    
    return false
end

-- Count how many consumes are currently checked
local function SS_ConsumeConfig_GetCheckedCount()
    local count = 0
    for consumeName, isChecked in pairs(SS_ConsumeConfig_CheckedConsumes) do
        if isChecked then
            count = count + 1
        end
    end
    return count
end

-- Update "Any X Consume" checkbox availability
function SS_ConsumeConfig_UpdateMinRequiredCheckboxes()
    -- Get currently checked consumes
    local checkedConsumes = {}
    for consumeName, isChecked in pairs(SS_ConsumeConfig_CheckedConsumes) do
        if isChecked then
            table.insert(checkedConsumes, consumeName)
        end
    end
    
    if table.getn(checkedConsumes) == 0 then
        -- No consumes selected - disable all checkboxes
        for i = 1, 4 do
            local checkbox = getglobal("SS_Tab6_MinRequiredCheckbox" .. i)
            if checkbox then
                checkbox:SetChecked(false)
                checkbox:Disable()
                checkbox:SetAlpha(0.3)
            end
        end
        SS_ConsumeConfig_MinRequired = 0
        return
    end
    
    -- Group consumes by consume groups (same logic as CheckConsumes.lua)
    local grouped = {}
    local processed = {}
    
    -- Check each consume group
    for groupIndex = 1, table.getn(SS_ConsumeData_Groups) do
        local groupData = SS_ConsumeData_Groups[groupIndex]
        local consumesInThisGroup = {}
        
        for i = 1, table.getn(checkedConsumes) do
            local consumeName = checkedConsumes[i]
            if not processed[consumeName] then
                for j = 1, table.getn(groupData.consumes) do
                    if groupData.consumes[j] == consumeName then
                        table.insert(consumesInThisGroup, consumeName)
                        processed[consumeName] = true
                        break
                    end
                end
            end
        end
        
        -- If 2+ consumes from same group, count as ONE requirement
        if table.getn(consumesInThisGroup) >= 2 then
            table.insert(grouped, {isGroup = true, count = 1})
        elseif table.getn(consumesInThisGroup) == 1 then
            table.insert(grouped, {isGroup = false, count = 1})
        end
    end
    
    -- Add ungrouped consumes
    for i = 1, table.getn(checkedConsumes) do
        local consumeName = checkedConsumes[i]
        if not processed[consumeName] then
            table.insert(grouped, {isGroup = false, count = 1})
        end
    end
    
    -- Calculate actual requirement count (after grouping)
    local actualCount = table.getn(grouped)
    
    -- Maximum allowed checkbox = actualCount - 1
    -- (Can't have "Any X" where X = total, that's just normal checking)
    local maxAllowed = actualCount - 1
    if maxAllowed < 0 then maxAllowed = 0 end
    
    -- Update checkboxes 1-4
    for i = 1, 4 do
        local checkbox = getglobal("SS_Tab6_MinRequiredCheckbox" .. i)
        if checkbox then
            if i <= maxAllowed then
                -- Enable this checkbox
                checkbox:Enable()
                checkbox:SetAlpha(1.0)
                
                -- Keep current state if still valid
                if SS_ConsumeConfig_MinRequired == i then
                    checkbox:SetChecked(true)
                end
            else
                -- Disable this checkbox
                checkbox:Disable()
                checkbox:SetAlpha(0.3)
                checkbox:SetChecked(false)
                
                -- If this was selected, clear it
                if SS_ConsumeConfig_MinRequired == i then
                    SS_ConsumeConfig_MinRequired = 0
                end
            end
        end
    end
end

-- ============================================================================
-- RAID & SPEC SELECTION
-- ============================================================================

-- Select raid instance
function SS_ConsumeConfig_SelectRaid(raidName)
    SS_ConsumeConfig_CurrentRaid = raidName
    
    SS_ConsumeConfig_UpdateRaidButtons()
    SS_ConsumeConfig_LoadSpecData()
    SS_ConsumeConfig_UpdateDisplay()
end

-- Select spec
function SS_ConsumeConfig_SelectSpec(specName)
    -- Save current spec data before switching
    SS_ConsumeConfig_SaveCurrentSpecToMemory()
    
    SS_ConsumeConfig_CurrentSpec = specName
    
    SS_ConsumeConfig_UpdateSpecButtons()
    SS_ConsumeConfig_LoadSpecData()
    SS_ConsumeConfig_UpdateDisplay()
end

-- Save current spec data to working memory
function SS_ConsumeConfig_SaveCurrentSpecToMemory()
--    DEFAULT_CHAT_FRAME:AddMessage("DEBUG: Saving " .. SS_ConsumeConfig_CurrentSpec .. " to WorkingMemory")
    
    if not SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid] then
        SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid] = {}
    end
    
    SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid][SS_ConsumeConfig_CurrentSpec] = {
        consumes = {},
        minRequired = SS_ConsumeConfig_MinRequired
    }
    
    -- Copy checked consumes
    local count = 0
    for consumeName, isChecked in pairs(SS_ConsumeConfig_CheckedConsumes) do
        if isChecked then
            SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid][SS_ConsumeConfig_CurrentSpec].consumes[consumeName] = true
            count = count + 1
        end
    end
    
--    DEFAULT_CHAT_FRAME:AddMessage("DEBUG: Saved " .. count .. " consumes, minRequired=" .. SS_ConsumeConfig_MinRequired)
end

-- Load spec data from working memory
function SS_ConsumeConfig_LoadSpecData()
    -- Clear current UI state ONLY
    SS_ConsumeConfig_CheckedConsumes = {}
    SS_ConsumeConfig_MinRequired = 0
    
    -- CRITICAL: Uncheck ALL checkboxes first (fix visual bug)
    for i = 1, 4 do
        local cb = getglobal("SS_Tab6_MinRequiredCheckbox" .. i)
        if cb then
            cb:SetChecked(false)
        end
    end
    
    -- Load current spec from working memory
    if SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid] and 
       SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid][SS_ConsumeConfig_CurrentSpec] then
        local specData = SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid][SS_ConsumeConfig_CurrentSpec]
        
        if specData.consumes then
            for consumeName, isChecked in pairs(specData.consumes) do
                SS_ConsumeConfig_CheckedConsumes[consumeName] = isChecked
            end
        end
        
        if specData.minRequired then
            SS_ConsumeConfig_MinRequired = specData.minRequired
        end
    end
    
    SS_ConsumeConfig_UpdateMinRequiredCheckboxes()
end

-- ============================================================================
-- CONSUME LIST DISPLAY
-- ============================================================================

-- Update the consume list display
function SS_ConsumeConfig_UpdateDisplay()
    local content = getglobal("SS_Tab6_ConsumeListPanel_Content")
    if not content then return end
    
    -- Clear existing rows
    for i = 1, SS_ConsumeConfig_MaxVisibleRows do
        local row = getglobal("SS_Tab6_ConsumeRow"..i)
        if row then row:Hide() end
    end
    
    -- Build visible list based on scroll offset
    local visibleIndex = 1
    local dataIndex = 0
    
    for catIndex = 1, table.getn(SS_ConsumeData_Consumables) do
        local category = SS_ConsumeData_Consumables[catIndex]
        
        -- Check if any items in this category should be shown
        local categoryHasVisibleItems = false
        for itemIndex = 1, table.getn(category.items) do
            local item = category.items[itemIndex]
            if SS_ConsumeConfig_ShouldShowConsume(item.name) then
                categoryHasVisibleItems = true
                break
            end
        end
        
        if categoryHasVisibleItems then
            -- Show category header
            dataIndex = dataIndex + 1
            if dataIndex > SS_ConsumeConfig_ScrollOffset and visibleIndex <= SS_ConsumeConfig_MaxVisibleRows then
                SS_ConsumeConfig_CreateCategoryRow(visibleIndex, category.category)
                visibleIndex = visibleIndex + 1
            end
            
            -- Show items
            for itemIndex = 1, table.getn(category.items) do
                local item = category.items[itemIndex]
                if SS_ConsumeConfig_ShouldShowConsume(item.name) then
                    dataIndex = dataIndex + 1
                    if dataIndex > SS_ConsumeConfig_ScrollOffset and visibleIndex <= SS_ConsumeConfig_MaxVisibleRows then
                        SS_ConsumeConfig_CreateConsumeRow(visibleIndex, item)
                        visibleIndex = visibleIndex + 1
                    end
                end
            end
        end
    end
end

-- Create category header row
function SS_ConsumeConfig_CreateCategoryRow(rowIndex, categoryName)
    local content = getglobal("SS_Tab6_ConsumeListPanel_Content")
    if not content then return end
    
    local rowName = "SS_Tab6_ConsumeRow"..rowIndex
    local row = getglobal(rowName)
    
    if not row then
        row = CreateFrame("Frame", rowName, content)
        row:SetWidth(340)
        row:SetHeight(SS_ConsumeConfig_RowHeight)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(rowIndex-1) * SS_ConsumeConfig_RowHeight)
    end
    
    -- Mark this row as a category row
    row.isCategory = true
    
    -- Hide checkbox if it exists
    if row.checkbox then
        row.checkbox:Hide()
    end
    
    -- Create or reuse label
    if not row.label then
        row.label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        row.label:SetPoint("LEFT", row, "LEFT", 5, 0)
        row.label:SetTextColor(1, 0.82, 0)
    end
    
    -- Hide item-specific labels if they exist
    if row.nameLabel then row.nameLabel:Hide() end
    if row.effectLabel then row.effectLabel:Hide() end
    
    row.label:SetText(categoryName)
    row.label:Show()
    -- Forward mousewheel to parent
    row:EnableMouseWheel(1)
    row:SetScript("OnMouseWheel", function()
        if arg1 > 0 then
            SS_ConsumeConfig_ScrollUp()
        else
            SS_ConsumeConfig_ScrollDown()
        end
    end)
    
    row:Show()
end

-- Create consume item row with checkbox
function SS_ConsumeConfig_CreateConsumeRow(rowIndex, item)
    local content = getglobal("SS_Tab6_ConsumeListPanel_Content")
    if not content then return end
    
    local rowName = "SS_Tab6_ConsumeRow"..rowIndex
    local row = getglobal(rowName)
    
    if not row then
        row = CreateFrame("Frame", rowName, content)
        row:SetWidth(340)
        row:SetHeight(SS_ConsumeConfig_RowHeight)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(rowIndex-1) * SS_ConsumeConfig_RowHeight)
    end
    
    -- Mark this row as an item row
    row.isCategory = false
    
    -- Hide category label if it exists
    if row.label then
        row.label:Hide()
    end
    
    -- Create checkbox if needed
    if not row.checkbox then
        row.checkbox = CreateFrame("CheckButton", rowName.."_Checkbox", row, "UICheckButtonTemplate")
        row.checkbox:SetWidth(20)
        row.checkbox:SetHeight(20)
        row.checkbox:SetPoint("LEFT", row, "LEFT", 15, 0)
    end
    
    -- Create item name label if needed
    if not row.nameLabel then
        row.nameLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.nameLabel:SetPoint("LEFT", row.checkbox, "RIGHT", 5, 0)
        row.nameLabel:SetWidth(180)
        row.nameLabel:SetJustifyH("LEFT")
    end
    
    -- Create effect label if needed
    if not row.effectLabel then
        row.effectLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.effectLabel:SetPoint("LEFT", row.nameLabel, "RIGHT", 5, 0)
        row.effectLabel:SetTextColor(0.7, 0.7, 0.7)
    end
    
    -- Show all item elements
    row.checkbox:Show()
    row.nameLabel:Show()
    row.effectLabel:Show()
    
    -- Update row data;	
    -- Show ID in debug mode
if SS_DebugMode then
    local consumeID = SS_ConsumeData_NameToID[item.name] or "?"
    row.nameLabel:SetText("#" .. consumeID .. " - " .. item.name)
else
    row.nameLabel:SetText(item.name)
end
    -- end of debug mode
    row.effectLabel:SetText(item.effect)
    
    local isChecked = SS_ConsumeConfig_CheckedConsumes[item.name]
    row.checkbox:SetChecked(isChecked)
    
    -- Set OnClick handler
    local capturedItemName = item.name
    row.checkbox:SetScript("OnClick", function()
        SS_ConsumeConfig_ConsumeCheckbox_OnClick(capturedItemName)
    end)
    
-- Forward mousewheel to parent
    row:EnableMouseWheel(1)
    row:SetScript("OnMouseWheel", function()
        if arg1 > 0 then
            SS_ConsumeConfig_ScrollUp()
        else
            SS_ConsumeConfig_ScrollDown()
        end
    end)
    
    row:Show()
end

-- Consume checkbox clicked
function SS_ConsumeConfig_ConsumeCheckbox_OnClick(consumeName)
    -- Toggle checked state
    if SS_ConsumeConfig_CheckedConsumes[consumeName] then
        SS_ConsumeConfig_CheckedConsumes[consumeName] = nil
    else
        SS_ConsumeConfig_CheckedConsumes[consumeName] = true
    end
    
    -- Update min required checkboxes availability
    SS_ConsumeConfig_UpdateMinRequiredCheckboxes()
    
    -- Refresh display
    SS_ConsumeConfig_UpdateDisplay()
	
	-- Save to WorkingMemory immediately
    SS_ConsumeConfig_SaveCurrentSpecToMemory()
end

-- Scroll functions
function SS_ConsumeConfig_ScrollUp()
    if SS_ConsumeConfig_ScrollOffset > 0 then
        SS_ConsumeConfig_ScrollOffset = SS_ConsumeConfig_ScrollOffset - 3
        if SS_ConsumeConfig_ScrollOffset < 0 then
            SS_ConsumeConfig_ScrollOffset = 0
        end
        SS_ConsumeConfig_UpdateDisplay()
    end
end

function SS_ConsumeConfig_ScrollDown()
    local totalLines = 0
    
    for catIndex = 1, table.getn(SS_ConsumeData_Consumables) do
        local category = SS_ConsumeData_Consumables[catIndex]
        local categoryHasItems = false
        
        for itemIndex = 1, table.getn(category.items) do
            local item = category.items[itemIndex]
            if SS_ConsumeConfig_ShouldShowConsume(item.name) then
                categoryHasItems = true
                totalLines = totalLines + 1
            end
        end
        
        if categoryHasItems then
            totalLines = totalLines + 1
        end
    end
    
    if SS_ConsumeConfig_ScrollOffset < totalLines - SS_ConsumeConfig_MaxVisibleRows and totalLines > SS_ConsumeConfig_MaxVisibleRows then
        SS_ConsumeConfig_ScrollOffset = SS_ConsumeConfig_ScrollOffset + 3
        SS_ConsumeConfig_UpdateDisplay()
    end

end

-- Show All checkbox clicked
function SS_ConsumeConfig_ShowAllCheckbox_OnClick()
    SS_ConsumeConfig_ShowAll = not SS_ConsumeConfig_ShowAll
    SS_ConsumeConfig_ScrollOffset = 0
    SS_ConsumeConfig_UpdateDisplay()
end

-- Min Required checkbox clicked (1-4)
function SS_ConsumeConfig_MinRequiredCheckbox_OnClick(checkboxNum)
    -- Mutually exclusive - uncheck others
    for i = 1, 4 do
        local cb = getglobal("SS_Tab6_MinRequiredCheckbox"..i)
        if cb then
            if i == checkboxNum then
                -- Toggle this one
                if SS_ConsumeConfig_MinRequired == i then
                    SS_ConsumeConfig_MinRequired = 0
                    cb:SetChecked(false)
                else
                    SS_ConsumeConfig_MinRequired = i
                    cb:SetChecked(true)
                end
            else
                cb:SetChecked(false)
            end
        end
    end
	
	-- Save to WorkingMemory immediately
    SS_ConsumeConfig_SaveCurrentSpecToMemory()
end

-- ============================================================================
-- SAVE/LOAD/DELETE/PRESETS FUNCTIONS
-- ============================================================================

-- Save working memory to SavedVariables
function SS_ConsumeConfig_Save()
    -- Save current UI state to working memory first
    SS_ConsumeConfig_SaveCurrentSpecToMemory()
    
    -- Overwrite SavedVariables with entire working memory
    SS_ConsumeConfigDB = {}
    for raidName, raidData in pairs(SS_ConsumeConfig_WorkingMemory) do
        SS_ConsumeConfigDB[raidName] = {}
        for specName, specData in pairs(raidData) do
            SS_ConsumeConfigDB[raidName][specName] = {
                consumes = {},
                minRequired = specData.minRequired or 0
            }
            -- Copy consumes
            if specData.consumes then
                for consumeName, isChecked in pairs(specData.consumes) do
                    SS_ConsumeConfigDB[raidName][specName].consumes[consumeName] = isChecked
                end
            end
        end
    end
    
    local totalSpecs = 0
    for _, raidData in pairs(SS_ConsumeConfigDB) do
        for _, _ in pairs(raidData) do
            totalSpecs = totalSpecs + 1
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Saved consume config to disk (" .. totalSpecs .. " total specs)|r")
end

-- Load SavedVariables into working memory
function SS_ConsumeConfig_Load()
    -- Save current UI state first
    SS_ConsumeConfig_SaveCurrentSpecToMemory()
    
    if not SS_ConsumeConfigDB then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000SavedVariables is empty!|r")
        return
    end
    
    -- Clear working memory
    SS_ConsumeConfig_WorkingMemory = {}
    
    -- Load SavedVariables into working memory
    for raidName, raidData in pairs(SS_ConsumeConfigDB) do
        SS_ConsumeConfig_WorkingMemory[raidName] = {}
        for specName, specData in pairs(raidData) do
            SS_ConsumeConfig_WorkingMemory[raidName][specName] = {
                consumes = {},
                minRequired = specData.minRequired or 0
            }
            if specData.consumes then
                for consumeName, isChecked in pairs(specData.consumes) do
                    SS_ConsumeConfig_WorkingMemory[raidName][specName].consumes[consumeName] = isChecked
                end
            end
        end
    end
    
    -- Reload current spec UI
    SS_ConsumeConfig_LoadSpecData()
    SS_ConsumeConfig_UpdateDisplay()
    
    local totalSpecs = 0
    for _, raidData in pairs(SS_ConsumeConfig_WorkingMemory) do
        for _, _ in pairs(raidData) do
            totalSpecs = totalSpecs + 1
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Loaded from disk (" .. totalSpecs .. " specs)|r")
end

-- Delete current spec from working memory
function SS_ConsumeConfig_Delete()
    -- Clear current UI state
    SS_ConsumeConfig_CheckedConsumes = {}
    SS_ConsumeConfig_MinRequired = 0
    
    -- Delete from working memory (current spec only)
    if SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid] then
        SS_ConsumeConfig_WorkingMemory[SS_ConsumeConfig_CurrentRaid][SS_ConsumeConfig_CurrentSpec] = nil
    end
    
    SS_ConsumeConfig_UpdateDisplay()
    SS_ConsumeConfig_UpdateMinRequiredCheckboxes()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8000Deleted " .. SS_ConsumeConfig_CurrentSpec .. " from working memory|r")
end

-- Load presets into working memory
function SS_ConsumeConfig_LoadPresets()
    -- Clear entire working memory
    SS_ConsumeConfig_WorkingMemory = {}
    
    -- Load ALL presets into working memory (all raids, all specs)
    for raidName, raidPresets in pairs(SS_ConsumePresets) do
        SS_ConsumeConfig_WorkingMemory[raidName] = {}
        for specName, specData in pairs(raidPresets) do
            SS_ConsumeConfig_WorkingMemory[raidName][specName] = {
                consumes = {},
                minRequired = specData.minRequired or 0
            }
            
            -- Copy consumes from preset array to table
            if specData.consumes then
                for i = 1, table.getn(specData.consumes) do
                    local consumeName = specData.consumes[i]
                    SS_ConsumeConfig_WorkingMemory[raidName][specName].consumes[consumeName] = true
                end
            end
        end
    end
    
    -- Reload current spec from newly loaded presets
    SS_ConsumeConfig_LoadSpecData()
    SS_ConsumeConfig_UpdateDisplay()
    
    local totalSpecs = 0
    for _, raidData in pairs(SS_ConsumeConfig_WorkingMemory) do
        for _, _ in pairs(raidData) do
            totalSpecs = totalSpecs + 1
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Loaded presets (" .. totalSpecs .. " specs)|r")
end

-- Auto-load SavedVariables once per session
function SS_ConsumeConfig_AutoLoad()
    if SS_ConsumeConfigLoadedThisSession == 1 then
        return
    end
    
    -- Clear working memory
    SS_ConsumeConfig_WorkingMemory = {}
    
    -- Load from SavedVariables into working memory
    if SS_ConsumeConfigDB then
        for raidName, raidData in pairs(SS_ConsumeConfigDB) do
            SS_ConsumeConfig_WorkingMemory[raidName] = {}
            for specName, specData in pairs(raidData) do
                SS_ConsumeConfig_WorkingMemory[raidName][specName] = {
                    consumes = {},
                    minRequired = specData.minRequired or 0
                }
                if specData.consumes then
                    for consumeName, isChecked in pairs(specData.consumes) do
                        SS_ConsumeConfig_WorkingMemory[raidName][specName].consumes[consumeName] = isChecked
                    end
                end
            end
        end
    end
    
    -- Load data for default spec
    SS_ConsumeConfig_LoadSpecData()
    
    SS_ConsumeConfigLoadedThisSession = 1
    
    local totalSpecs = 0
    for _, raidData in pairs(SS_ConsumeConfig_WorkingMemory) do
        for _, _ in pairs(raidData) do
            totalSpecs = totalSpecs + 1
        end
    end
    
    if totalSpecs > 0 then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Auto-loaded consume config (" .. totalSpecs .. " specs)|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00No saved config - use Load Presets|r")
    end
end

-- ============================================================================
-- SPEC BUTTON CREATION
-- ============================================================================

function SS_ConsumeConfig_CreateSpecButtons()
    local container = getglobal("SS_Tab6_SpecButtonContainer")
    if not container then return end
    
    local classOrder = {
        {class = "Warrior", color = "|cffc79c6e", specs = {"DPS", "Tank"}},
        {class = "Paladin", color = "|cfff58cba", specs = {"Retri", "Holy", "Tank"}},
        {class = "Hunter", color = "|cffa9d271", specs = {"Surv", "MM"}},
        {class = "Shaman", color = "|cff0070dd", specs = {"EnhDPS", "Ele (Nat)", "Ele (Fire)", "Resto", "EnhTank"}},
        {class = "Rogue", color = "|cfffff569", specs = {"DPS"}},
        {class = "Druid", color = "|cffff7d0a", specs = {"Cat", "Owl", "Tree", "Bear"}},
        {class = "Priest", color = "|cffffffff", specs = {"Disc", "Shadow", "Holy"}},
        {class = "Mage", color = "|cff69ccf0", specs = {"Arcane", "Fire", "Frost"}},
        {class = "Warlock", color = "|cff9482c9", specs = {"Shadow", "Fire"}}
    }
    
    local yOffset = -5

for i = 1, table.getn(classOrder) do
    local classData = classOrder[i]
    
    local label = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", container, "TOPLEFT", 5, yOffset)
    label:SetText(classData.color .. classData.class .. "|r")
    
    local xOffset = 70
    for j = 1, table.getn(classData.specs) do
        local specName = classData.specs[j]
        local fullSpecName = classData.class .. specName
        
        local btn = CreateFrame("Button", nil, container, "UIPanelButtonTemplate")
        btn:SetWidth(55)
        btn:SetHeight(18)
        btn:SetPoint("TOPLEFT", container, "TOPLEFT", xOffset, yOffset)
        btn:SetText(specName)
        btn:SetAlpha(0.9)  -- More solid
            
            local capturedSpec = fullSpecName
            btn:SetScript("OnClick", function()
                SS_ConsumeConfig_SelectSpec(capturedSpec)
            end)
            
            if not SS_ConsumeConfig_SpecButtons then
                SS_ConsumeConfig_SpecButtons = {}
            end
            SS_ConsumeConfig_SpecButtons[fullSpecName] = btn
            
            xOffset = xOffset + 65
        end
        
        yOffset = yOffset - 25
    end
end

function SS_ConsumeConfig_UpdateRaidButtons()
    local raids = {"MC", "BWL", "AQ40", "Naxx", "Kara40", "Kara10", "ES", "AQ20", "ZG", "Ony"}
    
    for i = 1, table.getn(raids) do
        local raid = raids[i]
        local btn = getglobal("SS_Tab6_RaidButton_" .. raid)
        if btn then
            if raid == SS_ConsumeConfig_CurrentRaid then
                btn:LockHighlight()
            else
                btn:UnlockHighlight()
                btn:SetAlpha(0.6)
            end
        end
    end
end

function SS_ConsumeConfig_UpdateSpecButtons()
    if not SS_ConsumeConfig_SpecButtons then return end
    
    for specName, btn in pairs(SS_ConsumeConfig_SpecButtons) do
        if specName == SS_ConsumeConfig_CurrentSpec then
            btn:LockHighlight()
        else
            btn:UnlockHighlight()
            btn:SetAlpha(0.6)
        end
    end
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function SS_ConsumeConfig_Initialize()
    if not SS_ConsumeConfigDB then
        SS_ConsumeConfigDB = {}
    end
    
    SS_ConsumeConfig_CreateSpecButtons()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Consume Config module loaded!|r")
end