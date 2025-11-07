-- ============================================================================
-- SLACKSPOTTER - SHOUTOUTS MODULE (Tab 2)
-- Colored messages and countdown announcements
-- ============================================================================

-- ============================================================================
-- SAVED VARIABLES
-- ============================================================================
SS_ShoutoutsDB = SS_ShoutoutsDB or {
    lastChannel = "RAID",
    lastColor = "red",
    lastWhisperTarget = ""
}

-- ============================================================================
-- WORKING MEMORY
-- ============================================================================
SS_Shoutouts_SelectedChannel = "RAID"
SS_Shoutouts_SelectedColor = "red"
SS_Shoutouts_WhisperTarget = ""
SS_Shoutouts_CountdownEnabled = false
SS_Shoutouts_CountdownSeconds = 8
SS_Shoutouts_CountdownInterval = 2
SS_Shoutouts_CountdownActive = false

-- Color hex codes
SS_Shoutouts_Colors = {
    red = "ff0000",
    blue = "0080ff",
    green = "00ff00",
    yellow = "ffff00",
    orange = "ff8000",
    purple = "c080ff",
    white = "ffffff",
    pink = "ff80c0"
}

-- Rainbow color sequence
SS_Shoutouts_RainbowColors = {"ff0000", "ff8000", "ffff00", "00ff00", "0080ff", "8000ff", "ff00ff"}

-- Character limits
SS_Shoutouts_NormalLimit = 243
SS_Shoutouts_RainbowLimit = 19  -- Adjust after testing

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function SS_Shoutouts_Initialize()
    -- Load saved settings (or use defaults)
    if SS_ShoutoutsDB.lastChannel then
        SS_Shoutouts_SelectedChannel = SS_ShoutoutsDB.lastChannel
    else
        SS_Shoutouts_SelectedChannel = "RAID"
    end
    
    if SS_ShoutoutsDB.lastColor then
        SS_Shoutouts_SelectedColor = SS_ShoutoutsDB.lastColor
    else
        SS_Shoutouts_SelectedColor = "red"
    end
    if SS_ShoutoutsDB.lastWhisperTarget then
        SS_Shoutouts_WhisperTarget = SS_ShoutoutsDB.lastWhisperTarget
    end
    
--    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Shoutouts module loaded!|r")
end

-- ============================================================================
-- TAB DISPLAY
-- ============================================================================
function SS_Shoutouts_ShowTab()
    -- Show all panels
    if SS_Tab2_ChannelPanel then SS_Tab2_ChannelPanel:Show() end
    if SS_Tab2_ColorPanel then SS_Tab2_ColorPanel:Show() end
    if SS_Tab2_MessagePanel then SS_Tab2_MessagePanel:Show() end
    if SS_Tab2_CountdownPanel then SS_Tab2_CountdownPanel:Show() end
    
    -- Create buttons if not already created
    if not SS_Shoutouts_ButtonsCreated then
        SS_Shoutouts_CreateChannelButtons()
        SS_Shoutouts_CreateColorButtons()
        SS_Shoutouts_ButtonsCreated = true
    end
    
    -- Update UI to reflect current selections
    SS_Shoutouts_UpdateChannelButtons()
    SS_Shoutouts_UpdateColorButtons()
    SS_Shoutouts_UpdateWhisperTargetVisibility()
    SS_Shoutouts_UpdateCharCounter()
end

function SS_Shoutouts_HideTab()
    -- Hide all panels
    if SS_Tab2_ChannelPanel then SS_Tab2_ChannelPanel:Hide() end
    if SS_Tab2_ColorPanel then SS_Tab2_ColorPanel:Hide() end
    if SS_Tab2_MessagePanel then SS_Tab2_MessagePanel:Hide() end
    if SS_Tab2_CountdownPanel then SS_Tab2_CountdownPanel:Hide() end
end

