-- ============================================================================
-- SLACKSPOTTER - RAID LEADER HELPER
-- Real-time raid status monitoring window
-- ============================================================================

-- ============================================================================
-- WORKING MEMORY & SAVEDVARIABLES
-- ============================================================================
SS_RLHelper_Frame = nil
SS_RLHelper_IsOpen = false
SS_RLHelper_UpdateFrame = nil

-- options frame for rl helper
SS_RLHelper_OptionsFrame = nil
SS_RLHelper_OptionsIsOpen = false

-- Display options
SS_RLHelper_DisplayTanks = false
SS_RLHelper_GroupHealers = false
SS_RLHelper_DisplayDPS = false
SS_RLHelper_EnabledCooldowns = {}

-- Persistent settings
SS_RLHelperDB = SS_RLHelperDB or {
    scale = 1.0,
    posX = nil,
    posY = nil,
    displayTanks = false,
    groupHealers = false,
    displayDPS = false,
    cdTrackerEnabled = false,
    enabledCooldowns = {}
}

-- ============================================================================
-- ROLE MAPPINGS (from MappingData.lua concept)
-- ============================================================================
SS_RLHelper_TankSpecs = {
    ["WarriorTank"] = true,
    ["PaladinTank"] = true,
    ["DruidBear"] = true,
    ["ShamanEnhTank"] = true
}

SS_RLHelper_HealerSpecs = {
    ["PaladinHoly"] = true,
    ["ShamanResto"] = true,
    ["DruidTree"] = true,
    ["PriestDisc"] = true,
    ["PriestHoly"] = true
}

-- ============================================================================
-- CREATE MAIN FRAME
-- ============================================================================
function SS_RLHelper_CreateFrame()

if SS_RLHelper_Frame then
    DEFAULT_CHAT_FRAME:AddMessage("Already exists, returning")
end

    if SS_RLHelper_Frame then return end
    
    local frame = CreateFrame("Frame", "SS_RLHelper_Frame", UIParent)
    frame:SetWidth(220)
    frame:SetHeight(100) -- Start small, will auto-adjust
    
    -- Restore position or use default
    if SS_RLHelperDB.posX and SS_RLHelperDB.posY then
    frame:SetPoint(
        SS_RLHelperDB.point or "CENTER",
        UIParent,
        SS_RLHelperDB.relativePoint or "CENTER",
        SS_RLHelperDB.posX,
        SS_RLHelperDB.posY
    )

    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
    
    frame:SetFrameStrata("MEDIUM")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    
    frame:SetScript("OnDragStart", function() 
        this:StartMoving() 
    end)
    
    frame:SetScript("OnDragStop", function() 
        this:StopMovingOrSizing()
        -- Save position
        local point, _, relativePoint, x, y = this:GetPoint()
SS_RLHelperDB.point = point
SS_RLHelperDB.relativePoint = relativePoint
SS_RLHelperDB.posX = x
SS_RLHelperDB.posY = y

    end)
    
    -- Background
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 8, right = 8, top = 8, bottom = 8}
    })
    frame:SetBackdropColor(0, 0, 0, 0.75)
    frame:SetAlpha(0.75)
    
    -- Restore scale
    frame:SetScale(SS_RLHelperDB.scale or 1.0)
    
    -- Close Button
    frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    frame.closeButton:SetScript("OnClick", function()
        SS_RLHelper_Toggle()
    end)
    
    -- Content Frame
    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -10)
    frame.content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
    
    SS_RLHelper_Frame = frame
    frame:Hide()
    
    -- Create update frame
    SS_RLHelper_CreateUpdateFrame()
    
    -- Sync slider with saved scale
    local slider = getglobal("SS_Tab1_RLHelperPanel_ScaleSlider")
    if slider then
        slider:SetValue(SS_RLHelperDB.scale or 1.0)
    end
end

