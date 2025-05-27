local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "StillNoDrop" then
        print("|cff00ff00[StillNoDrop]|r Loaded successfully. Type |cffffff00/snd|r to open the addon.")
    end
end)

SLASH_SND1 = "/snd"
SlashCmdList["SND"] = function()
    if SND and SND.ToggleUI then
        SND:ToggleUI()
    else
        print("|cffff0000[Still No Drop]|r Error: UI module not loaded.")
    end
end