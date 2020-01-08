AddRemoteEvent("Harvesting", function(player)
    if GetPlayerPropertyValue(player, "harvesting") == false then
        local x, y, z = GetPlayerLocation(player)
        for i, recoltPoint in pairs(r_Points) do
            local itemData = GetItemDataByItemID(recoltPoint.itemId)
            if itemData ~= 0 and GetDistance2D(x, y, recoltPoint.x, recoltPoint.y) < tonumber(recoltPoint.radius) then
                SetPlayerPropertyValue(player, "harvesting", true)
                SetPlayerAnimation(player, "PICKUP_LOWER")
                local RecoltItem = {}
                RecoltItem = {
                    nom = itemData.nom,
                    poids = tonumber(itemData.poids),
                    type = itemData.type,
                    imageId = tonumber(itemData.imageId),
                    modelId = tonumber(itemData.modelId),
                    compteId = tonumber(PlayerData[player].id),
                    itemId = tonumber(itemData.id),
                    maxStack = tonumber(itemData.maxStack),
                    isstackable = itemData.isstackable,
                    value = tonumber(itemData.value),
                    itemCount = tonumber(recoltPoint.count),
                    var = "[]",
                }
                local count = 0
                CreateCountTimer(function()
                    count = count + 1
                    if count == 3 then
                        PickupItem(player, RecoltItem)
                        SetPlayerPropertyValue(player, "harvesting", false)
                    end
                    SetPlayerAnimation(player, "PICKUP_LOWER")
                end, '3000' , 3)
                return
            end
        end
    end
end)