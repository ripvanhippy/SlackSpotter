-- ============================================================================
-- SLACKSPOTTER - RAID LIST DISPLAY (Tab 1)
-- Display consume check results in the raid member table
-- ============================================================================

-- ============================================================================
-- GLOBALS
-- ============================================================================
SS_Display_RaidResults = {}  -- Stores last check results
SS_Display_ScrollOffset = 0
SS_Display_MaxVisibleRows = 25
SS_Display_RowHeight = 20

-- ============================================================================
-- UPDATE DISPLAY
-- ============================================================================

function SS_Display_UpdateRaidList()
    local content = getglobal("SS_Tab1_RaidListPanel_Content")
    if not content then return end
    
    -- Check if results exist
    if not SS_Display_RaidResults or not next(SS_Display_RaidResults) then
        -- Clear all rows if no data
        for i = 1, SS_Display_MaxVisibleRows do
            local row = getglobal("SS_Tab1_RaidRow" .. i)
            if row then row:Hide() end
        end
        return
    end
    
    -- Build sorted member list
    local memberList = {}
    for playerName, data in pairs(SS_Display_RaidResults) do
        table.insert(memberList, {
            name = playerName,
            class = data.class,
            spec = data.spec,
            found = data.found or 0,
            required = data.required or 0,
            passed = data.passed,
            buffsFound = data.buffsFound,
            buffsRequired = data.buffsRequired
        })
    end
    
    -- Sort by name
    table.sort(memberList, function(a, b) return a.name < b.name end)
    
    -- Display visible rows
    for i = 1, SS_Display_MaxVisibleRows do
        local dataIndex = i + SS_Display_ScrollOffset
        if dataIndex <= table.getn(memberList) then
            SS_Display_CreateRow(i, memberList[dataIndex])
        else
            -- Hide rows beyond data
            local row = getglobal("SS_Tab1_RaidRow" .. i)
            if row then row:Hide() end
        end
    end
end

-- ============================================================================
-- CREATE/UPDATE ROW
-- ============================================================================

function SS_Display_CreateRow(rowIndex, memberData)
    local content = getglobal("SS_Tab1_RaidListPanel_Content")
    if not content then return end
    
    local rowName = "SS_Tab1_RaidRow" .. rowIndex
    local row = getglobal(rowName)
    
    -- Create row if doesn't exist
    if not row then
        row = CreateFrame("Frame", rowName, content)
        row:SetWidth(480)
        row:SetHeight(SS_Display_RowHeight)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(rowIndex-1) * SS_Display_RowHeight)
        
        -- Player name
        row.nameLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.nameLabel:SetPoint("LEFT", row, "LEFT", 5, 0)
        row.nameLabel:SetWidth(120)
        row.nameLabel:SetJustifyH("LEFT")
        
        -- Raid buffs placeholder (TODO)
        row.buffsLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.buffsLabel:SetPoint("LEFT", row.nameLabel, "RIGHT", 10, 0)
        row.buffsLabel:SetWidth(80)
        
        -- Consumes count
        row.consumesLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.consumesLabel:SetPoint("LEFT", row.buffsLabel, "RIGHT", 10, 0)
        row.consumesLabel:SetWidth(60)
    end
    
    -- Update row data
    -- Check if player is offline (if they have no data, assume offline)
    local isOffline = (memberData.buffsFound == nil and memberData.found == nil)
    
    if isOffline then
    row.nameLabel:SetTextColor(0.5, 0.5, 0.5)  -- Grey
else
    local classUpper = string.upper(memberData.class)
    local classColor = SS_ClassColors[classUpper]
    if classColor then
        row.nameLabel:SetTextColor(classColor.r, classColor.g, classColor.b)
    else
        row.nameLabel:SetTextColor(1, 1, 1)
    end
end
row.nameLabel:SetText(memberData.name)
    
    -- Raid buffs display
    if memberData.buffsFound and memberData.buffsRequired then
        local buffsText = memberData.buffsFound .. "/" .. memberData.buffsRequired
        if memberData.buffsFound >= memberData.buffsRequired then
            row.buffsLabel:SetTextColor(0, 1, 0)  -- Green
        else
            row.buffsLabel:SetTextColor(1, 0, 0)  -- Red
        end
        row.buffsLabel:SetText(buffsText)
    else
        row.buffsLabel:SetTextColor(1, 1, 1)  -- White
        row.buffsLabel:SetText("-")
    end
    
    -- Consumes display
    local consumeText = memberData.found .. "/" .. memberData.required
    if memberData.passed then
        row.consumesLabel:SetTextColor(0, 1, 0)  -- Green
    else
        row.consumesLabel:SetTextColor(1, 0, 0)  -- Red
    end
    row.consumesLabel:SetText(consumeText)
    
    row:Show()
end

-- ============================================================================
-- SCROLL FUNCTIONS
-- ============================================================================

function SS_Display_ScrollUp()
    if SS_Display_ScrollOffset > 0 then
        SS_Display_ScrollOffset = SS_Display_ScrollOffset - 3
        if SS_Display_ScrollOffset < 0 then
            SS_Display_ScrollOffset = 0
        end
        SS_Display_UpdateRaidList()
    end
end

function SS_Display_ScrollDown()
    local maxOffset = table.getn(SS_Display_RaidResults) - SS_Display_MaxVisibleRows
    if maxOffset < 0 then maxOffset = 0 end
    
    if SS_Display_ScrollOffset < maxOffset then
        SS_Display_ScrollOffset = SS_Display_ScrollOffset + 3
        SS_Display_UpdateRaidList()
    end
end

-- ============================================================================
-- INITIALIZE
-- ============================================================================

function SS_Display_Initialize()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SlackSpotter Display module loaded!|r")
end