-- ============================================================================
-- CREATE OPTIONS WINDOW
-- ============================================================================
function SS_RLHelper_CreateOptionsFrame()
    if SS_RLHelper_OptionsFrame then return end
    
    local frame = CreateFrame("Frame", "SS_RLHelper_OptionsFrame", UIParent)
    frame:SetWidth(280)
    frame:SetHeight(420)
    
    -- Restore position or default (right of display window)
    if SS_RLHelperDB.optionsPosX and SS_RLHelperDB.optionsPosY then
        frame:SetPoint(
            SS_RLHelperDB.optionsPoint or "CENTER",
            UIParent,
            SS_RLHelperDB.optionsRelativePoint or "CENTER",
            SS_RLHelperDB.optionsPosX,
            SS_RLHelperDB.optionsPosY
        )
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 250, 0)
    end
    
    frame:SetFrameStrata("MEDIUM")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    
    frame:SetScript("OnDragStart", function() 
        this:StartMoving() 
    end)
    
    frame:SetScript("OnDragStop", function() 
        this:StopMovingOrSizing()
        local point, _, relativePoint, x, y = this:GetPoint()
        SS_RLHelperDB.optionsPoint = point
        SS_RLHelperDB.optionsRelativePoint = relativePoint
        SS_RLHelperDB.optionsPosX = x
        SS_RLHelperDB.optionsPosY = y
    end)
    
    -- Background
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 8, right = 8, top = 8, bottom = 8}
    })
    frame:SetBackdropColor(0, 0, 0, 0.75)
    frame:SetAlpha(0.75)
    
    -- Title
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -15)
    frame.title:SetText("|cff00ff00RL Helper Options|r")
    
    -- Close Button
    frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    frame.closeButton:SetScript("OnClick", function()
        SS_RLHelper_ToggleOptions()
    end)
    
    -- Create settings inside
    SS_RLHelper_CreateOptionsContent(frame)
    
    SS_RLHelper_OptionsFrame = frame
    frame:Hide()
end

