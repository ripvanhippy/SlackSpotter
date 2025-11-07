-- ============================================================================
-- SLACKSPOTTER - TACTICS MODULE (Tab 4)
-- Boss strategy posting system
-- ============================================================================

-- ============================================================================
-- WORKING MEMORY
-- ============================================================================
SS_Tactics_SelectedBoss = nil
SS_Tactics_SelectedRole = nil
SS_Tactics_CurrentRaid = "Kara40"  -- Default, synced from Tab 6
SS_Tactics_ButtonsCreated = false

-- ============================================================================
-- BOSS DATA - Kill order per raid
-- ============================================================================
SS_Tactics_BossOrder = {
    ["MC"] = {"Incindis", "Lucifron", "Magmadar", "Basalthar & Smoldaris", "Sorc-Thane Thaurissan", "Garr", "Shazzrah", "Baron Geddon", "Golemagg", "Sulfuron Harbinger", "Majordomo Executus", "Ragnaros"},
    ["BWL"] = {"Razorgore", "Vaelastrasz", "Broodlord Lashlayer", "Firemaw", "Ebonroc", "Flamegor", "Chromaggus", "Nefarian"},
    ["AQ40"] = {"The Prophet Skeram", "Silithid Royalty", "Battleguard Sartura", "Fankriss the Unyielding", "Viscidus", "Princess Huhuran", "Twin Emperors", "Ouro", "C'Thun"},
    ["Naxx"] = {"Anub'Rekhan", "Grand Widow Faerlina", "Maexxna", "Noth the Plaguebringer", "Heigan the Unclean", "Loatheb", "Instructor Razuvious", "Gothik the Harvester", "The Four Horsemen", "Patchwerk", "Grobbulus", "Gluth", "Thaddius", "Sapphiron", "Kel'Thuzad"},
    ["Kara40"] = {"Keeper Gnarlmoon", "Ley-Watcher Incantagos", "Anomalus", "Echo of Medivh", "Chess King", "Sanv Tas'dal", "Kruul", "Rupturan", "Mephistroth"},
    ["Kara10"] = {"Master Blacksmith Rolfen", "Lord Blackwald II", "Clawlord Howlfang", "Grizikil", "Brood Queen Araxxna", "Moroes"},
    ["ES"] = {"Erennius", "Solnius the Awakener", "Solnius Hardmode"},
    ["AQ20"] = {"Kurinnaxx", "General Rajaxx", "Moam", "Buru the Gorger", "Ayamiss the Hunter", "Ossirian the Unscarred"},
    ["ZG"] = {"High Priestess Jeklik", "High Priest Venoxis", "High Priestess Mar'li", "Bloodlord Mandokir", "Edge of Madness", "High Priest Thekal", "High Priestess Arlokk", "Jin'do the Hexxer", "Hakkar the Soulflayer"},
    ["Ony"] = {"Onyxia"}
}

-- Trash/Special encounters per raid
SS_Tactics_TrashEncounters = {
    ["MC"] = {"Placeholder Trash 1", "Placeholder Trash 2"},
    ["BWL"] = {"Placeholder Trash 1"},
    ["AQ40"] = {"Meteor Mobs", "Anubisath Defenders", "Placeholder Trash 3"},
    ["Naxx"] = {"Placeholder Trash 1"},
    ["Kara40"] = {"Placeholder Trash 1"},
    ["Kara10"] = {"Placeholder Trash 1"},
    ["ES"] = {},
    ["AQ20"] = {"Placeholder Trash 1"},
    ["ZG"] = {"Placeholder Trash 1"},
    ["Ony"] = {}
}

SS_Tactics_RoleOrder = {"Tanks", "Healer", "Special 1", "Phys DPS", "Caster DPS", "Special 2"}

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function SS_Tactics_Initialize()
--    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Tactics module loaded!|r")
end

