if not SND then SND = {} end

SND.ITEMS_PER_PAGE = 10
SND.currentPage = 1

function SND:ToggleUI()
    if not SND_Frame then
        self:CreateUI()
    end
    if SND_Frame:IsShown() then
        SND_Frame:Hide()
    else
        SND_Frame:Show()
        if SND.UpdateRunsList then
            SND:UpdateRunsList()
        end
    end
end

function SND:CreateUI()
    SND_Frame = CreateFrame("Frame", "SND_Frame", UIParent)
    SND_Frame:SetSize(650, 525)
    SND_Frame:SetPoint("CENTER")
    SND_Frame:SetMovable(true)
    SND_Frame:EnableMouse(true)
    SND_Frame:RegisterForDrag("LeftButton")
    SND_Frame:SetScript("OnDragStart", SND_Frame.StartMoving)
    SND_Frame:SetScript("OnDragStop", SND_Frame.StopMovingOrSizing)
    SND_Frame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile     = true,
        tileSize = 8,
        edgeSize = 16,
        insets   = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    SND_Frame:SetBackdropColor(0, 0, 0, 1)
    SND_Frame:SetBackdropBorderColor(1, 1, 1, 1)
    SND_Frame.title = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")

    SND_Frame.title:SetPoint("TOP", SND_Frame, "TOP", 0, -10)
    SND_Frame.title:SetText("Still No Drop")
    SND_Frame.separator = SND_Frame:CreateTexture(nil, "ARTWORK")
    SND_Frame.separator:SetTexture("Interface\\Buttons\\WHITE8x8")
    SND_Frame.separator:SetVertexColor(1, 1, 1, 1)
    SND_Frame.separator:SetHeight(2)
    SND_Frame.separator:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 10, -40)
    SND_Frame.separator:SetPoint("TOPRIGHT", SND_Frame, "TOPRIGHT", -10, -40)
    SND_Frame.newRunLabel = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    SND_Frame.newRunLabel:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 20, -55)
    SND_Frame.newRunLabel:SetText("Introduce new run:")
    SND_Frame.newRunEditBox = CreateFrame("EditBox", nil, SND_Frame, "InputBoxTemplate")
    SND_Frame.newRunEditBox:SetSize(200, 30)
    SND_Frame.newRunEditBox:SetPoint("LEFT", SND_Frame.newRunLabel, "RIGHT", 10, 0)
    SND_Frame.newRunEditBox:SetAutoFocus(false)
    SND_Frame.newRunEditBox:SetMaxLetters(64)
    SND_Frame.newRunEditBox:SetText("")
    SND_Frame.okButton = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
    SND_Frame.okButton:SetSize(40, 24)
    SND_Frame.okButton:SetPoint("LEFT", SND_Frame.newRunEditBox, "RIGHT", 10, 0)
    SND_Frame.okButton:SetText("OK")
    SND_Frame.tableHeaderTop = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    SND_Frame.tableHeaderName = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    SND_Frame.tableHeaderAttempts = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    SND_Frame.tableHeaderActions = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")

    SND_Frame.tableHeaderTop:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 40, -120)
    SND_Frame.tableHeaderTop:SetText("Top")
    SND_Frame.tableHeaderName:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 80, -120)
    SND_Frame.tableHeaderName:SetText("Name")
    SND_Frame.tableHeaderAttempts:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 270, -120)
    SND_Frame.tableHeaderAttempts:SetText("Attempts")
    SND_Frame.tableHeaderActions:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 360, -120)
    SND_Frame.tableHeaderActions:SetText("Actions")

    SND_Frame.runsList = {}
    SND_Frame.okButton:SetScript("OnClick", function()
        local runName = SND_Frame.newRunEditBox:GetText()
        local ok, msg = SND:AddRun(runName)
        if ok then
            SND_Frame.newRunEditBox:SetText("")
            SND:UpdateRunsList()
        end
        print("|cffffff00[Still No Drop]|r " .. msg)
    end)
    local close = CreateFrame("Button", nil, SND_Frame, "UIPanelCloseButton")
    close:SetSize(24, 24)
    close:SetPoint("TOPRIGHT", SND_Frame, "TOPRIGHT", -5, -5)
    close:SetScript("OnClick", function() SND_Frame:Hide() end)
    SND_Frame:SetScript("OnShow", function() SND:UpdateRunsList() end)
    SND_Frame:Hide()
end