-- ============================================================================
-- CREATE BUTTONS IN LUA
-- ============================================================================
function SS_Shoutouts_CreateChannelButtons()
    local channels = {
        {name="RAID", text="Raid", color={1.0, 0.49, 0.04}},
        {name="SAY", text="Say", color={1.0, 1.0, 1.0}},
        {name="PARTY", text="Party", color={0.67, 0.67, 1.0}},
        {name="GUILD", text="Guild", color={0.25, 1.0, 0.25}},
        {name="YELL", text="Yell", color={1.0, 0.25, 0.25}},
        {name="OFFICER", text="Officer", color={0.25, 0.75, 0.25}},
        {name="WHISPER", text="Whisper", color={1.0, 0.5, 1.0}}
    }
    
    local parent = getglobal("SS_Tab2_ChannelPanel")
    if not parent then return end
    
    for i = 1, table.getn(channels) do
        local ch = channels[i]
        local btn = CreateFrame("Button", "SS_Tab2_ChannelButton_"..ch.name, parent, "UIPanelButtonTemplate")
        btn:SetWidth(70)
        btn:SetHeight(25)
        
        -- Position (4 per row)
        local row = math.floor((i-1) / 4)
        local col = (i-1) - (row * 4)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 15 + col*75, -35 - row*30)
        
        btn:SetText(ch.text)
        getglobal(btn:GetName().."Text"):SetTextColor(ch.color[1], ch.color[2], ch.color[3])
        
        local capturedName = ch.name
        btn:SetScript("OnClick", function() SS_Shoutouts_SelectChannel(capturedName) end)
    end
end

function SS_Shoutouts_CreateColorButtons()
    local colors = {
        {name="red", text="Red", color={1.0, 0.0, 0.0}},
        {name="blue", text="Blue", color={0.0, 0.5, 1.0}},
        {name="green", text="Green", color={0.0, 1.0, 0.0}},
        {name="yellow", text="Yellow", color={1.0, 1.0, 0.0}},
        {name="orange", text="Orange", color={1.0, 0.5, 0.0}},
        {name="purple", text="Purple", color={0.75, 0.5, 1.0}},
        {name="white", text="White", color={1.0, 1.0, 1.0}},
        {name="pink", text="Pink", color={1.0, 0.5, 0.75}},
        {name="rainbow", text="Rainbow", color={1.0, 0.0, 1.0}}
    }
    
    local parent = getglobal("SS_Tab2_ColorPanel")
    if not parent then return end
    
    for i = 1, table.getn(colors) do
        local c = colors[i]
        local btn = CreateFrame("Button", "SS_Tab2_ColorButton_"..c.name, parent, "UIPanelButtonTemplate")
        
        if c.name == "rainbow" then
            btn:SetWidth(145)
        else
            btn:SetWidth(70)
        end
        btn:SetHeight(25)
        
        -- Position (4 per row, rainbow spans 2)
        local row = math.floor((i-1) / 4)
        local col = (i-1) - (row * 4)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 15 + col*75, -35 - row*30)
        
        if c.name == "rainbow" then
            -- Special handling for rainbow button - create colored text manually
            btn:SetText("")
            btn.rainbowText = btn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
            btn.rainbowText:SetPoint("CENTER", btn, "CENTER", 0, 0)
            btn.rainbowText:SetText("|cffff0000R|cffff8000a|cffffff00i|cff00ff00n|cff0080ffb|cff8000ffo|cffff00ffw|r")
        else
            btn:SetText(c.text)
            getglobal(btn:GetName().."Text"):SetTextColor(c.color[1], c.color[2], c.color[3])
        end
        
        local capturedName = c.name
        btn:SetScript("OnClick", function() SS_Shoutouts_SelectColor(capturedName) end)
    end
end

-- ============================================================================
-- CHANNEL SELECTION
-- ============================================================================
function SS_Shoutouts_SelectChannel(channel)
    SS_Shoutouts_SelectedChannel = channel
    SS_ShoutoutsDB.lastChannel = channel
    
    SS_Shoutouts_UpdateChannelButtons()
    SS_Shoutouts_UpdateWhisperTargetVisibility()
end

function SS_Shoutouts_UpdateChannelButtons()
    local channels = {"RAID", "SAY", "PARTY", "GUILD", "YELL", "OFFICER", "WHISPER"}
    
    for i = 1, table.getn(channels) do
        local channel = channels[i]
        local btn = getglobal("SS_Tab2_ChannelButton_" .. channel)
        
        if btn then
            if channel == SS_Shoutouts_SelectedChannel then
                btn:LockHighlight()
            else
                btn:UnlockHighlight()
            end
			btn:SetAlpha(1.0)
        end
    end
end