-- ============================================================================
-- SYNC RAID SELECTION (called from Tab 6 when raid changes)
-- ============================================================================
function SS_Tactics_SyncRaidSelection(raidName)
    SS_Tactics_CurrentRaid = raidName
    
    -- Update instance label
    SS_Tactics_UpdateInstanceLabel()
    
    -- Refresh boss buttons for new raid
    SS_Tactics_UpdateBossButtons()
    
    -- Refresh trash buttons for new raid
    SS_Tactics_UpdateTrashButtons()
    
    -- Auto-select first boss of new raid
    local bossList = SS_Tactics_BossOrder[raidName]
    if bossList and table.getn(bossList) > 0 then
        SS_Tactics_SelectedBoss = bossList[1]
    else
        SS_Tactics_SelectedBoss = nil
    end
    
    -- Auto-select Tanks role
    SS_Tactics_SelectedRole = "Tanks"
    
    -- Update button highlights
    SS_Tactics_UpdateBossButtons()
    SS_Tactics_UpdateTrashButtons()
    SS_Tactics_UpdateRoleButtons()
    
    -- Load strategy
    if SS_Tactics_SelectedBoss and SS_Tactics_SelectedRole then
        SS_Tactics_LoadStrategy()
    end
end

-- ============================================================================
-- TAB DISPLAY FUNCTIONS
-- ============================================================================
function SS_Tactics_ShowTab()
    -- Show all panels
    if SS_Tab4_BossPanel then SS_Tab4_BossPanel:Show() end
    if SS_Tab4_StrategyPanel then SS_Tab4_StrategyPanel:Show() end
    if SS_Tab4_RolePanel then SS_Tab4_RolePanel:Show() end
    if SS_Tab4_ImagesPanel then SS_Tab4_ImagesPanel:Show() end
    if SS_Tab4_TrashPanel then SS_Tab4_TrashPanel:Show() end
    if SS_Tab4_PortPanel then SS_Tab4_PortPanel:Show() end
    
    -- Create role buttons if not already created
    if not SS_Tactics_ButtonsCreated then
        SS_Tactics_CreateRoleButtons()
        SS_Tactics_ButtonsCreated = true
    end
    
    -- Update buttons and labels
    SS_Tactics_UpdateInstanceLabel()
    SS_Tactics_UpdateBossButtons()
    SS_Tactics_UpdateTrashButtons()
    SS_Tactics_UpdateRoleButtons()
    
    -- Load strategy if boss and role are selected
    if SS_Tactics_SelectedBoss and SS_Tactics_SelectedRole then
        SS_Tactics_LoadStrategy()
    end
end

function SS_Tactics_HideTab()
    -- Hide all panels
    if SS_Tab4_BossPanel then SS_Tab4_BossPanel:Hide() end
    if SS_Tab4_StrategyPanel then SS_Tab4_StrategyPanel:Hide() end
    if SS_Tab4_RolePanel then SS_Tab4_RolePanel:Hide() end
    if SS_Tab4_ImagesPanel then SS_Tab4_ImagesPanel:Hide() end
	if SS_Tab4_TrashPanel then SS_Tab4_TrashPanel:Hide() end
	if SS_Tab4_PortPanel then SS_Tab4_PortPanel:Hide() end
end

-- ============================================================================
-- BOSS BUTTONS (dynamically created based on current raid)
-- ============================================================================
function SS_Tactics_UpdateBossButtons()
    -- Clear existing boss buttons
    for i = 1, 20 do
        local btn = getglobal("SS_Tab4_BossButton"..i)
        if btn then btn:Hide() end
    end
    
    local bossList = SS_Tactics_BossOrder[SS_Tactics_CurrentRaid]
    if not bossList then return end
    
    local parent = getglobal("SS_Tab4_BossPanel")
    if not parent then return end
    
    for i = 1, table.getn(bossList) do
        local bossName = bossList[i]
        local btnName = "SS_Tab4_BossButton"..i
        local btn = getglobal(btnName)
        
        if not btn then
            btn = CreateFrame("Button", btnName, parent, "UIPanelButtonTemplate")
            btn:SetHeight(25)
        end
        
        -- Calculate button width and position (fit 5 per row)
        local btnWidth = 145
        local row = math.floor((i-1) / 5)
        local col = (i-1) - (row * 5)
        
        btn:SetWidth(btnWidth)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 15 + col*(btnWidth-3), -35 - row*25)
        btn:SetText(bossName)
        
        -- Highlight if selected
        if bossName == SS_Tactics_SelectedBoss then
            btn:LockHighlight()
        else
            btn:UnlockHighlight()
        end
        
        local capturedBoss = bossName
        btn:SetScript("OnClick", function() SS_Tactics_SelectBoss(capturedBoss) end)
        btn:Show()
    end