-- ============================================================================
-- CREATE OPTIONS CONTENT
-- ============================================================================
function SS_RLHelper_CreateOptionsContent(frame)
    local yOffset = -50
    
    -- === DISPLAY OPTIONS ===
    local displayHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    displayHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    displayHeader:SetText("|cffff8000Display Options|r")
    yOffset = yOffset - 25
    
    -- Show Tanks
    local tanksCB = CreateFrame("CheckButton", "SS_RLHelperOptions_DisplayTanksCheckbox", frame, "UICheckButtonTemplate")
    tanksCB:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
    tanksCB:SetChecked(SS_RLHelper_DisplayTanks)
    tanksCB:SetScript("OnClick", function()
        SS_RLHelper_ToggleDisplayTanks()
    end)
    
    local tanksLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    tanksLabel:SetPoint("LEFT", tanksCB, "RIGHT", 5, 0)
    tanksLabel:SetText("Show Tanks")
    yOffset = yOffset - 25
    
    -- Group Healers
    local healCB = CreateFrame("CheckButton", "SS_RLHelperOptions_GroupHealersCheckbox", frame, "UICheckButtonTemplate")
    healCB:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
    healCB:SetChecked(SS_RLHelper_GroupHealers)
    healCB:SetScript("OnClick", function()
        SS_RLHelper_ToggleGroupHealers()
    end)
    
    local healLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    healLabel:SetPoint("LEFT", healCB, "RIGHT", 5, 0)
    healLabel:SetText("Group Healers")
    yOffset = yOffset - 25
    
    -- Show DPS
    local dpsCB = CreateFrame("CheckButton", "SS_RLHelperOptions_DisplayDPSCheckbox", frame, "UICheckButtonTemplate")
    dpsCB:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
    dpsCB:SetChecked(SS_RLHelper_DisplayDPS)
    dpsCB:SetScript("OnClick", function()
        SS_RLHelper_ToggleDisplayDPS()
    end)
    
    local dpsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dpsLabel:SetPoint("LEFT", dpsCB, "RIGHT", 5, 0)
    dpsLabel:SetText("Show DPS")
    yOffset = yOffset - 35
    
    -- === WINDOW OPTIONS ===
    local windowHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    windowHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    windowHeader:SetText("|cffff8000Window Options|r")
    yOffset = yOffset - 25
    
    -- Scale Slider
    local scaleLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    scaleLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
    scaleLabel:SetText("Display Window Size:")
    yOffset = yOffset - 20
    
    local scaleSlider = CreateFrame("Slider", "SS_RLHelperOptions_ScaleSlider", frame)
    scaleSlider:SetWidth(200)
    scaleSlider:SetHeight(15)
    scaleSlider:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, yOffset)
    scaleSlider:SetOrientation("HORIZONTAL")
    scaleSlider:SetMinMaxValues(0.6, 1.4)
    scaleSlider:SetValue(SS_RLHelperDB.scale or 1.0)
    scaleSlider:SetValueStep(0.1)
    
    scaleSlider:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 8,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    
    local thumb = scaleSlider:CreateTexture(nil, "OVERLAY")
    thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    thumb:SetWidth(16)
    thumb:SetHeight(16)
    scaleSlider:SetThumbTexture(thumb)
    
    scaleSlider:SetScript("OnValueChanged", function()
        SS_RLHelper_SetScale(this:GetValue())
    end)
    yOffset = yOffset - 30
    
    -- Lock Checkbox
    local lockCB = CreateFrame("CheckButton", "SS_RLHelperOptions_LockCheckbox", frame, "UICheckButtonTemplate")
    lockCB:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
    lockCB:SetScript("OnClick", function()
        SS_RLHelper_ToggleLock()
    end)
    
    local lockLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lockLabel:SetPoint("LEFT", lockCB, "RIGHT", 5, 0)
    lockLabel:SetText("Lock Display Window")
    yOffset = yOffset - 35
    
    -- === COOLDOWN TRACKING ===
    local cdHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cdHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, yOffset)
    cdHeader:SetText("|cffff8000Cooldown Tracking|r")
    yOffset = yOffset - 25
    
    -- CD Tracker Master
    local cdMasterCB = CreateFrame("CheckButton", "SS_RLHelperOptions_CDTrackerCheckbox", frame, "UICheckButtonTemplate")
    cdMasterCB:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
    cdMasterCB:SetChecked(SS_Cooldowns_Enabled)
    cdMasterCB:SetScript("OnClick", function()
        SS_Cooldowns_Toggle()
        SS_RLHelper_UpdateCDCheckboxStates()
    end)
    
    local cdMasterLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cdMasterLabel:SetPoint("LEFT", cdMasterCB, "RIGHT", 5, 0)
    cdMasterLabel:SetText("Enable CD Tracking")
    yOffset = yOffset - 25
    
    -- Individual CDs (2 columns)
    local cdNames = SS_Cooldowns_GetAllCooldownNames and SS_Cooldowns_GetAllCooldownNames() or {
        "Tranquility", "Rebirth", "Innervate", "Challenging Roar",
        "Spirit Link", "Shield Wall", "Challenging Shout", "Last Stand"
    }
    
    local startY = yOffset
    for i = 1, table.getn(cdNames) do
        local cdName = cdNames[i]
        local col = (i - 1) < 4 and 0 or 1
        local row = (i - 1) - (col * 4)
        
        local xPos = 30 + (col * 120)
        local yPos = startY - (row * 22)
        
        local cb = CreateFrame("CheckButton", "SS_RLHelperOptions_CD_" .. string.gsub(cdName, " ", ""), frame, "UICheckButtonTemplate")
        cb:SetPoint("TOPLEFT", frame, "TOPLEFT", xPos, yPos)
        cb:SetChecked(SS_RLHelper_EnabledCooldowns[cdName] == true)
        
        local capturedName = cdName
        cb:SetScript("OnClick", function()
            SS_RLHelper_ToggleCooldown(capturedName)
        end)
        
        if SS_Cooldowns_Enabled then
            cb:Enable()
            cb:SetAlpha(1.0)
        else
            cb:Disable()
            cb:SetAlpha(0.3)
        end
        
        local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("LEFT", cb, "RIGHT", 5, 0)
        label:SetText(cdName)
    end