function SS_Shoutouts_UpdateWhisperTargetVisibility()
    local targetBox = getglobal("SS_Tab2_WhisperTargetEditBox")
    local targetLabel = getglobal("SS_Tab2_WhisperTargetLabel")
    
    if SS_Shoutouts_SelectedChannel == "WHISPER" then
        if targetBox then targetBox:Show() end
        if targetLabel then targetLabel:Show() end
    else
        if targetBox then targetBox:Hide() end
        if targetLabel then targetLabel:Hide() end
    end
end

-- ============================================================================
-- COLOR SELECTION
-- ============================================================================
function SS_Shoutouts_SelectColor(color)
    SS_Shoutouts_SelectedColor = color
    SS_ShoutoutsDB.lastColor = color
    
    SS_Shoutouts_UpdateColorButtons()
    SS_Shoutouts_UpdateCharCounter()
end

function SS_Shoutouts_UpdateColorButtons()
    local colors = {"red", "blue", "green", "yellow", "orange", "purple", "white", "pink", "rainbow"}
    
    for i = 1, table.getn(colors) do
        local color = colors[i]
        local btn = getglobal("SS_Tab2_ColorButton_" .. color)
        
        if btn then
            if color == SS_Shoutouts_SelectedColor then
                btn:LockHighlight()
            else
                btn:UnlockHighlight()
            end
			btn:SetAlpha(1.0)
        end
    end
	-- Update countdown counters when color changes
    SS_Shoutouts_UpdateCountdownCounters()
end

-- ============================================================================
-- CHARACTER COUNTER
-- ============================================================================
function SS_Shoutouts_UpdateCharCounter()
    local editBox = getglobal("SS_Tab2_MessageEditBox")
    local counter = getglobal("SS_Tab2_CharCounter")
    
    if not editBox or not counter then return end
    
    local text = editBox:GetText() or ""
    local length = string.len(text)
    
    local limit = SS_Shoutouts_NormalLimit
    local isOverLimit = false
    
    if SS_Shoutouts_SelectedColor == "rainbow" then
        -- Count letters and spaces separately for rainbow
        local letterCount = 0
        local spaceCount = 0
        
        for i = 1, string.len(text) do
            local char = string.sub(text, i, i)
            if char == " " then
                spaceCount = spaceCount + 1
            else
                letterCount = letterCount + 1
            end
        end
        
        local counterText = letterCount .. "/" .. SS_Shoutouts_RainbowLimit .. " (" .. spaceCount .. "/8 spaces)"
        counter:SetText(counterText)
        
        -- Over limit if too many letters OR too many spaces
        if letterCount > SS_Shoutouts_RainbowLimit or spaceCount > 8 then
            isOverLimit = true
        end
    else
        -- Normal colors: total character count
        local counterText = length .. "/" .. limit
        counter:SetText(counterText)
        
        if length > limit then
            isOverLimit = true
        end
    end
    
    if isOverLimit then
        counter:SetTextColor(1, 0, 0)  -- Red
    else
        counter:SetTextColor(1, 1, 1)  -- White
    end
end

-- ============================================================================
-- UPDATE COUNTDOWN COUNTERS (Before/After messages)
-- ============================================================================
function SS_Shoutouts_UpdateCountdownCounters()
    if SS_Shoutouts_SelectedColor ~= "rainbow" then
        -- Hide counters if not rainbow
        local beforeCounter = getglobal("SS_Tab2_CountdownBeforeCounter")
        local afterCounter = getglobal("SS_Tab2_CountdownAfterCounter")
        if beforeCounter then beforeCounter:Hide() end
        if afterCounter then afterCounter:Hide() end
        return
    end
    
    -- Show and update counters for rainbow
    local beforeBox = getglobal("SS_Tab2_CountdownBeforeEditBox")
    local afterBox = getglobal("SS_Tab2_CountdownAfterEditBox")
    local beforeCounter = getglobal("SS_Tab2_CountdownBeforeCounter")
    local afterCounter = getglobal("SS_Tab2_CountdownAfterCounter")
    
    if beforeCounter then beforeCounter:Show() end
    if afterCounter then afterCounter:Show() end
    
    -- Count for "Before" message
    if beforeBox and beforeCounter then
        local text = beforeBox:GetText() or ""
        local letterCount = 0
        local spaceCount = 0
        
        for i = 1, string.len(text) do
            local char = string.sub(text, i, i)
            if char == " " then
                spaceCount = spaceCount + 1
            else
                letterCount = letterCount + 1
            end
        end
        
        local counterText = letterCount .. "/" .. SS_Shoutouts_RainbowLimit .. " (" .. spaceCount .. "/8)"
        beforeCounter:SetText(counterText)
        
        if letterCount > SS_Shoutouts_RainbowLimit or spaceCount > 8 then
            beforeCounter:SetTextColor(1, 0, 0)
        else
            beforeCounter:SetTextColor(1, 1, 1)
        end
    end
    
    -- Count for "After" message
    if afterBox and afterCounter then
        local text = afterBox:GetText() or ""
        local letterCount = 0
        local spaceCount = 0
        
        for i = 1, string.len(text) do
            local char = string.sub(text, i, i)
            if char == " " then
                spaceCount = spaceCount + 1
            else
                letterCount = letterCount + 1
            end
        end
        
        local counterText = letterCount .. "/" .. SS_Shoutouts_RainbowLimit .. " (" .. spaceCount .. "/8)"
        afterCounter:SetText(counterText)
        
        if letterCount > SS_Shoutouts_RainbowLimit or spaceCount > 8 then
            afterCounter:SetTextColor(1, 0, 0)
        else
            afterCounter:SetTextColor(1, 1, 1)
        end
    end
