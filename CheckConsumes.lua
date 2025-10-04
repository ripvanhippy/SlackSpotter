-- ============================================================================
-- SLACKSPOTTER - CONSUME CHECKING MODULE
-- Buff scanning and consume detection logic
-- ============================================================================

-- ============================================================================
-- HELPER: Build consumable lookup tables (run once on init)
-- ============================================================================

-- Consumable name → buff detection data
SS_Check_ConsumeToBuffMap = {}

-- Buff name → list of consumable names (for reverse lookup)
SS_Check_BuffToConsumeMap = {}

function SS_Check_BuildLookupTables()
    SS_Check_ConsumeToBuffMap = {}
    SS_Check_BuffToConsumeMap = {}
    
    -- Build mappings from consumables data
    for catIndex = 1, table.getn(SS_ConsumeData_Consumables) do
        local category = SS_ConsumeData_Consumables[catIndex]
        for itemIndex = 1, table.getn(category.items) do
            local item = category.items[itemIndex]
            
            -- Consume name → {buffName, tooltipKeyword}
            SS_Check_ConsumeToBuffMap[item.name] = {
                buffName = item.buffName,
                tooltipKeyword = item.tooltipKeyword
            }
            
            -- Buff name → list of consume names
            if not SS_Check_BuffToConsumeMap[item.buffName] then
                SS_Check_BuffToConsumeMap[item.buffName] = {}
            end
            table.insert(SS_Check_BuffToConsumeMap[item.buffName], item.name)
        end
    end
end

-- ============================================================================
-- CORE: Scan player buffs and return list of detected consumes
-- ============================================================================

function SS_Check_ScanPlayerBuffs(unitID)
    local detectedConsumes = {}
    
    -- Create tooltip if needed
    if not SS_TooltipScanner then
        SS_TooltipScanner = CreateFrame("GameTooltip", "SS_TooltipScanner", nil, "GameTooltipTemplate")
        SS_TooltipScanner:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    
    -- Scan all buff slots
    for buffIndex = 1, 32 do
        local buffTexture = UnitBuff(unitID, buffIndex)
        if not buffTexture then break end
        
        -- Get buff name from tooltip
        SS_TooltipScanner:ClearLines()
        SS_TooltipScanner:SetUnitBuff(unitID, buffIndex)
        local buffNameText = getglobal("SS_TooltipScannerTextLeft1")
        local buffName = buffNameText and buffNameText:GetText()
        
        if buffName then
            -- Check concoctions first
            if SS_ConsumeData_Concoctions[buffName] then
                local components = SS_ConsumeData_Concoctions[buffName]
                for i = 1, table.getn(components) do
                    detectedConsumes[components[i]] = true
                end
            else
                -- Check regular consumables
                local possibleConsumes = SS_Check_BuffToConsumeMap[buffName]
                if possibleConsumes then
                    for i = 1, table.getn(possibleConsumes) do
                        local consumeName = possibleConsumes[i]
                        local buffData = SS_Check_ConsumeToBuffMap[consumeName]
                        
                        if buffData.tooltipKeyword then
                            -- Need deeper tooltip scan
                            if SS_Check_BuffMatchesTooltip(unitID, buffIndex, buffData.tooltipKeyword) then
                                detectedConsumes[consumeName] = true
                            end
                        else
                            -- Buff name match is enough
                            detectedConsumes[consumeName] = true
                        end
                    end
                end
            end
        end
    end
    
    return detectedConsumes
end

-- ============================================================================
-- HELPER: Check if buff tooltip contains keyword
-- ============================================================================

function SS_Check_BuffMatchesTooltip(unitID, buffIndex, keyword)
    -- Create hidden tooltip frame if doesn't exist
    if not SS_TooltipScanner then
        SS_TooltipScanner = CreateFrame("GameTooltip", "SS_TooltipScanner", nil, "GameTooltipTemplate")
        SS_TooltipScanner:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    
    -- Clear and set tooltip to this buff
    SS_TooltipScanner:ClearLines()
    SS_TooltipScanner:SetUnitBuff(unitID, buffIndex)
    
    -- Scan all tooltip text lines
    for lineIndex = 1, SS_TooltipScanner:NumLines() do
        local leftText = getglobal("SS_TooltipScannerTextLeft" .. lineIndex)
        if leftText then
            local text = leftText:GetText()
            if text and string.find(string.lower(text), string.lower(keyword)) then
                return true
            end
        end
    end
    
    return false
