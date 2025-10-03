-- ============================================================================
-- SLACKSPOTTER - CONSUME PRESETS
-- Default consumable assignments for each raid and spec
-- Syntax: [RaidInstance][SpecName] = {consumes = {...}, minRequired = X}
-- ============================================================================

SS_ConsumePresets = {}

-- ============================================================================
-- MOLTEN CORE (MC)
-- ============================================================================
SS_ConsumePresets["MC"] = {
    WarriorDPS = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose", "Juju Power", "Juju Might"},
        minRequired = 2
    },
    WarriorTank = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose"},
        minRequired = 2
    },
    -- TODO: Add remaining 21 specs
}

-- ============================================================================
-- BLACKWING LAIR (BWL)
-- ============================================================================
SS_ConsumePresets["BWL"] = {
    WarriorDPS = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose", "Juju Power", "Juju Might"},
        minRequired = 3
    },
    WarriorTank = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose"},
        minRequired = 2
    },
    -- TODO: Add remaining 21 specs
}

-- ============================================================================
-- AQ40
-- ============================================================================
SS_ConsumePresets["AQ40"] = {
    WarriorDPS = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose", "Juju Power", "Juju Might", "Greater Nature Protection Potion"},
        minRequired = 3
    },
    WarriorTank = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose", "Greater Nature Protection Potion"},
        minRequired = 3
    },
    -- TODO: Add remaining 21 specs
}

-- ============================================================================
-- NAXXRAMAS (NAXX)
-- ============================================================================
SS_ConsumePresets["Naxx"] = {
    WarriorDPS = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose", "Juju Power", "Juju Might"},
        minRequired = 4
    },
    WarriorTank = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose"},
        minRequired = 3
    },
    -- TODO: Add remaining 21 specs
}

-- ============================================================================
-- KARAZHAN 40 (KARA40)
-- ============================================================================
SS_ConsumePresets["Kara40"] = {
    WarriorDPS = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose", "Juju Power", "Juju Might"},
        minRequired = 3
    },
    WarriorTank = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose"},
        minRequired = 2
    },
    -- TODO: Add remaining 21 specs
}

-- ============================================================================
-- KARAZHAN 10 (KARA10)
-- ============================================================================
SS_ConsumePresets["Kara10"] = {
    WarriorDPS = {
        consumes = {"Flask of the Titans", "Elixir of the Mongoose"},
        minRequired = 1
    },
    -- TODO: Add remaining specs
}

-- ============================================================================
-- EMERALD SANCTUM (ES)
-- ============================================================================
SS_ConsumePresets["ES"] = {
    WarriorDPS = {
        consumes = {"Flask of the Titans", "Greater Nature Protection Potion"},
        minRequired = 1
    },
    -- TODO: Add remaining specs
}

-- ============================================================================
-- AQ20
-- ============================================================================
SS_ConsumePresets["AQ20"] = {
    WarriorDPS = {
        consumes = {"Elixir of the Mongoose", "Juju Power"},
        minRequired = 1
    },
    -- TODO: Add remaining specs
}

-- ============================================================================
-- ZULGURUB (ZG)
-- ============================================================================
SS_ConsumePresets["ZG"] = {
    WarriorDPS = {
        consumes = {"Elixir of the Mongoose", "Juju Power"},
        minRequired = 1
    },
    -- TODO: Add remaining specs
}

-- ============================================================================
-- ONYXIA (ONY)
-- ============================================================================
SS_ConsumePresets["Ony"] = {
    WarriorDPS = {
        consumes = {"Greater Fire Protection Potion", "Elixir of the Mongoose"},
        minRequired = 1
    },
    -- TODO: Add remaining specs
}

-- Note: Presets contain placeholders. Full preset data from old SlackSpotter
-- will be migrated later. Structure is ready for easy addition via notepad++.