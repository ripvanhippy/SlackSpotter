-- ============================================================================
-- SLACKSPOTTER - CONSUME DATA
-- Consumables list and role mappings (from original SlackSpotter)
-- ============================================================================

-- ============================================================================
-- CONSUMABLES DATA
-- ============================================================================
SS_ConsumeData_Consumables = {
    {
        category = "Flasks",
        items = {
            {name = "Flask of Supreme Power", effect = "(150 sp)"},
            {name = "Flask of the Titans", effect = "(1200 hp)"},
            {name = "Flask of Distilled Wisdom", effect = "(2000 mana)"},
            {name = "Flask of Chromatic Resistance", effect = "(50 res)"}
        }
    },
    {
        category = "Worldbuffs",
        items = {
            {name = "Spirit of Zanza", effect = "(50 sta/spi)"},
            {name = "Swiftness of Zanza", effect = "(20% run)"},
            {name = "Cerebral Cortex Compound", effect = "(25 int)"},
            {name = "Ground Scorpok Assay", effect = "(25 agi)"},
            {name = "R.O.I.D.S.", effect = "(25 str)"}
        }
    },
    {
        category = "Elixirs",
        items = {
            {name = "Dreamshard Elixir", effect = "(15 sp, 2 crit)"},
            {name = "Mageblood Elixir", effect = "(12 mp5)"},
            {name = "Greater Arcane Elixir", effect = "(35 sp)"},
            {name = "Elixir of Shadowpower", effect = "(40 ssp)"},
            {name = "Elixir of Greater Firepower", effect = "(40 fsp)"},
            {name = "Elixir of Greater Nature Power", effect = "(40 nsp)"},
            {name = "Elixir of Greater Frost Power", effect = "(40 fsp)"},
            {name = "Elixir of the Mongoose", effect = "(25 agi, 2 crit)"},
            {name = "Elixir of the Giants", effect = "(25 str)"},
            {name = "Elixir of Fortitude", effect = "(120 hp)"},
            {name = "Major Troll's Blood Potion", effect = "(20 hp5)"},
            {name = "Elixir of Superior Defense", effect = "(450 armor)"}
        }
    },
    {
        category = "Food",
        items = {
            {name = "Danonzo's Tel'Abim Delight", effect = "(22 sp)"},
            {name = "Danonzo's Tel'Abim Medley", effect = "(2 haste)"},
            {name = "Danonzo's Tel'Abim Surprise", effect = "(45 rap)"},
            {name = "Hardened Mushroom", effect = "(25 sta)"},
            {name = "Sour Mountain Berry", effect = "(10 agi)"},
            {name = "Power Mushroom", effect = "(20 str)"},
            {name = "Tender Wolf Steak", effect = "(12 sta/spi)"},
            {name = "Le Fishe Au Chocolat", effect = "(10 sta)"},
            {name = "Nightfin Soup", effect = "(8 mp5)"},
            {name = "Empowering Herbal Salad", effect = "(10 int)"}
        }
    },
    {
        category = "Alcohol",
        items = {
            {name = "Medivh's Merlot Blue", effect = "(15 sta)"},
            {name = "Medivh's Merlot", effect = "(15 sta)"},
            {name = "Rumsey Rum Black Label", effect = "(15 sta)"}
        }
    },
    {
        category = "Other",
        items = {
            {name = "Dreamtonic", effect = "(10 all stats)"},
            {name = "Juju Power", effect = "(30 str)"},
            {name = "Juju Might", effect = "(40 ap)"},
            {name = "Winterfall Firewater", effect = "(35 ap)"}
        }
    }
}

-- ============================================================================
-- CONSUMABLE TO ROLES MAPPING
-- ============================================================================
SS_ConsumeData_ConsumableRoles = {
    -- Flasks
    ["Flask of Supreme Power"] = {"Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Flask of the Titans"] = {"Tanks", "Physical", "PhysRanged"},
    ["Flask of Distilled Wisdom"] = {"Healers"},
    ["Flask of Chromatic Resistance"] = {},
    
    -- Worldbuffs
    ["Spirit of Zanza"] = {"Tanks", "Physical", "PhysRanged", "Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Swiftness of Zanza"] = {"Tanks", "Physical", "PhysRanged", "Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Cerebral Cortex Compound"] = {"Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Ground Scorpok Assay"] = {"Physical", "PhysRanged", "Tanks"},
    ["R.O.I.D.S."] = {"Physical", "Tanks"},
    
    -- Elixirs
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
    
    -- Food
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
    
    -- Alcohol
    ["Medivh's Merlot Blue"] = {"Healers", "Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Medivh's Merlot"] = {"Tanks", "Physical", "PhysRanged"},
    ["Rumsey Rum Black Label"] = {"Tanks", "Physical", "PhysRanged"},
    
    -- Other
    ["Dreamtonic"] = {"Casters", "CastersNature", "CastersShadow", "CastersFire", "CastersFrost"},
    ["Juju Power"] = {"Physical", "Tanks"},
    ["Juju Might"] = {"Physical", "PhysRanged", "Tanks"},
    ["Winterfall Firewater"] = {"Physical", "PhysRanged", "Tanks"}
}