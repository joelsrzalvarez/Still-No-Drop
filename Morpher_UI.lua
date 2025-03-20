local MorpherFrame = CreateFrame("Frame", "MorpherFrame", UIParent)
MorpherFrame:SetSize(900, 600)
MorpherFrame:SetPoint("CENTER")
MorpherFrame:SetMovable(true)
MorpherFrame:EnableMouse(true)
MorpherFrame:RegisterForDrag("LeftButton")
MorpherFrame:SetScript("OnDragStart", MorpherFrame.StartMoving)
MorpherFrame:SetScript("OnDragStop", MorpherFrame.StopMovingOrSizing)

MorpherFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})

MorpherFrame.title = MorpherFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
MorpherFrame.title:SetPoint("TOP", MorpherFrame, "TOP", 0, -10)
MorpherFrame.title:SetText("Morpher")

local CloseButton = CreateFrame("Button", "CloseButton", MorpherFrame, "UIPanelButtonTemplate")
CloseButton:SetSize(25, 25) 
CloseButton:SetPoint("TOPRIGHT", MorpherFrame, "TOPRIGHT", -10, -10) 
CloseButton:SetText("X") 

CloseButton:SetScript("OnClick", function()
    MorpherFrame:Hide()
end)

local VersionsBox = CreateFrame("Frame", "VersionsBox", MorpherFrame)
VersionsBox:SetSize(200, 560)
VersionsBox:SetPoint("TOPLEFT", MorpherFrame, "TOPLEFT", 10, -30)
VersionsBox:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 6, right = 6, top = 6, bottom = 6 }
})
VersionsBox.title = VersionsBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
VersionsBox.title:SetPoint("TOP", VersionsBox, "TOP", 0, 12)
VersionsBox.title:SetText("Versions")

local GearBox = CreateFrame("Frame", "GearBox", MorpherFrame)
GearBox:SetSize(680, 560)
GearBox:SetPoint("TOPRIGHT", MorpherFrame, "TOPRIGHT", -10, -30)
GearBox:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 6, right = 6, top = 6, bottom = 6 }
})

local versions = {"Classic", "TBC", "WotLK"} 
for i, version in ipairs(versions) do
    local button = CreateFrame("Button", "VersionButton" .. i, VersionsBox, "UIPanelButtonTemplate")
    button:SetSize(180, 40)
    button:SetPoint("TOP", VersionsBox, "TOP", 0, -30 - (i - 1) * 50)
    button:SetText(version)

    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\White8x8", 
        tile = false,
    })
    button:SetBackdropColor(0, 0, 0, 0) 

    button:SetScript("OnClick", function(self)
        for _, v in ipairs(versions) do
            local btn = _G["VersionButton" .. _]
            btn:SetBackdropColor(0, 0, 0, 0) 
        end

        self:SetBackdropColor(0.5, 0.5, 0.5, 1)  
        
        lastSelectedButton = self

        ShowGearForVersion(version)
    end)
end

MorpherFrame:Hide()

_G["MorpherFrame"] = MorpherFrame
