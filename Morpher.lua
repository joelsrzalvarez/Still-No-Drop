SLASH_MORPHER1 = "/morpher"
SlashCmdList["MORPHER"] = function()
    local frame = _G["MorpherFrame"]
    if frame then
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
        end
    else
        print("Error: MorpherFrame no ha sido cargado correctamente.")
    end
end
