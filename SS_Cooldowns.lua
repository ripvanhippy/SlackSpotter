-- ============================================================================
-- SLACKSPOTTER - COOLDOWNS MODULE (Tab 3)
-- Raid cooldown tracking system
-- ============================================================================

-- ============================================================================
-- SAVED VARIABLES
-- ============================================================================
SS_CooldownsDB = SS_CooldownsDB or {}

-- ============================================================================
-- WORKING MEMORY
-- ============================================================================
SS_Cooldowns_Tracked = {}
SS_Cooldowns_Frames = {}
SS_Cooldowns_MainFrame = nil
SS_Cooldowns_UpdateFrame = nil
SS_Cooldowns_ScrollOffset = 0
SS_Cooldowns_MaxVisibleRows = 9
SS_Cooldowns_RowHeight = 28

-- ============================================================================
-- CLASS COLORS
-- ============================================================================
SS_Cooldowns_ClassColors = {
    ["WARRIOR"] = {r = 0.78, g = 0.61, b = 0.43},
    ["PALADIN"] = {r = 0.96, g = 0.55, b = 0.73},
    ["HUNTER"] = {r = 0.67, g = 0.83, b = 0.45},
    ["ROGUE"] = {r = 1.0, g = 0.96, b = 0.41},
    ["PRIEST"] = {r = 1.0, g = 1.0, b = 1.0},
    ["SHAMAN"] = {r = 0.0, g = 0.44, b = 0.87},
    ["MAGE"] = {r = 0.41, g = 0.8, b = 0.94},
    ["WARLOCK"] = {r = 0.58, g = 0.51, b = 0.79},
    ["DRUID"] = {r = 1.0, g = 0.49, b = 0.04}
}

