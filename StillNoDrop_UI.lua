-- Create the main frame
local SND_Frame = CreateFrame("Frame", "SND_Frame", UIParent)
SND_Frame:SetSize(600, 600)
SND_Frame:SetPoint("CENTER")
SND_Frame:SetMovable(true)
SND_Frame:EnableMouse(true)
SND_Frame:RegisterForDrag("LeftButton")
SND_Frame:SetScript("OnDragStart", SND_Frame.StartMoving)
SND_Frame:SetScript("OnDragStop", SND_Frame.StopMovingOrSizing)

-- Backdrop: black background + classic WoW border
SND_Frame:SetBackdrop({
    bgFile   = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile     = true,
    tileSize = 8,
    edgeSize = 16,
    insets   = { left = 6, right = 6, top = 6, bottom = 6 }
})
SND_Frame:SetBackdropColor(0, 0, 0, 1)        -- fondo negro sólido
SND_Frame:SetBackdropBorderColor(1, 1, 1, 1)  -- borde blanco

-- Title text
SND_Frame.title = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
SND_Frame.title:SetPoint("TOP", SND_Frame, "TOP", 0, -10)
SND_Frame.title:SetText("Still No Drop")

-- Separator line below title (WotLK compatible)
SND_Frame.separator = SND_Frame:CreateTexture(nil, "ARTWORK")
SND_Frame.separator:SetTexture("Interface\\Buttons\\WHITE8x8")
SND_Frame.separator:SetVertexColor(1, 1, 1, 1)  -- color blanco puro
SND_Frame.separator:SetHeight(2)                -- grosor de 2 píxeles
SND_Frame.separator:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 10, -40)
SND_Frame.separator:SetPoint("TOPRIGHT", SND_Frame, "TOPRIGHT", -10, -40)

-- "Introduce new run:" label
SND_Frame.newRunLabel = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SND_Frame.newRunLabel:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 20, -55)
SND_Frame.newRunLabel:SetText("Introduce new run:")

-- EditBox para introducir el nombre del run
SND_Frame.newRunEditBox = CreateFrame("EditBox", nil, SND_Frame, "InputBoxTemplate")
SND_Frame.newRunEditBox:SetSize(200, 30)
SND_Frame.newRunEditBox:SetPoint("LEFT", SND_Frame.newRunLabel, "RIGHT", 10, 0)
SND_Frame.newRunEditBox:SetAutoFocus(false)
SND_Frame.newRunEditBox:SetMaxLetters(64)
SND_Frame.newRunEditBox:SetText("")

-- Botón OK
SND_Frame.okButton = CreateFrame("Button", nil, SND_Frame, "UIPanelButtonTemplate")
SND_Frame.okButton:SetSize(40, 24)
SND_Frame.okButton:SetPoint("LEFT", SND_Frame.newRunEditBox, "RIGHT", 10, 0)
SND_Frame.okButton:SetText("OK")

-- Etiqueta "My runs:"
SND_Frame.myRunsLabel = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SND_Frame.myRunsLabel:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 20, -95)
SND_Frame.myRunsLabel:SetText("My runs:")

-- Frame para mostrar la lista de runs
SND_Frame.runsList = {}

local function UpdateRunsList()
    -- Borrar entradas anteriores
    for i, fontString in ipairs(SND_Frame.runsList) do
        fontString:Hide()
        fontString:SetText("")
    end

    if not SND_DB then SND_DB = {} end
    local i = 1
    for runName, _ in pairs(SND_DB) do
        if not SND_Frame.runsList[i] then
            SND_Frame.runsList[i] = SND_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            SND_Frame.runsList[i]:SetPoint("TOPLEFT", SND_Frame, "TOPLEFT", 40, -95 - i * 20)
        end
        SND_Frame.runsList[i]:SetText(i .. ". " .. runName)
        SND_Frame.runsList[i]:Show()
        i = i + 1
    end
end

-- Guardar en SND_DB y refrescar la lista al pulsar OK
SND_Frame.okButton:SetScript("OnClick", function()
    local runName = SND_Frame.newRunEditBox:GetText()
    if runName ~= "" then
        if not SND_DB then SND_DB = {} end
        if not SND_DB[runName] then
            SND_DB[runName] = { attempts = 0 }
            print("|cffffff00[Still No Drop]|r New run added: |cff00ff00" .. runName .. "|r")
            SND_Frame.newRunEditBox:SetText("")
            UpdateRunsList()
        else
            print("|cffffcc00[Still No Drop]|r That run already exists!")
        end
    else
        print("|cffff0000[Still No Drop]|r Please enter a name!")
    end
end)

-- Close button (X)
local close = CreateFrame("Button", nil, SND_Frame, "UIPanelCloseButton")
close:SetSize(24, 24)
close:SetPoint("TOPRIGHT", SND_Frame, "TOPRIGHT", -5, -5)
close:SetScript("OnClick", function() SND_Frame:Hide() end)

-- Hide on load and update runs list when opening
SND_Frame:Hide()
SND_Frame:SetScript("OnShow", UpdateRunsList)

-- Asegúrate de tener la tabla guardada aunque /reload
if not SND_DB then SND_DB = {} end