end

-- ============================================================================
-- CORE: Compare player's buffs against required consumes
-- ============================================================================

function SS_Check_CompareConsumes(unitID, raidInstance, specName)
    -- Get required consumes for this spec
    local requiredConsumes = SS_Check_GetRequiredConsumes(raidInstance, specName)
    
    if not requiredConsumes then
        return nil
    end
    
    if not requiredConsumes.consumes or table.getn(requiredConsumes.consumes) == 0 then
        return nil
    end
    
    -- Scan player's actual buffs
    local detectedConsumes = SS_Check_ScanPlayerBuffs(unitID)
    
    -- Group required consumes by consume group
    local groupedRequirements = SS_Check_GroupRequiredConsumes(requiredConsumes)
    
    -- Calculate required count AFTER grouping
    local requiredCount = requiredConsumes.minRequired
    if not requiredCount or requiredCount == 0 then
        requiredCount = table.getn(groupedRequirements)
    end
    
    local missingList = {}
    local foundCount = 0
    
    for _, group in ipairs(groupedRequirements) do
        if group.isGroup then
            -- Multiple consumes from same group - check if ANY present
            local foundInGroup = false
            for i = 1, table.getn(group.consumes) do
                if detectedConsumes[group.consumes[i]] then
                    foundInGroup = true
                    break
                end
            end
            
            if foundInGroup then
                foundCount = foundCount + 1
            else
                table.insert(missingList, {name = group.groupName, isGroup = true})
            end
        else
            -- Single consume - check if present
            local consumeName = group.consumes[1]
            if detectedConsumes[consumeName] then
                foundCount = foundCount + 1
            else
                table.insert(missingList, {name = consumeName, isGroup = false})
            end
        end
    end
    
    return {
        found = foundCount,
        required = requiredCount,
        missing = missingList,
        passed = foundCount >= requiredCount
    }
end

-- ============================================================================
-- HELPER: Get required consumes from Tab 6 config
-- ============================================================================

function SS_Check_GetRequiredConsumes(raidInstance, specName)
    
    if not SS_ConsumeConfig_WorkingMemory then
        DEFAULT_CHAT_FRAME:AddMessage("ERROR: WorkingMemory is NIL")
        return nil
    end
    
    if not SS_ConsumeConfig_WorkingMemory[raidInstance] then
        DEFAULT_CHAT_FRAME:AddMessage("ERROR: Raid not in WorkingMemory")
        return nil
    end
    
    local specData = SS_ConsumeConfig_WorkingMemory[raidInstance][specName]
    if not specData then
        DEFAULT_CHAT_FRAME:AddMessage("ERROR: Spec not found")
        return nil
    end
    
    -- Build array from consumes table
    local consumeList = {}
    if specData.consumes then
        for consumeName, isChecked in pairs(specData.consumes) do
            if isChecked then
                table.insert(consumeList, consumeName)
            end
        end
    end
    
    if table.getn(consumeList) == 0 then
        DEFAULT_CHAT_FRAME:AddMessage("ERROR: No consumes in list, returning NIL")
        return nil
    end
    
    -- Return raw minRequired from config (0 or checkbox value)
    -- CompareConsumes will handle defaulting to grouped count
    
    return {
        consumes = consumeList,
        minRequired = specData.minRequired or 0
    }
end

-- ============================================================================
-- HELPER: Group required consumes by mutual exclusivity
-- ============================================================================

function SS_Check_GroupRequiredConsumes(requiredData)
    local requiredList = requiredData.consumes
    local grouped = {}
    local processed = {}  -- Track which consumes are already grouped
    
    -- Check each consume group
    for groupIndex = 1, table.getn(SS_ConsumeData_Groups) do
        local groupData = SS_ConsumeData_Groups[groupIndex]
        local consumesInThisGroup = {}
        
        -- Find which required consumes belong to this group
        for i = 1, table.getn(requiredList) do
            local consumeName = requiredList[i]
            if not processed[consumeName] then
                -- Check if this consume is in the current group
                for j = 1, table.getn(groupData.consumes) do
                    if groupData.consumes[j] == consumeName then
                        table.insert(consumesInThisGroup, consumeName)
                        processed[consumeName] = true
                        break
                    end
                end
            end
        end
        
        -- If 2+ consumes from same group, treat as one grouped requirement
        if table.getn(consumesInThisGroup) >= 2 then
            table.insert(grouped, {
                isGroup = true,
                groupName = groupData.groupName,
                consumes = consumesInThisGroup
            })
        elseif table.getn(consumesInThisGroup) == 1 then
            -- Only 1 from group - treat as individual
            table.insert(grouped, {
                isGroup = false,
                consumes = consumesInThisGroup
            })
        end
    end
    
    -- Add any ungrouped consumes
    for i = 1, table.getn(requiredList) do
        local consumeName = requiredList[i]
        if not processed[consumeName] then
            table.insert(grouped, {
                isGroup = false,
                consumes = {consumeName}
            })
        end
    end
    
    return grouped