end

-- ============================================================================
-- UPDATE FRAME (refreshes every 0.5s when open)
-- ============================================================================
function SS_RLHelper_CreateUpdateFrame()
    if SS_RLHelper_UpdateFrame then return end
    
    local frame = CreateFrame("Frame")
    frame.timeSinceLastUpdate = 0
    frame:SetScript("OnUpdate", function()
        if not SS_RLHelper_IsOpen then return end
        
        this.timeSinceLastUpdate = this.timeSinceLastUpdate + arg1
        if this.timeSinceLastUpdate >= 2 then
            this.timeSinceLastUpdate = 0
            SS_RLHelper_UpdateDisplay()
        end
    end)
    
    SS_RLHelper_UpdateFrame = frame
end

-- ============================================================================
-- TOGGLE WINDOW
-- ============================================================================
function SS_RLHelper_Toggle()
    -- (Re)create if missing or somehow invalid
    if not SS_RLHelper_Frame or not SS_RLHelper_Frame.content then
        SS_RLHelper_Frame = nil
        SS_RLHelper_CreateFrame()
    end

    if SS_RLHelper_IsOpen then
        -- Close
        SS_RLHelper_Frame:Hide()
        SS_RLHelper_IsOpen = false
    else
        -- Open
        SS_RLHelper_Frame:Show()
        SS_RLHelper_IsOpen = true
        
        -- Refresh Tab 1 data (includes raid refresh + spec load)
        if SS_Tab1_RefreshAndCheckAll then
            SS_Tab1_RefreshAndCheckAll()
        end

        -- Update and adjust layout
        SS_RLHelper_UpdateDisplay()
        SS_RLHelper_AdjustHeight()
    end
end

-- ============================================================================
-- TOGGLE OPTIONS WINDOW
-- ============================================================================
function SS_RLHelper_ToggleOptions()
    -- Create if doesn't exist
    if not SS_RLHelper_OptionsFrame then
        SS_RLHelper_CreateOptionsFrame()
    end
    
    if SS_RLHelper_OptionsIsOpen then
        SS_RLHelper_OptionsFrame:Hide()
        SS_RLHelper_OptionsIsOpen = false
    else
        SS_RLHelper_OptionsFrame:Show()
        SS_RLHelper_OptionsIsOpen = true
    end
end


-- ============================================================================
-- LOCK/UNLOCK (click-through)
-- ============================================================================
function SS_RLHelper_ToggleLock()
    if not SS_RLHelper_Frame then return end
    
    local optionsCB = getglobal("SS_RLHelperOptions_LockCheckbox")
    
    local isLocked = false
    if optionsCB and optionsCB:GetChecked() then isLocked = true end
    
    if isLocked then
        SS_RLHelper_Frame:EnableMouse(false)
        SS_RLHelper_Frame:SetMovable(false)
    else
        SS_RLHelper_Frame:EnableMouse(true)
        SS_RLHelper_Frame:SetMovable(true)
    end
end

-- ============================================================================
-- SET SCALE
-- ============================================================================
function SS_RLHelper_SetScale(scale)
    if not SS_RLHelper_Frame then return end
    
    SS_RLHelper_Frame:SetScale(scale)
    SS_RLHelperDB.scale = scale
end

