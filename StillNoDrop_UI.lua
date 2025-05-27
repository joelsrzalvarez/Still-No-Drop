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
    SND_Frame.myRunsLabel = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    SND_Frame.myRunsLabel:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 20, -95)
    SND_Frame.myRunsLabel:SetText("My runs:")
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
    function SND:UpdateRunsList()
        local runs = SND:GetRuns()
        for i, fontString in ipairs(SND_Frame.runsList or {}) do
            fontString:Hide()
        end
        SND_Frame.runsList = SND_Frame.runsList or {}
        for i, runName in ipairs(runs) do
            if not SND_Frame.runsList[i] then
                SND_Frame.runsList[i] = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                SND_Frame.runsList[i]:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 40, -95 - i * 20)
            end
            SND_Frame.runsList[i]:SetText(i .. ". " .. runName)
            SND_Frame.runsList[i]:Show()
        end
    end
    local close = CreateFrame("Button", nil, SND_Frame, "UIPanelCloseButton")
    close:SetSize(24, 24)
    close:SetPoint("TOPRIGHT", SND_Frame, "TOPRIGHT", -5, -5)
    close:SetScript("OnClick", function() SND_Frame:Hide() end)
    SND_Frame:SetScript("OnShow", function() SND:UpdateRunsList() end)
    SND_Frame:Hide()
end
