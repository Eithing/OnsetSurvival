AddRemoteEvent("LoadGarage", function(player)
    local x, y, z = GetPlayerLocation(player)
    for i, garagePoint in pairs(GarageData) do
        --print(garagePoint.nom, garagePoint.x, garagePoint.y, garagePoint.radius)
        --print(x, y)
        if GetDistance3D(x, y, z, garagePoint.x, garagePoint.y, z) < tonumber(garagePoint.radius) then
            CallRemoteEvent(player, "OnLoadGarageHud", UserData[tostring(GetPlayerSteamId(player))].Vehicles)
            break
        end
    end
end)

AddRemoteEvent("SpawnVehicle", function(player, idUnique)
    local x, y, z = GetPlayerLocation(player)
    local userVehicles = UserData[tostring(GetPlayerSteamId(player))].Vehicles
    for i, vehicle in pairs(userVehicles) do
        if(vehicle.id == idUnique)then
            print(vehicle.nom, vehicle.id.." - "..idUnique)
            break
        end
    end
end)