if not SND then SND = {} end

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
    SND_Frame:SetSize(600, 600)
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
    SND_Frame.tableHeaderTop:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 30, -120)
    SND_Frame.tableHeaderTop:SetText("Top")
    SND_Frame.tableHeaderName = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    SND_Frame.tableHeaderName:SetPoint("LEFT", SND_Frame.tableHeaderTop, "LEFT", 40, 0)
    SND_Frame.tableHeaderName:SetText("Name")
    SND_Frame.tableHeaderAttempts = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    SND_Frame.tableHeaderAttempts:SetPoint("LEFT", SND_Frame.tableHeaderName, "LEFT", 180, 0)
    SND_Frame.tableHeaderAttempts:SetText("Attempts")
    SND_Frame.tableHeaderActions = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    SND_Frame.tableHeaderActions:SetPoint("LEFT", SND_Frame.tableHeaderAttempts, "LEFT", 90, 0)
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
    for i, runName in ipairs(runs) do
        if not SND_Frame.rows[i] then
            SND_Frame.rows[i] = {}
            local y = -120 - i * 30
            SND_Frame.rows[i].top = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            SND_Frame.rows[i].top:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 30, y)
            SND_Frame.rows[i].name = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            SND_Frame.rows[i].name:SetPoint("LEFT", SND_Frame.rows[i].top, "LEFT", 40, 0)
            SND_Frame.rows[i].attempts = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            SND_Frame.rows[i].attempts:SetPoint("LEFT", SND_Frame.rows[i].name, "LEFT", 180, 0)
            SND_Frame.rows[i].inc = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[i].inc:SetSize(22, 22)
            SND_Frame.rows[i].inc:SetPoint("LEFT", SND_Frame.rows[i].attempts, "LEFT", 60, 0)
            SND_Frame.rows[i].inc:SetText("+")
            SND_Frame.rows[i].dec = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[i].dec:SetSize(22, 22)
            SND_Frame.rows[i].dec:SetPoint("LEFT", SND_Frame.rows[i].inc, "RIGHT", 2, 0)
            SND_Frame.rows[i].dec:SetText("-")
            SND_Frame.rows[i].del = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[i].del:SetSize(40, 22)
            SND_Frame.rows[i].del:SetPoint("LEFT", SND_Frame.rows[i].dec, "RIGHT", 2, 0)
            SND_Frame.rows[i].del:SetText("Delete")
            SND_Frame.rows[i].report = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[i].report:SetSize(50, 22)
            SND_Frame.rows[i].report:SetPoint("LEFT", SND_Frame.rows[i].del, "RIGHT", 2, 0)
            SND_Frame.rows[i].report:SetText("Report")
            SND_Frame.rows[i].gotit = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
            SND_Frame.rows[i].gotit:SetSize(50, 22)
            SND_Frame.rows[i].gotit:SetPoint("LEFT", SND_Frame.rows[i].report, "RIGHT", 2, 0)
            SND_Frame.rows[i].gotit:SetText("Got it!")
        end
        local y = -120 - i * 30
        SND_Frame.rows[i].top:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 30, y)
        SND_Frame.rows[i].top:SetText(i)
        SND_Frame.rows[i].top:Show()
        if SND_DB[runName].gotit then
            SND_Frame.rows[i].name:SetText("|cff00ff00" .. runName .. " (Got it!)|r")
        else
            SND_Frame.rows[i].name:SetText(runName)
        end
        SND_Frame.rows[i].name:Show()
        SND_Frame.rows[i].attempts:SetText(SND_DB[runName].attempts or 0)
        SND_Frame.rows[i].attempts:Show()
        SND_Frame.rows[i].inc:Show()
        SND_Frame.rows[i].dec:Show()
        SND_Frame.rows[i].del:Show()
        SND_Frame.rows[i].report:Show()
        SND_Frame.rows[i].gotit:Show()
        SND_Frame.rows[i].inc:SetScript("OnClick", function()
            SND_DB[runName].attempts = (SND_DB[runName].attempts or 0) + 1
            SND:UpdateRunsList()
        end)
        SND_Frame.rows[i].dec:SetScript("OnClick", function()
            SND_DB[runName].attempts = math.max(0, (SND_DB[runName].attempts or 0) - 1)
            SND:UpdateRunsList()
        end)
        SND_Frame.rows[i].del:SetScript("OnClick", function()
            SND_DB[runName] = nil
            SND:UpdateRunsList()
        end)
        SND_Frame.rows[i].report:SetScript("OnClick", function()
            local count = SND_DB[runName].attempts or 0
            SendChatMessage("I have #" .. count .. " attempts on " .. runName .. " and still no drop :(", "SAY")
        end)
        SND_Frame.rows[i].gotit:SetScript("OnClick", function()
            SND_DB[runName].gotit = true
            print("|cffffff00[Still No Drop]|r Congratulations! You got: " .. runName)
            SND:UpdateRunsList()
        end)
    end
end
