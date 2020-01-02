AddRemoteEvent("OnLoadGarageHud", function(vehicles)
    CallRemoteEvent("UpdateWeight", SView.SetGarageVisibility())
    ReloadGarage(vehicles)
end)

AddEvent("OnKeyRelease", function(key)
    if key == "E" then
        CallRemoteEvent("LoadGarage")
    end
end)

function ReloadGarage(vehicles)
    SView.ExecuteJs("garage", "garage.removeAllVehicles()")
    for i, vehicle in ipairs(vehicles) do 
        AddVehicleGarage(vehicle)
    end
end

function AddVehicleGarage(vehicle)
    SView.ExecuteJs("garage", "garage.addVehicle("..vehicle.id..", new Vehicle("..vehicle.id..", '"..vehicle.nom.."', "..vehicle.modelId..","..vehicle.imageId.."))")
end