function SND:UpdateRunsList()
    if not SND_Frame.rows then SND_Frame.rows = {} end
    local runs = SND:GetRuns()
    local totalPages = math.ceil(#runs / SND.ITEMS_PER_PAGE)
    if SND.currentPage > totalPages then SND.currentPage = totalPages end
    if SND.currentPage < 1 then SND.currentPage = 1 end

    local startIdx = (SND.currentPage - 1) * SND.ITEMS_PER_PAGE + 1
    local endIdx = math.min(startIdx + SND.ITEMS_PER_PAGE - 1, #runs)

    for i, row in ipairs(SND_Frame.rows) do
        row.top:Hide()
        row.name:Hide()
        row.attempts:Hide()
        row.inc:Hide()
        row.dec:Hide()
        row.del:Hide()
        if row.report then row.report:Hide() end
        if row.gotit then row.gotit:Hide() end
    end

    local visualRow = 1
    for idx = startIdx, endIdx do
        local runName = runs[idx]
        local y = -120 - visualRow * 32
        local xTop, xName, xAttempts, xInc, xDec, xDel, xReport, xGotIt =
            40, 80, 270, 370, 402, 434, 500, 570

        if not SND_Frame.rows[visualRow] then
            SND_Frame.rows[visualRow] = {}
            SND_Frame.rows[visualRow].top = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            SND_Frame.rows[visualRow].name = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            SND_Frame.rows[visualRow].attempts = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            SND_Frame.rows[visualRow].inc = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[visualRow].inc:SetSize(26, 22)
            SND_Frame.rows[visualRow].inc:SetText("+")
            SND_Frame.rows[visualRow].dec = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[visualRow].dec:SetSize(26, 22)
            SND_Frame.rows[visualRow].dec:SetText("-")
            SND_Frame.rows[visualRow].del = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[visualRow].del:SetSize(50, 22)
            SND_Frame.rows[visualRow].del:SetText("Delete")
            SND_Frame.rows[visualRow].report = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[visualRow].report:SetSize(55, 22)
            SND_Frame.rows[visualRow].report:SetText("Report")
            SND_Frame.rows[visualRow].gotit = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[visualRow].gotit:SetSize(60, 22)
            SND_Frame.rows[visualRow].gotit:SetText("Got it!")
        end

        SND_Frame.rows[visualRow].top:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xTop, y)
        SND_Frame.rows[visualRow].name:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xName, y)
        SND_Frame.rows[visualRow].attempts:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xAttempts, y)
        SND_Frame.rows[visualRow].inc:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xInc, y)
        SND_Frame.rows[visualRow].dec:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xDec, y)
        SND_Frame.rows[visualRow].del:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xDel, y)
        SND_Frame.rows[visualRow].report:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xReport, y)
        SND_Frame.rows[visualRow].gotit:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", xGotIt, y)

        SND_Frame.rows[visualRow].top:SetText(idx)
        SND_Frame.rows[visualRow].top:Show()
        if SND_DB[runName].gotit then
            SND_Frame.rows[visualRow].name:SetText("|cff00ff00" .. runName .. "|r")
        else
            SND_Frame.rows[visualRow].name:SetText(runName)
        end
        SND_Frame.rows[visualRow].name:Show()
        SND_Frame.rows[visualRow].attempts:SetText(SND_DB[runName].attempts or 0)
        SND_Frame.rows[visualRow].attempts:Show()
        SND_Frame.rows[visualRow].inc:Show()
        SND_Frame.rows[visualRow].dec:Show()
        SND_Frame.rows[visualRow].del:Show()
        SND_Frame.rows[visualRow].report:Show()
        SND_Frame.rows[visualRow].gotit:Show()

        if SND_DB[runName].gotit then
            SND_Frame.rows[visualRow].inc:Disable()
            SND_Frame.rows[visualRow].dec:Disable()
            SND_Frame.rows[visualRow].gotit:Disable()
        else
            SND_Frame.rows[visualRow].inc:Enable()
            SND_Frame.rows[visualRow].dec:Enable()
            SND_Frame.rows[visualRow].gotit:Enable()
        end

        SND_Frame.rows[visualRow].inc:SetScript("OnClick", function()
            SND_DB[runName].attempts = (SND_DB[runName].attempts or 0) + 1
            SND:UpdateRunsList()
        end)
        SND_Frame.rows[visualRow].dec:SetScript("OnClick", function()
            SND_DB[runName].attempts = math.max(0, (SND_DB[runName].attempts or 0) - 1)
            SND:UpdateRunsList()
        end)
        SND_Frame.rows[visualRow].del:SetScript("OnClick", function()
            SND_DB[runName] = nil
            SND:UpdateRunsList()
        end)
        SND_Frame.rows[visualRow].report:SetScript("OnClick", function()
            local count = SND_DB[runName].attempts or 0
            if SND_DB[runName].gotit then
                SendChatMessage("!!! I got my " .. runName .. " at attempt #" .. count .. " :DD !!!", "SAY")
            else
                SendChatMessage("I have #" .. count .. " attempts on " .. runName .. " and still no luck :(", "SAY")
            end
        end)
        SND_Frame.rows[visualRow].gotit:SetScript("OnClick", function()
            SND_DB[runName].gotit = true
            print("|cffffff00[Still No Drop]|r Congratulations! You got: " .. runName)
            SND:UpdateRunsList()
        end)
        visualRow = visualRow + 1
    end

    if SND_Frame.paginationButtons then
        for _, btn in ipairs(SND_Frame.paginationButtons) do
            btn:Hide()
        end
    else
        SND_Frame.paginationButtons = {}
    end

    local paginationY = -120 - (SND.ITEMS_PER_PAGE + 1) * 32
    local buttonX = 200
    local spaceX = 35

    for p = 1, totalPages do
        if not SND_Frame.paginationButtons[p] then
            SND_Frame.paginationButtons[p] = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.paginationButtons[p]:SetSize(30, 22)
        end
        SND_Frame.paginationButtons[p]:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", buttonX + (p-1)*spaceX, paginationY)
        SND_Frame.paginationButtons[p]:SetText(p)
        SND_Frame.paginationButtons[p]:Show()
        if p == SND.currentPage then
            SND_Frame.paginationButtons[p]:Disable()
        else
            SND_Frame.paginationButtons[p]:Enable()
            SND_Frame.paginationButtons[p]:SetScript("OnClick", function()
                SND.currentPage = p
                SND:UpdateRunsList()
            end)
        end
    end
end