end

function SS_Tactics_UpdateInstanceLabel()
    local label = getglobal("SS_Tab4_CurrentInstanceLabel")
    if label then
        label:SetText("Instance: " .. SS_Tactics_CurrentRaid)
    end
end

-- ============================================================================
-- TRASH BUTTONS (dynamically created based on current raid)
-- ============================================================================
function SS_Tactics_UpdateTrashButtons()
    -- Clear existing trash buttons
    for i = 1, 10 do
        local btn = getglobal("SS_Tab4_TrashButton"..i)
        if btn then btn:Hide() end
    end
    
    local trashList = SS_Tactics_TrashEncounters[SS_Tactics_CurrentRaid]
    if not trashList or table.getn(trashList) == 0 then return end
    
    local parent = getglobal("SS_Tab4_TrashPanel")
    if not parent then return end
    
    for i = 1, table.getn(trashList) do
        local trashName = trashList[i]
        local btnName = "SS_Tab4_TrashButton"..i
        local btn = getglobal(btnName)
        
        if not btn then
            btn = CreateFrame("Button", btnName, parent, "UIPanelButtonTemplate")
            btn:SetHeight(25)
        end
        
        -- Calculate button width and position (fit 5 per row)
        local btnWidth = 145
        local row = math.floor((i-1) / 5)
        local col = (i-1) - (row * 5)
        
        btn:SetWidth(btnWidth)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 15 + col*(btnWidth-3), -35 - row*25)
        btn:SetText(trashName)
        
        -- Highlight if selected
        if trashName == SS_Tactics_SelectedBoss then
            btn:LockHighlight()
        else
            btn:UnlockHighlight()
        end
        
        local capturedTrash = trashName
        btn:SetScript("OnClick", function() SS_Tactics_SelectBoss(capturedTrash) end)
        btn:Show()
    end
end

-- ============================================================================
-- ROLE BUTTONS
-- ============================================================================
function SS_Tactics_CreateRoleButtons()
    local parent = getglobal("SS_Tab4_RolePanel")
    if not parent then return end
    
    for i = 1, table.getn(SS_Tactics_RoleOrder) do
        local role = SS_Tactics_RoleOrder[i]
        local btn = CreateFrame("Button", "SS_Tab4_RoleButton_"..i, parent, "UIPanelButtonTemplate")
        btn:SetWidth(80)
        btn:SetHeight(25)
        
        -- 3 per row
        local row = math.floor((i-1) / 3)
        local col = (i-1) - (row * 3)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 15 + col*80, -35 - row*30)
        btn:SetText(role)
        
        local capturedRole = role
        btn:SetScript("OnClick", function() SS_Tactics_SelectRole(capturedRole) end)
    end
end

function SS_Tactics_UpdateRoleButtons()
    for i = 1, table.getn(SS_Tactics_RoleOrder) do
        local btn = getglobal("SS_Tab4_RoleButton_"..i)
        if btn then
            if SS_Tactics_RoleOrder[i] == SS_Tactics_SelectedRole then
                btn:LockHighlight()
            else
                btn:UnlockHighlight()
            end
        end
    end
end

-- ============================================================================
-- BOSS SELECTION
-- ============================================================================
function SS_Tactics_SelectBoss(bossName)
    SS_Tactics_SelectedBoss = bossName
    
    -- Update ALL button highlights (boss + trash)
    SS_Tactics_UpdateBossButtons()
    SS_Tactics_UpdateTrashButtons()
    
    -- If a role is already selected, load strategy
    if SS_Tactics_SelectedRole then
        SS_Tactics_LoadStrategy()
    else
        -- Clear text box, waiting for role selection
        local editBox = getglobal("SS_Tab4_StrategyEditBox")
        if editBox then
            editBox:SetText("Select a role to view strategy...")
            editBox:SetTextColor(0.7, 0.7, 0.7)
        end
    end
end