-- ============================================================================
-- TRACKED SPELLS
-- ============================================================================
SS_Cooldowns_TrackedSpells = {
    -- Druid
    ["Tranquility"] = {cooldown = 1800, class = "DRUID", type = "spell", icon = "Interface\\Icons\\Spell_Nature_Tranquility", multiTarget = true},
    ["Challenging Roar"] = {cooldown = 600, class = "DRUID", type = "spell", icon = "Interface\\Icons\\Ability_Druid_ChallangingRoar", multiTarget = true},
    ["Rebirth"] = {cooldown = 1800, class = "DRUID", type = "spell", icon = "Interface\\Icons\\Spell_Nature_Reincarnation", multiTarget = false},
    ["Innervate"] = {cooldown = 360, class = "DRUID", type = "buff", icon = "Interface\\Icons\\Spell_Nature_Lightning", multiTarget = false},

    -- Shaman
    ["Spirit Link"] = {cooldown = 600, class = "SHAMAN", type = "buff", icon = "Interface\\Icons\\Spell_Nature_MagicImmunity", multiTarget = false},

    -- Warrior
    ["Challenging Shout"] = {cooldown = 600, class = "WARRIOR", type = "spell", icon = "Interface\\Icons\\Ability_BullRush", multiTarget = true},
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

function SS_Cooldowns_StripRealmName(playerName)
    if not playerName then return playerName end
    local name = string.match(playerName, "^([^-]+)")
    return name or playerName
end

function SS_Cooldowns_GetPlayerClass(playerName)
    local cleanName = SS_Cooldowns_StripRealmName(playerName)

    -- Check raid
    local raidSize = GetNumRaidMembers()
    if raidSize > 0 then
        for i = 1, raidSize do
            local name, _, _, _, class = GetRaidRosterInfo(i)
            if name == cleanName then
                return class
            end
        end
    end

    -- Check self
    if UnitName("player") == cleanName then
        local _, class = UnitClass("player")
        return class
    end

    -- Check party
    for i = 1, GetNumPartyMembers() do
        local unit = "party"..i
        if UnitName(unit) == cleanName then
            local _, class = UnitClass(unit)
            return class
        end
    end

    return "UNKNOWN"
end

function SS_Cooldowns_FormatTime(seconds)
    if seconds < 0 then return "Ready" end

    local hours = math.floor(seconds / 3600)
    local mins = math.floor(math.mod(seconds, 3600) / 60)
    local secs = math.floor(math.mod(seconds, 60))

    if hours > 0 then
        return string.format("%dh %dm", hours, mins)
    elseif mins > 0 then
        return string.format("%dm %ds", mins, secs)
    else
        return string.format("%ds", secs)
    end
end

-- ============================================================================
-- CREATE COOLDOWN ROW
-- ============================================================================

function SS_Cooldowns_CreateRow(rowIndex)
    local parent = getglobal("SS_Tab3_CooldownPanel_Content")
    if not parent then return nil end
    
    local rowName = "SS_Tab3_CooldownRow"..rowIndex
    local row = getglobal(rowName)
    
    if not row then
        row = CreateFrame("Frame", rowName, parent)
        row:SetWidth(700)
        row:SetHeight(SS_Cooldowns_RowHeight)
        row:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, -(rowIndex-1) * SS_Cooldowns_RowHeight - 5)
        
        -- Background
        row:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 6,
            insets = {left = 2, right = 2, top = 2, bottom = 2}
        })
        row:SetBackdropColor(0.15, 0.15, 0.15, 0.6)
        row:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
        
        -- Player name
        row.playerText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.playerText:SetPoint("TOPLEFT", row, "TOPLEFT", 5, -3)
        row.playerText:SetWidth(100)
        row.playerText:SetJustifyH("LEFT")
        
        -- Spell icon
        row.iconFrame = CreateFrame("Frame", nil, row)
        row.iconFrame:SetWidth(18)
        row.iconFrame:SetHeight(18)
        row.iconFrame:SetPoint("TOPLEFT", row, "TOPLEFT", 110, -3)
        
        row.icon = row.iconFrame:CreateTexture(nil, "ARTWORK")
        row.icon:SetAllPoints(row.iconFrame)
        row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        
        -- Spell name
        row.spellText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.spellText:SetPoint("LEFT", row.iconFrame, "RIGHT", 5, 0)
        row.spellText:SetWidth(120)
        row.spellText:SetJustifyH("LEFT")
        row.spellText:SetTextColor(1.0, 0.82, 0.0, 1)
        
        -- Target text
        row.targetText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.targetText:SetPoint("TOPLEFT", row, "TOPLEFT", 265, -3)
        row.targetText:SetWidth(80)
        row.targetText:SetJustifyH("LEFT")
        row.targetText:SetTextColor(0.5, 0.9, 0.5, 1)
        
        -- Timer text
        row.timerText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.timerText:SetPoint("TOPRIGHT", row, "TOPRIGHT", -5, -3)
        row.timerText:SetWidth(60)
        row.timerText:SetJustifyH("RIGHT")
        
        -- Remove button
        row.removeButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        row.removeButton:SetWidth(50)
        row.removeButton:SetHeight(16)
        row.removeButton:SetPoint("TOPRIGHT", row, "TOPRIGHT", -5, -4)
        row.removeButton:SetText("Remove")
        row.removeButton:SetScript("OnClick", function()
            local key = this:GetParent().cooldownKey
            if key and SS_Cooldowns_Tracked[key] then
                SS_Cooldowns_Tracked[key] = nil
                SS_CooldownsDB = SS_Cooldowns_Tracked
                SS_Cooldowns_UpdateDisplay()
            end
        end)
        row.removeButton:Hide()
        
        -- Progress bar background
        row.barBg = CreateFrame("Frame", nil, row)
        row.barBg:SetWidth(694)
        row.barBg:SetHeight(6)
        row.barBg:SetPoint("BOTTOM", row, "BOTTOM", 0, 2)
        row.barBg:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 4,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        })
        row.barBg:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
        row.barBg:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
        
        -- Progress bar
        row.bar = CreateFrame("StatusBar", nil, row.barBg)
        row.bar:SetPoint("TOPLEFT", row.barBg, "TOPLEFT", 2, -2)
        row.bar:SetPoint("BOTTOMRIGHT", row.barBg, "BOTTOMRIGHT", -2, 2)
        row.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        row.bar:SetMinMaxValues(0, 1)
        row.bar:SetValue(1)
        row.bar:SetStatusBarColor(0.2, 0.8, 0.2, 1)
    end
    
    return row
end

-- ============================================================================
-- UPDATE DISPLAY
-- ============================================================================

