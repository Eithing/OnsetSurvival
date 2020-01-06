function OnUpdateFuel(fuel)
	SView.ExecuteJs("vehicle", "UpdateFuel("..fuel..")")
end
AddRemoteEvent("OnUpdateFuel",  OnUpdateFuel)

AddRemoteEvent("OnUpdateVehicleHud", function()
    CallRemoteEvent("UpdateWeight", SView.SetVehicleVisibility())
end)

function OnPlayerStartEnterVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") == true then 
        AddNotification("Véhicule verrouillé !", "error", 10)
        return false 
    end 
end
AddEvent("OnPlayerStartEnterVehicle", OnPlayerStartEnterVehicle)

function OnPlayerStartExitVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") == true then 
        AddNotification("Véhicule verrouillé !", "error", 10)
        return false 
    end 
end
AddEvent("OnPlayerStartExitVehicle", OnPlayerStartExitVehicle)