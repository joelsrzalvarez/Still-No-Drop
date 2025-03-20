-- Definir la función global
function ShowGearForVersion(version)
    if version == "Classic" then
        ShowClassicGear()
    elseif version == "TBC" then
        ShowTBCGear() 
    elseif version == "WotLK" then
        ShowWotLKGear()  
    else
        ClearGearBox()
    end
end

-- Función para mostrar el gear de Classic
function ShowClassicGear()
    print("Mostrando gear de Classic")
    
    -- Limpiar el GearBox antes de llenarlo con los nuevos botones
    ClearGearBox()

    -- Categorías de equipo de WoW Classic
    local equipmentSlots = {
        {name = "Cabeza", type = "head"},
        {name = "Hombros", type = "shoulder"},
        {name = "Pechera", type = "chest"},
        {name = "Cintura", type = "waist"},
        {name = "Piernas", type = "legs"},
        {name = "Pies", type = "feet"},
        {name = "Muñeca", type = "wrist"},
        {name = "Manos", type = "hands"},
        {name = "Anillo", type = "finger"},
        {name = "Accesorio", type = "trinket"},
        {name = "Cloak", type = "back"},
        {name = "Arma", type = "mainhand"},
        {name = "Arma secundaria", type = "offhand"}
    }
    
    -- Mostrar objetos de cada categoría
    for i, slot in ipairs(equipmentSlots) do
        local button = CreateFrame("Button", "GearButton" .. i, GearBox, "UIPanelButtonTemplate")
        button:SetSize(180, 40)
        button:SetPoint("TOP", GearBox, "TOP", 0, -30 - (i - 1) * 50)
        button:SetText(slot.name)
        
        button:SetScript("OnClick", function()
            ShowItemsForSlot(slot.type)
        end)
    end
end

-- Función para mostrar los objetos de una categoría específica
function ShowItemsForSlot(slotType)
    -- Aquí utilizarías la API de WoW para obtener los objetos de la categoría
    -- Aquí hay un ejemplo básico usando un array de objetos ficticios
    -- Para obtener objetos reales, necesitarás acceder a las bases de datos del juego de alguna manera
    local items = GetItemsForSlotType(slotType)  -- Necesitas implementar esta función

    -- Limpiar el GearBox para evitar la superposición de los objetos
    ClearGearBox()

    -- Mostrar los objetos
    for i, item in ipairs(items) do
        local itemButton = CreateFrame("Button", "ItemButton" .. i, GearBox, "UIPanelButtonTemplate")
        itemButton:SetSize(180, 40)
        itemButton:SetPoint("TOP", GearBox, "TOP", 0, -30 - (i - 1) * 50)
        itemButton:SetText(item.name)

        -- Al hacer clic en el botón del objeto
        itemButton:SetScript("OnClick", function()
            EquipItem(item)  -- Función que quieres para equipar el objeto, si lo deseas
        end)
    end
end

-- Función que obtiene los objetos de una categoría específica (esto es solo un ejemplo)
function GetItemsForSlotType(slotType)
    -- Aquí deberías usar la API de WoW para obtener los objetos de una categoría (por ejemplo, de la base de datos de objetos)
    -- Este es un ejemplo ficticio con nombres de objetos ficticios
    local items = {
        {name = "Casco de Tela", id = 12345},
        {name = "Capucha de Cuero", id = 12346},
        {name = "Armadura de Placas", id = 12347}
    }

    return items
end

-- Limpiar GearBox
function ClearGearBox()
    -- Limpiar todos los botones previos
    for i = 1, #GearBox:GetChildren() do
        local child = select(i, GearBox:GetChildren())
        child:Hide()
    end
end

-- Equipar un item (esto es solo un ejemplo, implementa la lógica según lo que necesitas hacer)
function EquipItem(item)
    print("Equipping item: " .. item.name)
    -- Aquí puedes poner la lógica para equipar el objeto
end


function ShowTBCGear()
    print("Mostrando gear de TBC")
    -- Aquí iría la lógica para mostrar los objetos de TBC
end

function ShowWotLKGear()
    print("Mostrando gear de Wotlk")
    -- Aquí iría la lógica para mostrar los objetos de WotLK
end