end

-- ============================================================================
-- SEND MESSAGE
-- ============================================================================
function SS_Shoutouts_SendMessage()
    local editBox = getglobal("SS_Tab2_MessageEditBox")
    if not editBox then return end
    
    local message = editBox:GetText()
    if not message or message == "" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000No message to send!|r")
        return
    end
    
    -- Check length
    if SS_Shoutouts_SelectedColor == "rainbow" then
        -- Count letters and spaces for rainbow
        local letterCount = 0
        local spaceCount = 0
        
        for i = 1, string.len(message) do
            local char = string.sub(message, i, i)
            if char == " " then
                spaceCount = spaceCount + 1
            else
                letterCount = letterCount + 1
            end
        end
        
        if letterCount > SS_Shoutouts_RainbowLimit then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Too many letters! Rainbow limit: " .. SS_Shoutouts_RainbowLimit .. " letters.|r")
            return
        end
        
        if spaceCount > 8 then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Too many spaces! Rainbow limit: 8 spaces.|r")
            return
        end
    else
        -- Normal colors: total character limit
        if string.len(message) > SS_Shoutouts_NormalLimit then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Message too long! Limit: " .. SS_Shoutouts_NormalLimit .. " characters.|r")
            return
        end
    end
    
    -- Validate whisper target
    if SS_Shoutouts_SelectedChannel == "WHISPER" then
        local targetBox = getglobal("SS_Tab2_WhisperTargetEditBox")
        local target = targetBox and targetBox:GetText() or ""
        if target == "" then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Please enter a whisper target!|r")
            return
        end
        SS_Shoutouts_WhisperTarget = target
        SS_ShoutoutsDB.lastWhisperTarget = target
    end
    
    -- Color the message
    local coloredMessage = SS_Shoutouts_ColorizeMessage(message)
    
    -- Send to channel
    SS_Shoutouts_SendToChannel(coloredMessage)
end

function SS_Shoutouts_ColorizeMessage(message)
    if SS_Shoutouts_SelectedColor == "rainbow" then
        return SS_Shoutouts_RainbowText(message)
    else
        local hex = SS_Shoutouts_Colors[SS_Shoutouts_SelectedColor] or "ffffff"
        return "|cff" .. hex .. message .. "|r"
    end
end

function SS_Shoutouts_RainbowText(text)
    local result = ""
    local colorIndex = 1
    
    for i = 1, string.len(text) do
        local char = string.sub(text, i, i)
        if char ~= " " then
            result = result .. "|cff" .. SS_Shoutouts_RainbowColors[colorIndex] .. char .. "|r"
            colorIndex = colorIndex + 1
            if colorIndex > table.getn(SS_Shoutouts_RainbowColors) then
                colorIndex = 1
            end
        else
            result = result .. " "
        end
    end
    
    return result
end