end

-- ============================================================================
-- HELPER: Get player's configured spec from Tab 5
-- ============================================================================

function SS_Check_GetPlayerSpec(playerName)
    -- Check Tab 5 Working Memory first
    if SS_ConfigSpecs_SelectedSpecs and SS_ConfigSpecs_SelectedSpecs[playerName] then
        local specIndex = SS_ConfigSpecs_SelectedSpecs[playerName]
        -- Convert specIndex to specName
        return SS_Check_SpecIndexToName(playerName, specIndex)
    end
    
    -- Check Tab 5 Guild DB (saved specs)
    if SS_GuildSpecsDB and SS_GuildSpecsDB[playerName] then
        local specIndex = SS_GuildSpecsDB[playerName]
        return SS_Check_SpecIndexToName(playerName, specIndex)
    end
    
    -- No spec configured
    return nil
end

-- Convert spec index to full spec name (e.g., index 1 for Warrior = "WarriorDPS")
function SS_Check_SpecIndexToName(playerName, specIndex)
    -- Get player's class
    local class = SS_Check_GetPlayerClass(playerName)
    if not class then return nil end
    
    -- Get specs for this class
    local specs = SS_ConfigSpecs_ClassSpecs[class]
    if not specs or specIndex > table.getn(specs) then
        return nil
    end
    
    -- Build full spec name (ClassName + SpecName)
    return class .. specs[specIndex]
end

-- Get player's class
function SS_Check_GetPlayerClass(playerName)
    -- Check if player is in raid
    local numRaidMembers = GetNumRaidMembers()
    if numRaidMembers > 0 then
        for i = 1, numRaidMembers do
            local name, _, _, _, class = GetRaidRosterInfo(i)
            if name == playerName then
                return SS_ConfigSpecs_ProperCase(class)
            end
        end
    end
    
    -- Check if it's the player
    if playerName == UnitName("player") then
        local _, englishClass = UnitClass("player")
        return SS_ConfigSpecs_ProperCase(englishClass)
    end
    
    return nil
end

-- ============================================================================
-- RAID: Check all raid members
-- ============================================================================

function SS_Check_CheckEntireRaid(raidInstance)
    local results = {}  -- [playerName] = {spec, found, required, missing, passed}
    
    local numRaidMembers = GetNumRaidMembers()
    if numRaidMembers == 0 then
        -- Not in raid, check self only
        local playerName = UnitName("player")
        local _, englishClass = UnitClass("player")
        
        local specName = SS_Check_GetPlayerSpec(playerName)
        if not specName then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff8000You have no spec configured in Tab 5!|r")
            return results
        end
        
        local result = SS_Check_CompareConsumes("player", raidInstance, specName)
        if result then
            results[playerName] = {
                class = englishClass,
                spec = "WarriorDPS",
                found = result.found,
                required = result.required,
                missing = result.missing,
                passed = result.passed
            }
        end
    else
        -- Check all raid members
        for i = 1, numRaidMembers do
            local name, _, _, _, class = GetRaidRosterInfo(i)
            if name and class then
                -- Get spec from Tab 5 config
                local specName = SS_Check_GetPlayerSpec(name)
                if not specName then
                    -- No spec configured, skip this player
                    DEFAULT_CHAT_FRAME:AddMessage("|cffff8000" .. name .. " has no spec configured - skipping|r")
                    specName = nil
                end
                
                local unitID = "raid" .. i
                local result = SS_Check_CompareConsumes(unitID, raidInstance, specName)
                
                if result then
                    results[name] = {
                        class = class,
                        spec = specName,
                        found = result.found,
                        required = result.required,
                        missing = result.missing,
                        passed = result.passed
                    }
                end
            end
        end
    end
    
    return results
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function SS_Check_Initialize()
    SS_Check_BuildLookupTables()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Consume Checking module loaded!|r")
end