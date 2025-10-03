-- ============================================================================
-- SLACKSPOTTER - SHOUTOUTS MODULE (Tab 2)
-- Colored chat message system (formerly ColorSend)
-- ============================================================================

-- Module namespace
SS_Shoutouts = {}
local SS_S = SS_Shoutouts

-- Initialize SavedVariables safely
SS_ShoutoutsDB = SS_ShoutoutsDB or { frame = { x = nil, y = nil } }

-- Localization
local L = {
    ["UI_TITLE"] = "Shoutouts",
    ["SEND"] = "Send",
}

-- Colors (as array for proper iteration in Lua 5.0)
SS_S.colors = {
    { name = "red", hex = "FF0000" },
    { name = "green", hex = "00FF00" },
    { name = "blue", hex = "0000FF" },
    { name = "yellow", hex = "FFFF00" },
    { name = "cyan", hex = "00FFFF" },
    { name = "magenta", hex = "FF00FF" },
    { name = "gray", hex = "808080" },
    { name = "orange", hex = "FFA500" },
}

-- Current selected color
SS_S.selectedColor = "red"

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Get hex code by color name
local function SS_Shoutouts_GetColorHex(colorName)
    for i = 1, table.getn(SS_S.colors) do
        if SS_S.colors[i].name == colorName then
            return SS_S.colors[i].hex
        end
    end
    return nil
end

-- Trim whitespace
local function SS_Shoutouts_Trim(s)
    if not s then return "" end
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

-- Parse color tags [color]...[/]
local function SS_Shoutouts_ParseTags(msg)
    if not msg then return "" end
    msg = string.gsub(msg, "%[#([0-9A-Fa-f]+)%]", "|cff%1")
    for i = 1, table.getn(SS_S.colors) do
        local name = SS_S.colors[i].name
        local hex = SS_S.colors[i].hex
        msg = string.gsub(msg, "%["..name.."%]", "|cff"..hex)
    end
    msg = string.gsub(msg, "%[%/%]", "|r")
    return msg
end

-- ============================================================================
-- SEND FUNCTION
-- ============================================================================

function SS_Shoutouts_Send(channel, target, color, msg)
    if not msg or msg == "" then return end
    
    local hex = SS_Shoutouts_GetColorHex(color)
    if not hex and color and string.len(color) == 6 then 
        hex = color 
    end
    local finalMsg = hex and ("|cff"..hex..msg.."|r") or msg
    
    -- Determine if we should whisper only
    local whisperOnly = (not channel or channel == "") and target and target ~= ""
    
    if whisperOnly then
        SendChatMessage(finalMsg, "WHISPER", nil, target)
        return
    end
    
    -- Send to the specified channel
    if channel == "s" then 
        SendChatMessage(finalMsg, "SAY")
    elseif channel == "p" then 
        SendChatMessage(finalMsg, "PARTY")
    elseif channel == "r" then 
        SendChatMessage(finalMsg, "RAID")
    elseif channel == "g" then 
        SendChatMessage(finalMsg, "GUILD")
    elseif channel == "o" then 
        SendChatMessage(finalMsg, "OFFICER")
    elseif channel == "w" and target and target ~= "" then 
        SendChatMessage(finalMsg, "WHISPER", nil, target)
    elseif tonumber(channel) then 
        SendChatMessage(finalMsg, "CHANNEL", nil, tonumber(channel))
    else 
        SendChatMessage(finalMsg, "SAY") 
    end
end

-- ============================================================================
-- UI CREATION
-- ============================================================================

