SLASH_SND1 = "/snd"
SlashCmdList["SND"] = function()
    local frame = _G["SND_Frame"]
    if frame then
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
        end
    else
        print("|cffff0000[Still No Drop]|r Error: frame not found.")
    end
end
