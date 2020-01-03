function OnKeyPress(key)
    if key == "E" then
        local x, y, z = GetPlayerLocation()
        local NearestGarage = GetNearestZone(g_Points, x, y, z)
        if NearestGarage ~= 0 then 
            AddPlayerChat("OnKeyPress")
            CallRemoteEvent("OnOpenGarage", NearestGarage)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddRemoteEvent("OpenGarage", function(garageid, vehicles)
    ReloadVehicles(garageid, vehicles)
    SView.SetGarageVisibility()
end)

function ReloadVehicles(garageid, vehicles)
    SView.ExecuteJs("garage", 'garage.removeAllVehicles()')
    for k, v in pairs(vehicles) do
        if(garageid == v.garageid)then
            AddVehicle(v)
        end
    end
end

function AddVehicle(v)
    SView.ExecuteJs("garage", 'garage.addVehicle('..v.id..', new Vehicle('..v.id..', "'..v.nom..'", '..v.modelId..','..v.imageId..'))')
end

function RemoveVehicle(v)
    SView.ExecuteJs("garage", 'garage.removeVehicle('..v.id..')')
end