function SS_Shoutouts_CreateUI()
    -- Check if already exists
    local existingFrame = getglobal("SS_Tab2_ShoutoutsFrame")
    if existingFrame then 
        DEFAULT_CHAT_FRAME:AddMessage("Shoutouts frame already exists")
        return 
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("Creating new Shoutouts frame...")
    
    local f = CreateFrame("Frame", "SS_Tab2_ShoutoutsFrame", SS_Frame)
    f:SetWidth(350)
    f:SetHeight(280)
    f:SetPoint("CENTER", SS_Frame, "CENTER", 0, 0)
    
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, 
        tileSize = 16, 
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    f:SetBackdropColor(0, 0, 0, 0.6)
    
    -- Verify creation
    if getglobal("SS_Tab2_ShoutoutsFrame") then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Frame created successfully!|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Frame creation FAILED!|r")
    end
    
    -- Title
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", f, "TOP", 0, -10)
    title:SetText(L["UI_TITLE"])
    
    -- Channel label
    local chanLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    chanLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -28)
    chanLabel:SetText("Channel:")
    
    -- Target label
    local targetLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    targetLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 75, -28)
    targetLabel:SetText("Whisper Target:")
    
    -- Channel Box
    local chanBox = CreateFrame("EditBox", "SS_Tab2_Shoutouts_ChannelBox", f, "InputBoxTemplate")
    chanBox:SetWidth(50)
    chanBox:SetHeight(32)
    chanBox:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -45)
    chanBox:SetAutoFocus(false)
    chanBox:SetText("s")
    
    -- Target Box
    local targetBox = CreateFrame("EditBox", "SS_Tab2_Shoutouts_TargetBox", f, "InputBoxTemplate")
    targetBox:SetWidth(100)
    targetBox:SetHeight(32)
    targetBox:SetPoint("LEFT", chanBox, "RIGHT", 10, 0)
    targetBox:SetAutoFocus(false)
    
    -- Selected color display
    local colorLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorLabel:SetPoint("TOPLEFT", chanBox, "BOTTOMLEFT", 0, -25)
    colorLabel:SetText("Selected Color:")
    
    local selectedColorText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    selectedColorText:SetPoint("LEFT", colorLabel, "RIGHT", 5, 0)
    selectedColorText:SetText("|cff" .. SS_Shoutouts_GetColorHex(SS_S.selectedColor) .. SS_S.selectedColor .. "|r")
    
    -- Message Box
    local msgBox = CreateFrame("EditBox", "SS_Tab2_Shoutouts_MessageBox", f, "InputBoxTemplate")
    msgBox:SetWidth(310)
    msgBox:SetHeight(32)
    msgBox:SetPoint("TOPLEFT", colorLabel, "BOTTOMLEFT", 0, -10)
    msgBox:SetMultiLine(false)
    msgBox:SetAutoFocus(false)
    
    -- Color buttons
    local x, y = 15, -150
    for i = 1, table.getn(SS_S.colors) do
        local colorData = SS_S.colors[i]
        local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        btn:SetWidth(55)
        btn:SetHeight(25)
        btn:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
        
        -- Set button text color to match the color
        local btnText = btn:GetFontString()
        if btnText then
            btnText:SetText(colorData.name)
            btnText:SetTextColor(
                tonumber(string.sub(colorData.hex, 1, 2), 16) / 255,
                tonumber(string.sub(colorData.hex, 3, 4), 16) / 255,
                tonumber(string.sub(colorData.hex, 5, 6), 16) / 255
            )
        end
        
        btn:SetScript("OnClick", function() 
            SS_S.selectedColor = colorData.name
            if selectedColorText then
                selectedColorText:SetText("|cff" .. colorData.hex .. colorData.name .. "|r")
            end
        end)
        x = x + 60
        if x > 250 then 
            x = 15 
            y = y - 30 
        end
    end
    
    -- Send button
    local sendBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    sendBtn:SetWidth(120)
    sendBtn:SetHeight(35)
    sendBtn:SetPoint("BOTTOM", f, "BOTTOM", 0, 20)
    sendBtn:SetText(L["SEND"])
    sendBtn:SetScript("OnClick", function()
        local ch = chanBox and SS_Shoutouts_Trim(chanBox:GetText()) or "s"
        local tgt = targetBox and SS_Shoutouts_Trim(targetBox:GetText()) or ""
        local text = msgBox and msgBox:GetText() or ""
        if text ~= "" then
            SS_Shoutouts_Send(ch, tgt, SS_S.selectedColor, text)
            msgBox:SetText("") -- Clear after sending
        end
    end)
    
    -- Store references
    SS_S.chanBox = chanBox
    SS_S.targetBox = targetBox
    SS_S.msgBox = msgBox
    SS_S.selectedColorText = selectedColorText
    
    f:Hide()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Shoutouts UI created!|r")
end

-- ============================================================================
-- SLASH COMMAND INTEGRATION
-- ============================================================================

function SS_Shoutouts_HandleCommand(args)
    -- Parse args: /ss <channel> <color> <message>
    -- OR: /ss w <target> <color> <message>
    
    if table.getn(args) == 0 then
        -- No args - toggle UI handled in main slash command
        return false
    end
    
    local channel = args[1]
    local color, target, message
    
    if channel == "w" then
        target = args[2]
        color = args[3]
        -- Reconstruct message from remaining args
        local msgParts = {}
        for i = 4, table.getn(args) do
            table.insert(msgParts, args[i])
        end
        message = table.concat(msgParts, " ")
    else
        color = args[2]
        -- Reconstruct message from remaining args
        local msgParts = {}
        for i = 3, table.getn(args) do
            table.insert(msgParts, args[i])
        end
        message = table.concat(msgParts, " ")
    end
    
    if not message or message == "" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffFF8000SlackSpotter Shoutouts:|r Usage: /ss <channel> <color> <message>")
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFFFFFExample:|r /ss r red Hello raid!")
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFFFFFWhisper:|r /ss w PlayerName blue Secret message")
        return true
    end
    
    SS_Shoutouts_Send(channel, target, color, message)
    return true
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function SS_Shoutouts_Initialize()
    -- Ensure SavedVariables is properly initialized
    if not SS_ShoutoutsDB then
        SS_ShoutoutsDB = { frame = { x = nil, y = nil } }
    end
    if not SS_ShoutoutsDB.frame then
        SS_ShoutoutsDB.frame = { x = nil, y = nil }
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Shoutouts module loaded!|r")
end