function SS_Cooldowns_UpdateDisplay()
    -- Hide all rows
    for i = 1, SS_Cooldowns_MaxVisibleRows do
        local row = getglobal("SS_Tab3_CooldownRow"..i)
        if row then row:Hide() end
    end
    
    -- Sort cooldowns by remaining time
    local sortedCooldowns = {}
    local currentTime = GetTime()
    
    for key, data in pairs(SS_Cooldowns_Tracked) do
        table.insert(sortedCooldowns, data)
    end
    
    table.sort(sortedCooldowns, function(a, b)
        local remainingA = a.endTime - currentTime
        local remainingB = b.endTime - currentTime
        
        if remainingA <= 0 and remainingB <= 0 then
            return false
        end
        
        if remainingA <= 0 and remainingB > 0 then
            return true
        end
        
        if remainingB <= 0 and remainingA > 0 then
            return false
        end
        
        return remainingA < remainingB
    end)
    
    -- Display visible cooldowns
    local visibleCount = 0
    for i = 1, table.getn(sortedCooldowns) do
        if visibleCount >= SS_Cooldowns_MaxVisibleRows then
            break
        end
        
        local data = sortedCooldowns[i]
        visibleCount = visibleCount + 1
        
        local row = SS_Cooldowns_CreateRow(visibleCount)
        if row then
            row:Show()
            
            -- Store cooldown key
            row.cooldownKey = data.player .. ":" .. data.spell
            
            -- Set player name with class color
            local color = SS_Cooldowns_ClassColors[data.class] or {r = 0.5, g = 0.5, b = 0.5}
            row.playerText:SetText(data.player)
            row.playerText:SetTextColor(color.r, color.g, color.b, 1)
            
            -- Set spell icon
            if data.icon then
                row.icon:SetTexture(data.icon)
            else
                row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            end
            
            -- Set spell name
            row.spellText:SetText(data.spell)
            
            -- Set target text
            if data.target and data.target ~= "" and data.spellType == "buff" then
                row.targetText:SetText(data.target)
                local targetColor = SS_Cooldowns_ClassColors[data.targetClass] or {r = 0.5, g = 0.5, b = 0.5}
                row.targetText:SetTextColor(targetColor.r, targetColor.g, targetColor.b, 1)
            else
                row.targetText:SetText("-")
                row.targetText:SetTextColor(0.5, 0.5, 0.5, 1)
            end
            
            -- Calculate remaining time
            local remaining = data.endTime - currentTime
            local progress = 0
            if data.duration > 0 then
                progress = remaining / data.duration
            end
            
            -- Update timer and color
            if remaining > 0 then
                row:SetBackdropColor(0.15, 0.15, 0.15, 0.6)
                row.timerText:SetText(SS_Cooldowns_FormatTime(remaining))
                row.timerText:Show()
                row.removeButton:Hide()
                
                if remaining < 30 then
                    row.timerText:SetTextColor(0.2, 1.0, 0.2, 1)
                    row.bar:SetStatusBarColor(0.2, 1.0, 0.2, 1)
                elseif remaining < 120 then
                    row.timerText:SetTextColor(1.0, 1.0, 0.2, 1)
                    row.bar:SetStatusBarColor(1.0, 1.0, 0.2, 1)
                else
                    row.timerText:SetTextColor(1.0, 0.5, 0.2, 1)
                    row.bar:SetStatusBarColor(1.0, 0.5, 0.2, 1)
                end
                
                row.bar:SetValue(math.max(0, math.min(1, 1 - progress)))
            else
                row:SetBackdropColor(0.1, 0.4, 0.1, 0.7)
                row.timerText:Hide()
                row.removeButton:Show()
                row.bar:SetStatusBarColor(0.2, 1.0, 0.2, 1)
                row.bar:SetValue(1)
            end
        end
    end
end

-- ============================================================================
-- ADD COOLDOWN
-- ============================================================================

function SS_Cooldowns_AddCooldown(playerName, spellName, target)
    local spellData = SS_Cooldowns_TrackedSpells[spellName]
    if not spellData then return end
    
    local cleanPlayerName = SS_Cooldowns_StripRealmName(playerName)
    local cleanTarget = target and SS_Cooldowns_StripRealmName(target) or nil
    
    local currentTime = GetTime()
    local endTime = currentTime + spellData.cooldown
    
    local key = cleanPlayerName .. ":" .. spellName
    local isRestart = SS_Cooldowns_Tracked[key] ~= nil
    
    local targetClass = nil
    if cleanTarget and cleanTarget ~= "" then
        targetClass = SS_Cooldowns_GetPlayerClass(cleanTarget)
    end
    
    SS_Cooldowns_Tracked[key] = {
        player = cleanPlayerName,
        spell = spellName,
        target = cleanTarget,
        targetClass = targetClass,
        startTime = currentTime,
        endTime = endTime,
        duration = spellData.cooldown,
        class = SS_Cooldowns_GetPlayerClass(cleanPlayerName),
        spellType = spellData.type,
        icon = spellData.icon
    }
    
    SS_Cooldowns_UpdateDisplay()
    
    local targetInfo = ""
    if cleanTarget and cleanTarget ~= "" and spellData.type == "buff" then
        targetInfo = " on " .. cleanTarget
    end
    
    local action = isRestart and "restarted" or "used"
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Cooldowns] " .. cleanPlayerName .. " " .. action .. " " .. spellName .. targetInfo .. "|r")
end

