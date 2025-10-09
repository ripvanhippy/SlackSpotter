-- ============================================================================
-- SLACKSPOTTER - MAPPING DATA
-- Global lookup tables for class colors, roles, and other mappings
-- ============================================================================

-- ============================================================================
-- CLASS COLORS (from Blizzard's RAID_CLASS_COLORS)
-- ============================================================================
SS_ClassColors = {
    ["WARRIOR"] = {r = 0.78, g = 0.61, b = 0.43},
    ["MAGE"] = {r = 0.41, g = 0.8, b = 0.94},
    ["ROGUE"] = {r = 1.0, g = 0.96, b = 0.41},
    ["DRUID"] = {r = 1.0, g = 0.49, b = 0.04},
    ["HUNTER"] = {r = 0.67, g = 0.83, b = 0.45},
    ["SHAMAN"] = {r = 0.14, g = 0.35, b = 1.0},
    ["PRIEST"] = {r = 1.0, g = 1.0, b = 1.0},
    ["WARLOCK"] = {r = 0.58, g = 0.51, b = 0.79},
    ["PALADIN"] = {r = 0.96, g = 0.55, b = 0.73}
}

-- Helper: Get colored player name for announcements
function SS_GetColoredName(playerName, class)
    local classUpper = string.upper(class)
    local color = SS_ClassColors[classUpper]
    if color then
        return string.format("|cff%02x%02x%02x%s|r", 
            color.r * 255, 
            color.g * 255, 
            color.b * 255, 
            playerName)
    end
    return playerName
end

-- ============================================================================
-- MANA-USING SPECS (need Divine Spirit and Arcane Intellect)
-- ============================================================================
SS_ManaUsingSpecs = {
    -- All Paladin specs use mana
    ["PaladinHoly"] = true,
    ["PaladinRet"] = true,
    ["PaladinTank"] = true,
    
    -- Both Hunter specs use mana
    ["HunterBM"] = true,
    ["HunterMM"] = true,
    
    -- All Shaman specs use mana
    ["ShamanEle"] = true,
    ["ShamanEnhance"] = true,
    ["ShamanResto"] = true,
    ["ShamanEnhTank"] = true,
    
    -- All Priest specs use mana
    ["PriestDisc"] = true,
    ["PriestShadow"] = true,
    ["PriestHoly"] = true,
    
    -- All Warlock specs use mana
    ["WarlockAffliction"] = true,
    ["WarlockDemo"] = true,
    
    -- All Mage specs use mana
    ["MageFire"] = true,
    ["MageFrost"] = true,
    ["MageArcane"] = true,
    
    -- Only Druid Owl and Tree use mana (Cat and Bear don't)
    ["DruidOwl"] = true,
    ["DruidTree"] = true
    -- DruidCat and DruidBear NOT included
}

-- Helper: Check if spec needs mana buffs
function SS_IsManaUser(specName)
    return SS_ManaUsingSpecs[specName] == true
end

-- ============================================================================
-- PRIEST SPECS NEEDING INNER FIRE
-- ============================================================================
SS_InnerFireSpecs = {
    ["PriestDisc"] = true,
    ["PriestShadow"] = true
    -- PriestHoly does NOT get Inner Fire
}

-- Helper: Check if priest spec needs Inner Fire
function SS_NeedsInnerFire(specName)
    return SS_InnerFireSpecs[specName] == true
end

-- ============================================================================
-- SHORTENED CONSUME NAMES (for announcements)
-- ============================================================================
SS_ConsumeShortNames = {
    ["Elixir of the Mongoose"] = "Mongoose",
    ["Elixir of the Giants"] = "Giants",
    ["Elixir of Superior Defense"] = "Sup Defense",
    ["Elixir of Greater Firepower"] = "Fire Power",
    ["Elixir of Shadowpower"] = "Shadow Power",
    ["Elixir of Greater Nature Power"] = "Nature Power",
    ["Elixir of Greater Frost Power"] = "Frost Power",
    ["Flask of Supreme Power"] = "Supreme Flask",
    ["Flask of the Titans"] = "Titans Flask",
    ["Flask of Distilled Wisdom"] = "Wisdom Flask",
    ["Flask of Chromatic Resistance"] = "Chrome Flask",
    ["Greater Arcane Elixir"] = "Arcane Elixir",
    ["Cerebral Cortex Compound"] = "Cerebral",
    ["Ground Scorpok Assay"] = "Scorpok",
    ["Danonzo's Tel'Abim Delight"] = "Tel'Abim SP",
    ["Danonzo's Tel'Abim Medley"] = "Tel'Abim Haste",
    ["Danonzo's Tel'Abim Surprise"] = "Tel'Abim RAP",
    ["Major Troll's Blood Potion"] = "Troll's Blood",
    ["Empowering Herbal Salad"] = "Herb Salad",
    ["Winterfall Firewater"] = "Firewater"
}

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function SS_MappingData_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Mapping Data loaded!|r")
end