-- ============================================================================
-- SLACKSPOTTER - RAID BUFF CHECKING MODULE
-- Scan raid for class buffs (MotW, Fort, Spirit, Int, etc.)
-- ============================================================================

-- ============================================================================
-- RAID BUFF DEFINITIONS
-- ============================================================================
SS_RaidBuffs_Definitions = {
    {
        name = "Mark of the Wild",
        buffNames = {"Mark of the Wild", "Gift of the Wild"},
        needsClass = "Druid",
        appliesTo = "everyone",
        personal = false
    },
    {
        name = "Power Word: Fortitude",
        buffNames = {"Power Word: Fortitude", "Prayer of Fortitude"},
        needsClass = "Priest",
        appliesTo = "everyone",
        personal = false
    },
    {
        name = "Divine Spirit",
        buffNames = {"Divine Spirit", "Prayer of Spirit"},
        needsClass = "Priest",
        appliesTo = "manaUsers",
        personal = false
    },
    {
        name = "Arcane Intellect",
        buffNames = {"Arcane Intellect", "Arcane Brilliance"},
        needsClass = "Mage",
        appliesTo = "manaUsers",
        personal = false
    },
    {
        name = "Shadow Protection",
        buffNames = {"Shadow Protection", "Prayer of Shadow Protection"},
        tooltipCheck = "Shadow Resistance",
        needsClass = "Priest",
        appliesTo = "everyone",
        personal = false,
        optional = true
    },
    {
        name = "Thorns",
        buffNames = {"Thorns"},
        needsClass = "Druid",
        appliesTo = "tanks",
        personal = false,
        optional = true
    },
    {
        name = "Emerald Blessing",
        buffNames = {"Emerald Blessing"},
        needsClass = "Druid",
        appliesTo = "druids",
        personal = false,
        optional = true,
        groupCheck = true
    },
    {
        name = "Mage Armor",
        buffNames = {"Mage Armor", "Ice Armor"},
        appliesTo = "selfMage",
        personal = true
    },
    {
        name = "Aspect",
        buffNames = {"Aspect of the Hawk", "Aspect of the Wolf"},
        appliesTo = "selfHunter",
        personal = true
    },
    {
        name = "Demon Armor",
        buffNames = {"Demon Armor"},
        appliesTo = "selfWarlock",
        personal = true
    },
    {
        name = "Inner Fire",
        buffNames = {"Inner Fire"},
        appliesTo = "selfPriestDiscShadow",
        personal = true
    },
    {
        name = "Shaman Shield",
        buffNames = {"Lightning Shield", "Water Shield", "Earth Shield"},
        appliesTo = "selfShaman",
        personal = true
    },
    {
        name = "Warlock Stone",
        buffNames = {"Voidstone", "Firestone", "Felstone", "Wrathstone"},
        appliesTo = "selfWarlock",
        personal = true
    }
}

-- ============================================================================
-- HELPER: Detect which classes are in raid and online
-- ============================================================================
function SS_RaidBuff_GetRaidClasses()
    local classInfo = {
        Druid = {present = false, online = false},
        Priest = {present = false, online = false},
        Mage = {present = false, online = false},
        Hunter = {present = false, online = false},
        Warlock = {present = false, online = false},
        Shaman = {present = false, online = false},
        Warrior = {present = false, online = false},
        Paladin = {present = false, online = false},
        Rogue = {present = false, online = false}
    }
    
    local numRaidMembers = GetNumRaidMembers()
    if numRaidMembers == 0 then
        -- Solo: check self
        local _, englishClass = UnitClass("player")
        local properClass = SS_ConfigSpecs_ProperCase(englishClass)
        if classInfo[properClass] then
            classInfo[properClass].present = true
            classInfo[properClass].online = true
        end
    else
        -- In raid
        for i = 1, numRaidMembers do
            local name, _, _, _, class = GetRaidRosterInfo(i)
            local properClass = SS_ConfigSpecs_ProperCase(class)
            local unitID = "raid" .. i
            
            if classInfo[properClass] then
                classInfo[properClass].present = true
                if UnitIsConnected(unitID) then
                    classInfo[properClass].online = true
                end
            end
        end
    end
    
    return classInfo
end

-- ============================================================================
-- HELPER: Scan player's buffs
-- ============================================================================
function SS_RaidBuff_ScanPlayerBuffs(unitID)
    local foundBuffs = {}  -- [buffDefinitionName] = true
    
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
            -- Check against all buff definitions
            for i = 1, table.getn(SS_RaidBuffs_Definitions) do
                local buffDef = SS_RaidBuffs_Definitions[i]
                
                -- Check if buff name matches any of the defined buff names
                for j = 1, table.getn(buffDef.buffNames) do
                    if buffName == buffDef.buffNames[j] then
                        -- Check tooltip if needed (Shadow Protection case)
                        if buffDef.tooltipCheck then
                            local tooltipMatch = false
                            for line = 1, SS_TooltipScanner:NumLines() do
                                local lineText = getglobal("SS_TooltipScannerTextLeft" .. line)
                                if lineText and lineText:GetText() then
                                    if string.find(lineText:GetText(), buffDef.tooltipCheck) then
                                        tooltipMatch = true
                                        break
                                    end
                                end
                            end
                            if tooltipMatch then
                                foundBuffs[buffDef.name] = true
                            end
                        else
                            -- No tooltip check needed
                            foundBuffs[buffDef.name] = true
                        end
                        break
                    end
                end
            end
        end
    end
    
    return foundBuffs
