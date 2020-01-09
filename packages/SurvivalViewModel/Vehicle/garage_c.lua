function ReloadVehicles(garageid, vehicles)
    SView.ExecuteJs("garage", 'garage.removeAllVehicles()')
    for k, v in pairs(vehicles) do
        if tonumber(garageid) == tonumber(v.garageid) then
            if v.state == 0 then
                AddVehicle(v)
            end
        end
    end
end

function AddVehicle(v)
    SView.ExecuteJs("garage", 'garage.addVehicle('..v.id..', new Vehicle('..v.id..', "'..v.nom..'", '..v.modelid..','..v.imageid..'))')
end

function RemoveVehicle(v)
    SView.ExecuteJs("garage", 'garage.removeVehicle('..v.id..')')
end

AddRemoteEvent("OpenGarage", function(garageid, vehicles)
    ReloadVehicles(garageid, vehicles)
    RemoveAllHud("garage")
    SView.SetGarageVisibility()
end)