local recoltPoints = {}
AddRemoteEvent("recolt", function(player)
    if GetPlayerPropertyValue(player, "harvesting") == false then
        local x, y, z = GetPlayerLocation(player)
        for i, recoltPoint in ipairs(RecoltData) do
            if GetDistance2D(x, y, recoltPoint.x, recoltPoint.y) < tonumber(recoltPoint.radius) then
                SetPlayerPropertyValue(player, "harvesting", true)
                SetPlayerAnimation(player, "PICKUP_LOWER")
                local count = 0
                local RecoltItem = {}
                RecoltItem.itemId = recoltPoint.itemId
                RecoltItem.itemCount = recoltPoint.count
                RecoltItem.var = {}
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