-- ============================================================================
-- ROLE SELECTION
-- ============================================================================
function SS_Tactics_SelectRole(roleName)
    SS_Tactics_SelectedRole = roleName
    
    -- Update button highlights
    SS_Tactics_UpdateRoleButtons()
    
    -- Load strategy if boss is selected
    if SS_Tactics_SelectedBoss then
        SS_Tactics_LoadStrategy()
    else
        -- Clear text box, waiting for boss selection
        local editBox = getglobal("SS_Tab4_StrategyEditBox")
        if editBox then
            editBox:SetText("Select a boss to view strategy...")
            editBox:SetTextColor(0.7, 0.7, 0.7)
        end
    end
end

-- ============================================================================
-- STRATEGY LOADING
-- ============================================================================
function SS_Tactics_LoadStrategy()
    local editBox = getglobal("SS_Tab4_StrategyEditBox")
    if not editBox then return end
    
    -- Get strategy text from database
    local strategyText = SS_Tactics_GetStrategy(SS_Tactics_CurrentRaid, SS_Tactics_SelectedBoss, SS_Tactics_SelectedRole)
    
    if strategyText then
        editBox:SetText(strategyText)
        editBox:SetTextColor(1, 1, 1)  -- White text
    else
        editBox:SetText("No strategy found for " .. SS_Tactics_SelectedBoss .. " - " .. SS_Tactics_SelectedRole)
        editBox:SetTextColor(1, 0.5, 0.5)  -- Light red
    end
end

function SS_Tactics_GetStrategy(raidName, bossName, roleName)
    if not SS_TacticsDB then return nil end
    if not SS_TacticsDB[raidName] then return nil end
    if not SS_TacticsDB[raidName][bossName] then return nil end
    
    return SS_TacticsDB[raidName][bossName][roleName]
end

-- ============================================================================
-- PORT TO RAID
-- ============================================================================
function SS_Tactics_PortToRaid()
    local editBox = getglobal("SS_Tab4_StrategyEditBox")
    if not editBox then return end
    
    local text = editBox:GetText()
    if not text or text == "" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000No strategy text to post!|r")
        return
    end
    
    -- Check if boss/role selected
    if not SS_Tactics_SelectedBoss or not SS_Tactics_SelectedRole then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Select a boss and role first!|r")
        return
    end
    
    -- Build header
    local header = "[" .. SS_Tactics_SelectedBoss .. " - " .. SS_Tactics_SelectedRole .. "]"
    
    -- Split text into 255-char chunks (WoW chat limit)
    local messages = SS_Tactics_SplitMessage(text, 230)  -- Leave room for header on first message
    
    -- Check debug mode
    if SS_DebugMode then
        -- Post to chat window instead of raid
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000[TACTICS - DEBUG MODE]|r")
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00" .. header .. "|r")
        for i = 1, table.getn(messages) do
            DEFAULT_CHAT_FRAME:AddMessage("|cffffffff" .. messages[i] .. "|r")
        end
    else
        -- Post to raid chat
        if GetNumRaidMembers() > 0 then
            SendChatMessage(header, "RAID")
            for i = 1, table.getn(messages) do
                SendChatMessage(messages[i], "RAID")
            end
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Tactics posted to raid!|r")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000You are not in a raid!|r")
        end
    end
end

-- ============================================================================
-- MESSAGE SPLITTING (255 char limit)
-- ============================================================================
function SS_Tactics_SplitMessage(text, maxLength)
    local messages = {}
    local currentMessage = ""
    
    -- Split by spaces to avoid cutting words
    local words = {}
    for word in string.gfind(text, "[^%s]+") do
        table.insert(words, word)
    end
    
    for i = 1, table.getn(words) do
        local word = words[i]
        
        if string.len(currentMessage) + string.len(word) + 1 <= maxLength then
            if currentMessage == "" then
                currentMessage = word
            else
                currentMessage = currentMessage .. " " .. word
            end
        else
            -- Current message full, push it and start new one
            table.insert(messages, currentMessage)
            currentMessage = word
        end
    end
    
    -- Push remaining message
    if currentMessage ~= "" then
        table.insert(messages, currentMessage)
    end
    
    return messages
end