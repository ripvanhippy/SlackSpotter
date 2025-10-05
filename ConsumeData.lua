-- ============================================================================
-- SLACKSPOTTER - CONSUME DATA
-- Consumables list, buff mappings, groups, and concoctions
-- ============================================================================

-- ============================================================================
-- CONSUMABLES DATA (with buff detection)
-- ============================================================================
SS_ConsumeData_Consumables = {
    {
        category = "Flasks",
        items = {
            {name = "Flask of Supreme Power", effect = "(150 sp)", buffName = "Supreme Power"},
            {name = "Flask of the Titans", effect = "(1200 hp)", buffName = "Flask of the Titans"},
            {name = "Flask of Distilled Wisdom", effect = "(2000 mana)", buffName = "Distilled Wisdom"},
            {name = "Flask of Chromatic Resistance", effect = "(50 res)", buffName = "Flask of Chromatic Resistance"}
        }
    },
    {
        category = "Worldbuffs",
        items = {
            {name = "Spirit of Zanza", effect = "(50 sta/spi)", buffName = "Spirit of Zanza"},
            {name = "Swiftness of Zanza", effect = "(20% run)", buffName = "Swiftness of Zanza"},
            {name = "Cerebral Cortex Compound", effect = "(25 int)", buffName = "Infallible Mind"},
            {name = "Ground Scorpok Assay", effect = "(25 agi)", buffName = "Strike of the Scorpok"},
            {name = "R.O.I.D.S.", effect = "(25 str)", buffName = "Rage of Ages"}
        }
    },
    {
        category = "Elixirs",
        items = {
            {name = "Dreamshard Elixir", effect = "(15 sp, 2 crit)", buffName = "Dreamshard Elixir"},
            {name = "Mageblood Elixir", effect = "(12 mp5)", buffName = "Mana Regeneration", tooltipKeyword = "12 mana per 5"},
            {name = "Greater Arcane Elixir", effect = "(35 sp)", buffName = "Greater Arcane Elixir"},
            {name = "Elixir of Shadowpower", effect = "(40 ssp)", buffName = "Shadow Power"},
            {name = "Elixir of Greater Firepower", effect = "(40 fsp)", buffName = "Greater Firepower"},
            {name = "Elixir of Greater Nature Power", effect = "(40 nsp)", buffName = "Elixir of Greater Nature Power"},
            {name = "Elixir of Greater Frost Power", effect = "(40 fsp)", buffName = "Elixir of Greater Frost Power"},
            {name = "Elixir of the Mongoose", effect = "(25 agi, 2 crit)", buffName = "Elixir of the Mongoose"},
            {name = "Elixir of the Giants", effect = "(25 str)", buffName = "Elixir of the Giants"},
            {name = "Elixir of Fortitude", effect = "(120 hp)", buffName = "Health II"},
            {name = "Major Troll's Blood Potion", effect = "(20 hp5)", buffName = "Major Troll's Blood Potion"},
            {name = "Elixir of Superior Defense", effect = "(450 armor)", buffName = "Elixir of Superior Defense"}
        }
    },
    {
        category = "Food",
        items = {
            {name = "Danonzo's Tel'Abim Delight", effect = "(22 sp)", buffName = "Well Fed", tooltipKeyword = "Spell Damage"},
            {name = "Danonzo's Tel'Abim Medley", effect = "(2 haste)", buffName = "Well Fed", tooltipKeyword = "Haste"},
            {name = "Danonzo's Tel'Abim Surprise", effect = "(45 rap)", buffName = "Well Fed", tooltipKeyword = "Ranged Attack Power"},
            {name = "Hardened Mushroom", effect = "(25 sta)", buffName = "Increased Stamina"},
            {name = "Sour Mountain Berry", effect = "(10 agi)", buffName = "Increased Agility"},
            {name = "Power Mushroom", effect = "(20 str)", buffName = "Well Fed", tooltipKeyword = "Strength"},
            {name = "Tender Wolf Steak", effect = "(12 sta/spi)", buffName = "Well Fed", tooltipKeyword = "Spirit"},
            {name = "Le Fishe Au Chocolat", effect = "(10 sta)", buffName = "Well Fed", tooltipKeyword = "dodge"},
            {name = "Nightfin Soup", effect = "(8 mp5)", buffName = "Mana Regeneration", tooltipKeyword = "8 Mana every 5"},
            {name = "Empowering Herbal Salad", effect = "(10 int)", buffName = "Increased Healing Bonus"}
        }
    },
    {
        category = "Alcohol",
        items = {
            {name = "Medivh's Merlot Blue", effect = "(15 sta)", buffName = "Medivh's Merlot Blue"},
            {name = "Medivh's Merlot", effect = "(15 sta)", buffName = "Medivh's Merlot"},
            {name = "Rumsey Rum Black Label", effect = "(15 sta)", buffName = "Rumsey Rum Black Label"}
        }
    },
    {
        category = "Other",
        items = {
            {name = "Dreamtonic", effect = "(10 all stats)", buffName = "Dreamtonic"},
            {name = "Juju Power", effect = "(30 str)", buffName = "Juju Power"},
            {name = "Juju Might", effect = "(40 ap)", buffName = "Juju Might"},
            {name = "Winterfall Firewater", effect = "(35 ap)", buffName = "Winterfall Firewater"},
			{name = "Battle Shout (TEST)", effect = "(test)", buffName = "Battle Shout"}
        }
    }
}

