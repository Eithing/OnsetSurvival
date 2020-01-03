AddRemoteEvent("OnOpenGarage", function(player, garage)
    print("OnOpenGarage")
    local x, y, z = GetPlayerLocation(player)
    local NearestGarageDealer = GetNearestZone("g_Points", x, y, z)
    if NearestGarageDealer.id == garage.id then 
        CallRemoteEvent("OpenGarage", garage.id, PlayerData[player].vehicles)
        return
    end
end)