-- ============================================================================
-- GET RAID DATA
-- ============================================================================
function SS_RLHelper_GetRaidData()
    local tanks = {}
    local healers = {}
    local dps = {alive = 0, total = 0, mana = 0, manaUsers = 0}
    local cooldowns = {}
    
    local numRaid = GetNumRaidMembers()
    local numParty = GetNumPartyMembers()
    local totalMembers = 1 -- Solo by default
    local isRaid = false
    
    if numRaid > 0 then
        totalMembers = numRaid
        isRaid = true
    elseif numParty > 0 then
        totalMembers = numParty + 1 -- Party + self
    end
    
    for i = 1, totalMembers do
        local name, class, unitID, spec
        
        if isRaid then
            name, _, _, _, class = GetRaidRosterInfo(i)
            class = SS_ConfigSpecs_ProperCase(class)
            unitID = "raid" .. i
        elseif numParty > 0 then
            if i == 1 then
                name = UnitName("player")
                _, class = UnitClass("player")
                class = SS_ConfigSpecs_ProperCase(class)
                unitID = "player"
            else
                name = UnitName("party" .. (i-1))
                _, class = UnitClass("party" .. (i-1))
                class = SS_ConfigSpecs_ProperCase(class)
                unitID = "party" .. (i-1)
            end
        else
            -- Solo
            name = UnitName("player")
            _, class = UnitClass("player")
            class = SS_ConfigSpecs_ProperCase(class)
            unitID = "player"
        end
        
        if name and UnitIsConnected(unitID) then
            spec = SS_ConfigSpecs_SelectedSpecs and SS_ConfigSpecs_SelectedSpecs[name]
            if spec then
                spec = SS_Check_SpecIndexToName(name, spec)
            end
            
            local hp = UnitHealth(unitID)
            local hpMax = UnitHealthMax(unitID)
            local hpPct = (hpMax > 0) and math.floor((hp / hpMax) * 100) or 0
            local mana = UnitMana(unitID)
            local manaMax = UnitManaMax(unitID)
            local manaPct = (manaMax > 0) and math.floor((mana / manaMax) * 100) or 0
            local isDead = UnitIsDeadOrGhost(unitID)
            local properClass = SS_ConfigSpecs_ProperCase(class)
            
            -- Categorize by spec
            if spec and SS_RLHelper_TankSpecs[spec] then
                table.insert(tanks, {
                    name = name,
                    hp = hpPct,
                    mana = manaPct,
                    class = properClass,
                    dead = isDead
                })
            elseif spec and SS_RLHelper_HealerSpecs[spec] then
                table.insert(healers, {
                    name = name,
                    hp = hpPct,
                    mana = manaPct,
                    class = properClass,
                    dead = isDead
                })
            else
                -- DPS
                dps.total = dps.total + 1
                if not isDead then
                    dps.alive = dps.alive + 1
                    -- Only count mana users (manaMax > 0 AND class actually uses mana)
                    if manaMax > 0 and properClass ~= "Warrior" and properClass ~= "Rogue" then
                        dps.mana = dps.mana + manaPct
                        dps.manaUsers = dps.manaUsers + 1
                    end
                end
            end
            
            -- Collect cooldowns
            local specCDs = SS_Cooldowns_GetSpecCooldowns and SS_Cooldowns_GetSpecCooldowns(spec) or {}
            if table.getn(specCDs) > 0 then
                for j = 1, table.getn(specCDs) do
                    local cdName = specCDs[j]
                    local cdKey = name .. ":" .. cdName
                    local cdData = SS_Cooldowns_Tracked and SS_Cooldowns_Tracked[cdKey]
                    local remaining = cdData and (cdData.endTime - GetTime()) or -1
                    
                    table.insert(cooldowns, {
                        player = name,
                        spell = cdName,
                        class = properClass,
                        remaining = remaining
                    })
                end
            end
        end
    end
    
    return tanks, healers, dps, cooldowns
end