-- ============================================================================
-- PARSE COMBAT LOG
-- ============================================================================

function SS_Cooldowns_ParseCombatLog(msg)
    local player, spell, target
    local foundPattern = nil
    
    -- Check for spell hits/crits
    local _, _, p1, s1, t1 = string.find(msg, "(.+)'s (.+) hits (.+) for")
    if p1 then
        player, spell, target = p1, s1, t1
        foundPattern = "hit"
    end
    
    if not player then
        _, _, p1, s1, t1 = string.find(msg, "(.+)'s (.+) crits (.+) for")
        if p1 then
            player, spell, target = p1, s1, t1
            foundPattern = "crit"
        end
    end
    
    if not player then
        _, _, p1, s1 = string.find(msg, "(.+) begins to cast (.+)%.")
        if p1 then
            player, spell = p1, s1
            foundPattern = "begincast"
        end
    end
    
    if not player then
        _, _, p1, s1 = string.find(msg, "(.+) casts (.+)%.")
        if p1 then
            player, spell = p1, s1
            foundPattern = "cast"
        end
    end
    
    if not player then
        _, _, t1, s1, p1 = string.find(msg, "(.+) gains (.+) from (.+)%.")
        if p1 then
            target, spell, player = t1, s1, p1
            foundPattern = "gainsfrom"
        end
    end
    
    if player and spell and SS_Cooldowns_TrackedSpells[spell] then
        local spellData = SS_Cooldowns_TrackedSpells[spell]
        
        if spellData.type == "buff" then
            if foundPattern == "gainsfrom" and target and target ~= "" and player ~= target then
                SS_Cooldowns_AddCooldown(player, spell, target)
            end
        else
            if spellData.multiTarget then
                if foundPattern == "cast" or foundPattern == "begincast" then
                    SS_Cooldowns_AddCooldown(player, spell, target)
                end
            else
                if foundPattern == "hit" or foundPattern == "crit" or foundPattern == "cast" or foundPattern == "begincast" then
                    SS_Cooldowns_AddCooldown(player, spell, target)
                end
            end
        end
    end
end

-- ============================================================================
-- CLEAR ALL COOLDOWNS
-- ============================================================================

function SS_Cooldowns_ClearAll()
    SS_Cooldowns_Tracked = {}
    SS_CooldownsDB = {}
    SS_Cooldowns_UpdateDisplay()
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[Cooldowns] All cooldowns cleared!|r")
end

-- ============================================================================
-- CREATE UPDATE FRAME
-- ============================================================================

function SS_Cooldowns_CreateUpdateFrame()
    if SS_Cooldowns_UpdateFrame then return end
    
    SS_Cooldowns_UpdateFrame = CreateFrame("Frame")
    SS_Cooldowns_UpdateFrame:Show()
    SS_Cooldowns_UpdateFrame.timeSinceLastUpdate = 0
    
    SS_Cooldowns_UpdateFrame:SetScript("OnUpdate", function()
        this.timeSinceLastUpdate = this.timeSinceLastUpdate + arg1
        
        if this.timeSinceLastUpdate >= 0.1 then
            this.timeSinceLastUpdate = 0
            
            if SS_CurrentTab == 3 then
                SS_Cooldowns_UpdateDisplay()
            end
        end
    end)
end

-- ============================================================================
-- SHOW/HIDE TAB 3
-- ============================================================================

function SS_Cooldowns_ShowTab()
    if SS_Tab3_CooldownPanel then 
        SS_Tab3_CooldownPanel:Show()
        SS_Cooldowns_UpdateDisplay()
    end
end

function SS_Cooldowns_HideTab()
    if SS_Tab3_CooldownPanel then 
        SS_Tab3_CooldownPanel:Hide()
    end
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function SS_Cooldowns_Initialize()
    -- Load saved cooldowns
    if SS_CooldownsDB then
        SS_Cooldowns_Tracked = SS_CooldownsDB
    end
    
    -- Create update frame
    SS_Cooldowns_CreateUpdateFrame()
    
    -- Register combat log events
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE")
    eventFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
    
    eventFrame:SetScript("OnEvent", function()
        SS_Cooldowns_ParseCombatLog(arg1)
    end)
end