-- ============================================================================
-- MUTUALLY EXCLUSIVE CONSUME GROUPS
-- ============================================================================
SS_ConsumeData_Groups = {
    {
        groupName = "Flask",
        consumes = {
            "Flask of Supreme Power",
            "Flask of the Titans",
            "Flask of Distilled Wisdom",
            "Flask of Chromatic Resistance"
        }
    },
    {
        groupName = "Power OR Giants",
        consumes = {
            "Juju Power",
            "Elixir of the Giants"
        }
    },
    {
        groupName = "Might OR Firewater",
        consumes = {
            "Juju Might",
            "Winterfall Firewater"
        }
    },
    {
        groupName = "Zanza",
        consumes = {
            "Spirit of Zanza",
            "Swiftness of Zanza"
        }
    },
    {
        groupName = "Blasted Lands",
        consumes = {
            "Ground Scorpok Assay",
            "R.O.I.D.S.",
            "Cerebral Cortex Compound"
        }
    },
    {
        groupName = "Alcohol",
        consumes = {
            "Medivh's Merlot",
            "Rumsey Rum Black Label",
            "Medivh's Merlot Blue"
        }
    },
    {
        groupName = "Food",
        consumes = {
            "Danonzo's Tel'Abim Delight",
            "Danonzo's Tel'Abim Medley",
            "Danonzo's Tel'Abim Surprise",
            "Hardened Mushroom",
            "Sour Mountain Berry",
            "Power Mushroom",
            "Tender Wolf Steak",
            "Le Fishe Au Chocolat",
            "Nightfin Soup",
            "Empowering Herbal Salad"
        }
    }
}

-- ============================================================================
-- CONCOCTIONS (TurtleWoW - 1 buff = 2 consumes)
-- ============================================================================
SS_ConsumeData_Concoctions = {
    ["Concoction of Arcane Giant"] = {
        "Elixir of the Giants",
        "Greater Arcane Elixir"
    },
    ["Concoction of Dreamwater"] = {
        "Dreamtonic",
        "Winterfall Firewater"
    },
    ["Concoction of Emerald Mongoose"] = {
        "Elixir of the Mongoose",
        "Dreamshard Elixir"
    }
}