-- ============================================================================
-- UPDATE DISPLAY
-- ============================================================================
function SS_RLHelper_UpdateDisplay()
    if not SS_RLHelper_Frame or not SS_RLHelper_Frame.content then return end
    
    local content = SS_RLHelper_Frame.content
    if content.children then
        for i = 1, table.getn(content.children) do
            content.children[i]:Hide()
        end
    end
    content.children = {}
    
    local tanks, healers, dps, cooldowns = SS_RLHelper_GetRaidData()
    local yOffset = -5
    
    -- Helper function for Mana color
    local function GetManaColor(pct)
        if pct >= 70 then return "|cff00ff00"
        elseif pct >= 35 then return "|cffffff00"
        elseif pct >= 11 then return "|cffff8000"
        else return "|cffff0000" end
    end
    
    -- TANKS
    if SS_RLHelper_DisplayTanks then
        local tanksHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tanksHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
        tanksHeader:SetText("|cffff8000TANKS|r")
        table.insert(content.children, tanksHeader)
        yOffset = yOffset - 15
        
        for i = 1, table.getn(tanks) do
            local tank = tanks[i]
            local color = SS_ClassColors[string.upper(tank.class)] or {r = 1, g = 1, b = 1}
            
            -- Name column
            local nameLine = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            nameLine:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
            nameLine:SetWidth(100)
            nameLine:SetJustifyH("LEFT")
            nameLine:SetTextColor(color.r, color.g, color.b)
            nameLine:SetText(tank.name)
            table.insert(content.children, nameLine)
            
            -- Mana column
            local manaLine = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            manaLine:SetPoint("LEFT", nameLine, "RIGHT", 5, 0)
            manaLine:SetJustifyH("LEFT")
            
            if tank.dead then
                manaLine:SetTextColor(1, 0, 0)
                manaLine:SetText("DEAD")
            else
                local manaColor = GetManaColor(tank.mana)
                local manaPadded = string.format("%3d", tank.mana)
                manaLine:SetText(manaColor .. manaPadded .. "%|r")
            end
            
            table.insert(content.children, manaLine)
            yOffset = yOffset - 12
        end
        
        yOffset = yOffset - 5
    end
    
    -- HEALERS
    -- Calculate healer stats FIRST
    local aliveCount = 0
    local totalMana = 0
    local totalHealers = table.getn(healers)

    for i = 1, totalHealers do
        if not healers[i].dead then
            aliveCount = aliveCount + 1
            totalMana = totalMana + healers[i].mana
        end
    end

    local avgMana = (aliveCount > 0) and math.floor(totalMana / aliveCount) or 0
    local manaColor = GetManaColor(avgMana)

    if SS_RLHelper_GroupHealers then
        -- Grouped display
        local healersHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        healersHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
        healersHeader:SetText("|cff00ff00HEALERS|r |cffffffff(" .. aliveCount .. "/" .. totalHealers .. ") " .. manaColor .. tostring(avgMana) .. "%|r")
        table.insert(content.children, healersHeader)
        yOffset = yOffset - 15
    else
        -- Individual display
        local healersHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        healersHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
        healersHeader:SetText("|cff00ff00HEALERS|r")
        table.insert(content.children, healersHeader)
        yOffset = yOffset - 15
        
        for i = 1, table.getn(healers) do
            local healer = healers[i]
            local color = SS_ClassColors[string.upper(healer.class)] or {r = 1, g = 1, b = 1}
            
            -- Name column
            local nameLine = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            nameLine:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
            nameLine:SetWidth(100)
            nameLine:SetJustifyH("LEFT")
            nameLine:SetTextColor(color.r, color.g, color.b)
            nameLine:SetText(healer.name)
            table.insert(content.children, nameLine)
            
            -- Mana column
            local manaLine = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            manaLine:SetPoint("LEFT", nameLine, "RIGHT", 5, 0)
            manaLine:SetJustifyH("LEFT")
            
            if healer.dead then
                manaLine:SetTextColor(1, 0, 0)
                manaLine:SetText("DEAD")
            else
                local healerManaColor = GetManaColor(healer.mana)
                local manaPadded = string.format("%3d", healer.mana)
                manaLine:SetText(healerManaColor .. manaPadded .. "%|r")
            end
            
            table.insert(content.children, manaLine)
            yOffset = yOffset - 12
        end
        
        yOffset = yOffset - 5
    end
    
    -- DPS
if SS_RLHelper_DisplayDPS then
    local dpsAvg = (dps.manaUsers > 0) and math.floor(dps.mana / dps.manaUsers) or 0
    local manaColor = GetManaColor(dpsAvg)
    
    local dpsHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dpsHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    dpsHeader:SetText("|cffff0000DPS|r |cffffffff(" .. dps.alive .. "/" .. dps.total .. ") " .. manaColor .. tostring(dpsAvg) .. "%|r")
    table.insert(content.children, dpsHeader)
    yOffset = yOffset - 15
