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

function ShowClassicGear()
    print("Mostrando gear de Classic")
end

function ShowTBCGear()
    print("Mostrando gear de TBC")
end

function ShowWotLKGear()
    print("Mostrando gear de Wotlk")
end

function ClearGearBox()
    print("Limpiando GearBox")
end