-- ============================================================================
-- CONSUMABLE TO ROLES MAPPING (for Tab 6 filtering)
-- ============================================================================
SS_ConsumeData_ConsumableRoles = {
--Flasks
    ["Flask of Supreme Power"] = {"Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Flask of the Titans"] = {"Tanks", "Physical", "PhysRanged"},
    ["Flask of Distilled Wisdom"] = {"Healers"},
    ["Flask of Chromatic Resistance"] = {},

--Zanza
    ["Spirit of Zanza"] = {"Tanks", "Physical", "PhysRanged", "Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Swiftness of Zanza"] = {"Tanks", "Physical", "PhysRanged", "Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},

--Blasted Lands
    ["Cerebral Cortex Compound"] = {"Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Ground Scorpok Assay"] = {"Physical", "PhysRanged", "Tanks"},
    ["R.O.I.D.S."] = {"Physical", "Tanks"},

--Elixirs
    ["Dreamshard Elixir"] = {"Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Mageblood Elixir"] = {"Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Greater Arcane Elixir"] = {"Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Elixir of Shadowpower"] = {"CastersShadow"},
    ["Elixir of Greater Firepower"] = {"CastersFire"},
    ["Elixir of Greater Nature Power"] = {"CastersNature"},
    ["Elixir of Greater Frost Power"] = {"CastersFrost"},
    ["Elixir of the Mongoose"] = {"Tanks", "Physical", "PhysRanged"},
    ["Elixir of the Giants"] = {"Tanks", "Physical"},
    ["Elixir of Fortitude"] = {"Tanks"},
    ["Major Troll's Blood Potion"] = {"Tanks"},
    ["Elixir of Superior Defense"] = {"Tanks"},

--Food
    ["Danonzo's Tel'Abim Delight"] = {"Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Danonzo's Tel'Abim Medley"] = {"Tanks", "Physical", "PhysRanged", "Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Danonzo's Tel'Abim Surprise"] = {"PhysRanged"},
    ["Hardened Mushroom"] = {"Tanks"},
    ["Sour Mountain Berry"] = {"Physical", "PhysRanged"},
    ["Power Mushroom"] = {"Physical"},
    ["Tender Wolf Steak"] = {},
    ["Le Fishe Au Chocolat"] = {"Tanks"},
    ["Nightfin Soup"] = {"Healers"},
    ["Empowering Herbal Salad"] = {"Healers"},

--Alcohol
    ["Medivh's Merlot Blue"] = {"Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Medivh's Merlot"] = {"Tanks", "Physical", "PhysRanged"},
    ["Rumsey Rum Black Label"] = {"Tanks", "Physical", "PhysRanged"},

--Shortterm
    ["Dreamtonic"] = {"Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Juju Power"] = {"Physical", "Tanks"},
    ["Juju Might"] = {"Physical", "PhysRanged", "Tanks"},
    ["Winterfall Firewater"] = {"Physical", "PhysRanged", "Tanks"},
	["Battle Shout (TEST)"] = {"Physical"}
}

-- ============================================================================
-- CONSUME ID MAPPING (for compact presets)
-- Maps numeric IDs to consume names for preset storage
-- ============================================================================
SS_ConsumeData_IDMapping = {
    [1] = "Flask of the Titans",
    [2] = "Flask of Supreme Power",
    [3] = "Flask of Distilled Wisdom",
    [4] = "Flask of Chromatic Resistance",
    [5] = "Elixir of the Mongoose",
    [6] = "Elixir of Giants",
    [7] = "Elixir of Superior Defense",
    [8] = "Elixir of Greater Firepower",
    [9] = "Elixir of Greater Arcane Power",
    [10] = "Elixir of Frost Power",
    [11] = "Elixir of Shadow Power",
    [12] = "Elixir of Healing Power",
    [13] = "Elixir of Greater Intellect",
    [14] = "Elixir of Greater Agility",
    [15] = "Greater Arcane Elixir",
    [16] = "Elixir of the Sages",
    [17] = "Elixir of Fortitude",
    [18] = "Blessed Sunfruit Juice",
    [19] = "Rumsey Rum Black Label",
    [20] = "Kreeg's Stout Beatdown",
    [21] = "Gordok Green Grog",
    [22] = "R.O.I.D.S.",
    [23] = "Ground Scorpok Assay",
    [24] = "Cerebral Cortex Compound",
    [25] = "Gizzard Gum",
    [26] = "Lung Juice Cocktail",
    [27] = "Juju Power",
    [28] = "Juju Might",
    [29] = "Juju Flurry",
    [30] = "Juju Chill",
    [31] = "Spirit of Zanza",
    [32] = "Swiftness of Zanza",
    [33] = "Sheen of Zanza",
    [34] = "Greater Fire Protection Potion",
    [35] = "Greater Frost Protection Potion",
    [36] = "Greater Nature Protection Potion",
    [37] = "Greater Arcane Protection Potion",
    [38] = "Greater Shadow Protection Potion",
    [39] = "Greater Holy Protection Potion",
    [40] = "Mighty Rage Potion",
    [41] = "Mageblood Potion",
    [42] = "Winterfall Firewater",
    [43] = "Elixir of Brute Force",
    [44] = "Elixir of the Honored Dead",
    [45] = "Gift of Arthas",
    [46] = "Smoked Desert Dumplings",
    [47] = "Dirge's Kickin' Chimaerok Chops",
    [48] = "Blessed Sunfruit",
    [49] = "Nightfin Soup",
    [50] = "Grilled Squid"
}

-- Reverse mapping: name -> ID
SS_ConsumeData_NameToID = {}
for id, name in pairs(SS_ConsumeData_IDMapping) do
    SS_ConsumeData_NameToID[name] = id
end