function SS_Shoutouts_SendToChannel(message)
    local channel = SS_Shoutouts_SelectedChannel
    
    -- Debug mode: print to chat instead of sending
    if SS_DebugMode then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000[SHOUTOUTS DEBUG]|r Channel: " .. channel)
        DEFAULT_CHAT_FRAME:AddMessage(message)
        return
    end
    
    -- Normal mode: send to channel
    if channel == "RAID" then
        if GetNumRaidMembers() > 0 then
            SendChatMessage(message, "RAID")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000You are not in a raid!|r")
        end
    elseif channel == "SAY" then
        SendChatMessage(message, "SAY")
    elseif channel == "PARTY" then
        if GetNumPartyMembers() > 0 then
            SendChatMessage(message, "PARTY")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000You are not in a party!|r")
        end
    elseif channel == "GUILD" then
        if IsInGuild() then
            SendChatMessage(message, "GUILD")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000You are not in a guild!|r")
        end
    elseif channel == "YELL" then
        SendChatMessage(message, "YELL")
    elseif channel == "OFFICER" then
        if IsInGuild() then
            SendChatMessage(message, "OFFICER")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000You are not in a guild!|r")
        end
    elseif channel == "WHISPER" then
        SendChatMessage(message, "WHISPER", nil, SS_Shoutouts_WhisperTarget)
    end
end

-- ============================================================================
-- COUNTDOWN
-- ============================================================================
function SS_Shoutouts_CountdownCheckbox_OnClick()
    local checkbox = getglobal("SS_Tab2_CountdownCheckbox")
    if checkbox then
        SS_Shoutouts_CountdownEnabled = checkbox:GetChecked()
    end
end


function SS_Shoutouts_StartCountdown()
    if SS_Shoutouts_CountdownActive then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Countdown already in progress!|r")
        return
    end
    
    -- Get countdown settings
    local secondsBox = getglobal("SS_Tab2_CountdownSecondsEditBox")
	local intervalBox = getglobal("SS_Tab2_CountdownIntervalEditBox")
    local beforeBox = getglobal("SS_Tab2_CountdownBeforeEditBox")
    local afterBox = getglobal("SS_Tab2_CountdownAfterEditBox")
    
    if not secondsBox or not beforeBox or not afterBox then return end
    
    local seconds = tonumber(secondsBox:GetText()) or 8
	local interval = tonumber(intervalBox:GetText()) or 2
    local beforeMsg = beforeBox:GetText() or ""
    local afterMsg = afterBox:GetText() or ""
    
    if seconds < 1 then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Countdown must be at least 1 second!|r")
        return
    end
    
    SS_Shoutouts_CountdownActive = true
    
    -- Send "before" message
    if beforeMsg ~= "" then
        local coloredBefore = SS_Shoutouts_ColorizeMessage(beforeMsg)
        SS_Shoutouts_SendToChannel(coloredBefore)
        
        -- Wait interval before starting countdown
        SS_ScheduleTimer(function()
            SS_Shoutouts_CountdownTick(seconds, afterMsg, interval)
        end, interval)
    else
        -- No before message, start countdown immediately
        SS_Shoutouts_CountdownTick(seconds, afterMsg, interval)
    end
end

function SS_Shoutouts_CountdownTick(remaining, afterMsg, interval)
    if remaining > 0 then
        -- Send countdown number
        local countMsg = tostring(remaining) .. "..."
        local coloredCount = SS_Shoutouts_ColorizeMessage(countMsg)
        SS_Shoutouts_SendToChannel(coloredCount)
        
        -- Schedule next tick
        local nextRemaining = remaining - 1
        local capturedAfter = afterMsg
        local capturedInterval = interval
        SS_ScheduleTimer(function()
            SS_Shoutouts_CountdownTick(nextRemaining, capturedAfter, capturedInterval)
        end, interval)
    else
        -- Countdown finished, wait 1 second then send "after" message
        SS_ScheduleTimer(function()
            if afterMsg ~= "" then
                local coloredAfter = SS_Shoutouts_ColorizeMessage(afterMsg)
                SS_Shoutouts_SendToChannel(coloredAfter)
            end
            SS_Shoutouts_CountdownActive = false
        end, interval)
    end
end

-- ============================================================================
-- TIMER UTILITY
-- ============================================================================
function SS_ScheduleTimer(func, delay)
    local frame = CreateFrame("Frame")
    local elapsed = 0
    
    frame:SetScript("OnUpdate", function()
        elapsed = elapsed + arg1
        if elapsed >= delay then
            frame:SetScript("OnUpdate", nil)
            func()
        end
    end)
end