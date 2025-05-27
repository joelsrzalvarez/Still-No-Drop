SLASH_SND1 = "/snd"
SlashCmdList["SND"] = function()
    if SND and SND.ToggleUI then
        SND:ToggleUI()
    else
        print("|cffff0000[Still No Drop]|r Error: UI module not loaded.")
    end
end