end
    
    -- COOLDOWNS (only show if tracker is enabled AND individual CDs are selected)
    local hasCooldowns = false
    if SS_Cooldowns_Enabled then
        for i = 1, table.getn(cooldowns) do
            if SS_RLHelper_EnabledCooldowns[cooldowns[i].spell] then
                hasCooldowns = true
                break
            end
        end
    end
    
    if hasCooldowns then
    local cdHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cdHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    cdHeader:SetText("|cff00ffffCD's|r")
    table.insert(content.children, cdHeader)
    yOffset = yOffset - 15
    
    -- Group cooldowns by spell
    local cdBySpell = {}
    for i = 1, table.getn(cooldowns) do
        local cd = cooldowns[i]
        if SS_RLHelper_EnabledCooldowns[cd.spell] then
            if not cdBySpell[cd.spell] then
                cdBySpell[cd.spell] = {}
            end
            table.insert(cdBySpell[cd.spell], cd)
        end
    end
    
    -- Display grouped by spell
    for spellName, cdList in pairs(cdBySpell) do
        -- Spell header
        local spellLine = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        spellLine:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)
        spellLine:SetText("|cffffd700" .. spellName .. ":|r")
        spellLine:SetTextColor(1.0, 0.82, 0.0)
        table.insert(content.children, spellLine)
        yOffset = yOffset - 12
        
        -- Players with this cooldown
        for i = 1, table.getn(cdList) do
            local cd = cdList[i]
            local color = SS_ClassColors[string.upper(cd.class)] or {r = 1, g = 1, b = 1}
            
            local line = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            line:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
            
            local displayText = cd.player
            
            if SS_Cooldowns_Enabled and cd.remaining > 0 then
                line:SetTextColor(0.5, 0.5, 0.5)
                displayText = displayText .. " (" .. SS_Cooldowns_FormatTime(cd.remaining) .. ")"
            else
                line:SetTextColor(color.r, color.g, color.b)
            end
            
            line:SetText(displayText)
            table.insert(content.children, line)
            yOffset = yOffset - 12
        end
    end
end
	-- Auto-adjust height after rendering
    SS_RLHelper_AdjustHeight()
end

-- ============================================================================
-- AUTO-ADJUST HEIGHT
-- ============================================================================
function SS_RLHelper_AdjustHeight()
    if not SS_RLHelper_Frame or not SS_RLHelper_Frame.content then return end
    
    -- Count VISUAL rows instead of total FontStrings
    local lineCount = 0
    
    if SS_RLHelper_DisplayTanks then
        lineCount = lineCount + 1  -- "TANKS" header
        local tanks, _, _, _ = SS_RLHelper_GetRaidData()
        lineCount = lineCount + table.getn(tanks)
    end
    
    if SS_RLHelper_GroupHealers then
        lineCount = lineCount + 1  -- Grouped healer line
    else
        lineCount = lineCount + 1  -- "HEALERS" header
        local _, healers, _, _ = SS_RLHelper_GetRaidData()
        lineCount = lineCount + table.getn(healers)
    end
    
    if SS_RLHelper_DisplayDPS then
        lineCount = lineCount + 1  -- DPS summary line
    end
    
    -- Count enabled cooldowns
    if SS_Cooldowns_Enabled then
        local _, _, _, cooldowns = SS_RLHelper_GetRaidData()
        
        -- Group by spell
        local cdBySpell = {}
        for i = 1, table.getn(cooldowns) do
            local cd = cooldowns[i]
            if SS_RLHelper_EnabledCooldowns[cd.spell] then
                if not cdBySpell[cd.spell] then
                    cdBySpell[cd.spell] = {}
                end
                table.insert(cdBySpell[cd.spell], cd)
            end
        end
        
        -- Count CD lines
        local hasCooldowns = false
        for spellName, cdList in pairs(cdBySpell) do
            hasCooldowns = true
            lineCount = lineCount + 1  -- Spell header
            lineCount = lineCount + table.getn(cdList)  -- Players
        end
        
        if hasCooldowns then
            lineCount = lineCount + 1  -- "CD's" header
        end
    end
    
    -- Calculate height (12px per line + 60px for padding/close button)
    local newHeight = math.max(100, lineCount * 12 + 60)