end

-- ============================================================================
-- HELPER: Check if player needs a specific buff
-- ============================================================================
function SS_RaidBuff_PlayerNeedsBuff(buffDef, playerName, playerClass, playerSpec)
    local appliesTo = buffDef.appliesTo
    
    if appliesTo == "everyone" then
        return true
    elseif appliesTo == "manaUsers" then
        return playerSpec and SS_IsManaUser(playerSpec)
    elseif appliesTo == "tanks" then
        return playerSpec and SS_ConsumeConfig_SpecRoles[playerSpec] == "Tanks"
    elseif appliesTo == "druids" then
        return playerClass == "Druid"
    elseif appliesTo == "selfMage" then
        return playerClass == "Mage"
    elseif appliesTo == "selfHunter" then
        return playerClass == "Hunter"
    elseif appliesTo == "selfWarlock" then
        return playerClass == "Warlock"
    elseif appliesTo == "selfPriestDiscShadow" then
        return playerClass == "Priest" and playerSpec and SS_NeedsInnerFire(playerSpec)
    elseif appliesTo == "selfShaman" then
        return playerClass == "Shaman"
    end
    
    return false
end

-- ============================================================================
-- CORE: Check entire raid for buffs
-- ============================================================================
function SS_RaidBuff_CheckEntireRaid()
    local results = {}  -- [playerName] = {buffsFound, buffsRequired, missing}
    local classInfo = SS_RaidBuff_GetRaidClasses()
    
    -- Special case: Track if ANY druid has Emerald Blessing
    local anyDruidHasEmeraldBlessing = false
    
    local numRaidMembers = GetNumRaidMembers()
    local totalMembers = (numRaidMembers > 0) and numRaidMembers or 1
    
    for i = 1, totalMembers do
        local name, class, unitID, playerSpec
        
        if numRaidMembers == 0 then
            -- Solo
            name = UnitName("player")
            _, class = UnitClass("player")
            class = SS_ConfigSpecs_ProperCase(class)
            unitID = "player"
            playerSpec = SS_Check_GetPlayerSpec(name)
        else
            -- In raid
            name, _, _, _, class = GetRaidRosterInfo(i)
            class = SS_ConfigSpecs_ProperCase(class)
            unitID = "raid" .. i
            playerSpec = SS_Check_GetPlayerSpec(name)
        end
        
        if name and UnitIsConnected(unitID) then
            -- Check if player has spec assigned
            if not playerSpec then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff8000" .. name .. " has no spec assigned - skipping buff check|r")
            else
                -- Scan player's buffs
                local foundBuffs = SS_RaidBuff_ScanPlayerBuffs(unitID)
            
            -- Check Emerald Blessing first (for group check)
            if foundBuffs["Emerald Blessing"] then
                anyDruidHasEmeraldBlessing = true
            end
            
            -- Determine which buffs this player needs
            local requiredBuffs = {}
            local missingBuffs = {}
            local foundCount = 0
            
            for j = 1, table.getn(SS_RaidBuffs_Definitions) do
                local buffDef = SS_RaidBuffs_Definitions[j]
                local shouldCheck = true
                
                -- Skip optional buffs if checkbox not ticked
                if buffDef.optional then
                    if buffDef.name == "Shadow Protection" and not SS_RaidBuffs_Selected.ShadowProtection then
                        shouldCheck = false
                    end
                    if buffDef.name == "Thorns" and not SS_RaidBuffs_Selected.Thorns then
                        shouldCheck = false
                    end
                    if buffDef.name == "Emerald Blessing" and not SS_RaidBuffs_Selected.EmeraldBlessing then
                        shouldCheck = false
                    end
                end
                
                -- Skip if required class not online
                if shouldCheck and buffDef.needsClass and not classInfo[buffDef.needsClass].online then
                    shouldCheck = false
                end
                
                -- Check if player needs this buff
                if shouldCheck and SS_RaidBuff_PlayerNeedsBuff(buffDef, name, class, playerSpec) then
                    table.insert(requiredBuffs, buffDef.name)
                    
                    if foundBuffs[buffDef.name] then
                        foundCount = foundCount + 1
                    else
                        table.insert(missingBuffs, {
                            name = buffDef.name,
                            personal = buffDef.personal or false
                        })
                    end
                end
				
            end
            
            results[name] = {
                class = class,
                spec = playerSpec,
                buffsFound = foundCount,
                buffsRequired = table.getn(requiredBuffs),
                missing = missingBuffs
            }
			end
        end
    end
    
    -- Post-process Emerald Blessing
    if SS_RaidBuffs_Selected.EmeraldBlessing and anyDruidHasEmeraldBlessing then
        -- Remove Emerald Blessing from all missing lists
        for playerName, data in pairs(results) do
            for i = table.getn(data.missing), 1, -1 do
                if data.missing[i].name == "Emerald Blessing" then
                    table.remove(data.missing, i)
                    data.buffsFound = data.buffsFound + 1
                end
            end
        end
    end
    
    return results
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function SS_RaidBuff_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Raid Buff Checking module loaded!|r")
end