-- Line counter for debugging   
--    DEFAULT_CHAT_FRAME:AddMessage("AdjustHeight: " .. lineCount .. " lines, height " .. newHeight)
    
    SS_RLHelper_Frame:SetHeight(newHeight)
end

-- ============================================================================
-- DISPLAY TOGGLES
-- ============================================================================
function SS_RLHelper_ToggleDisplayTanks()
    SS_RLHelper_DisplayTanks = not SS_RLHelper_DisplayTanks
    SS_RLHelperDB.displayTanks = SS_RLHelper_DisplayTanks
    
    local optionsCB = getglobal("SS_RLHelperOptions_DisplayTanksCheckbox")
    if optionsCB then optionsCB:SetChecked(SS_RLHelper_DisplayTanks) end
    
    SS_RLHelper_UpdateDisplay()
end

function SS_RLHelper_ToggleGroupHealers()
    SS_RLHelper_GroupHealers = not SS_RLHelper_GroupHealers
    SS_RLHelperDB.groupHealers = SS_RLHelper_GroupHealers
    
    local optionsCB = getglobal("SS_RLHelperOptions_GroupHealersCheckbox")
    if optionsCB then optionsCB:SetChecked(SS_RLHelper_GroupHealers) end
    
    SS_RLHelper_UpdateDisplay()
end

function SS_RLHelper_ToggleDisplayDPS()
    SS_RLHelper_DisplayDPS = not SS_RLHelper_DisplayDPS
    SS_RLHelperDB.displayDPS = SS_RLHelper_DisplayDPS
    
    local optionsCB = getglobal("SS_RLHelperOptions_DisplayDPSCheckbox")
    if optionsCB then optionsCB:SetChecked(SS_RLHelper_DisplayDPS) end
    
    SS_RLHelper_UpdateDisplay()
end

function SS_RLHelper_ToggleCooldown(cdName)
    if not SS_Cooldowns_Enabled then return end
    
    SS_RLHelper_EnabledCooldowns[cdName] = not SS_RLHelper_EnabledCooldowns[cdName]
    SS_RLHelperDB.enabledCooldowns[cdName] = SS_RLHelper_EnabledCooldowns[cdName]
    
    local optionsCB = getglobal("SS_RLHelperOptions_CD_" .. string.gsub(cdName, " ", ""))
    if optionsCB then optionsCB:SetChecked(SS_RLHelper_EnabledCooldowns[cdName]) end
    
    SS_RLHelper_UpdateDisplay()
end

function SS_RLHelper_UpdateCDCheckboxStates()
    local cdList = {}
    for cdName, _ in pairs(SS_Cooldowns_TrackedSpells) do
        table.insert(cdList, cdName)
    end
    
    for i = 1, table.getn(cdList) do
        local cdName = cdList[i]
        
        -- Update Options window checkboxes
        local optionsCB = getglobal("SS_RLHelperOptions_CD_" .. string.gsub(cdName, " ", ""))
        if optionsCB then
            if SS_Cooldowns_Enabled then
                optionsCB:Enable()
                optionsCB:SetAlpha(1.0)
            else
                optionsCB:Disable()
                optionsCB:SetAlpha(0.3)
            end
        end
    end
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
    function SS_RLHelper_Initialize()
    
    -- THEN load saved settings
    if SS_RLHelperDB then
        SS_RLHelper_DisplayTanks = SS_RLHelperDB.displayTanks or false
        SS_RLHelper_GroupHealers = SS_RLHelperDB.groupHealers or false
        SS_RLHelper_DisplayDPS = SS_RLHelperDB.displayDPS or false
        SS_RLHelper_EnabledCooldowns = SS_RLHelperDB.enabledCooldowns or {}
    end
end