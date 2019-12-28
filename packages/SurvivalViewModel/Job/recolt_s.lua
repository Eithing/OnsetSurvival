local recoltPoints = {}
AddRemoteEvent("recolt", function(player)
    if GetPlayerPropertyValue(player, "harvesting") == false then
        local x, y, z = GetPlayerLocation(player)
        for i, recoltPoint in ipairs(RecoltData) do
            if GetDistance2D(x, y, recoltPoint.x, recoltPoint.y) < tonumber(recoltPoint.radius) then
                SetPlayerPropertyValue(player, "harvesting", true)
                SetPlayerAnimation(player, "PICKUP_LOWER")
                local count = 0
                CreateCountTimer(function()
                    count = count + 1
                    if count == 3 then
                        for i, item in ipairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
                            if item.itemId == recoltPoint.itemId then
                                --TODO uech t'es arriver ici fait lpas le con
                                UserData[tostring(GetPlayerSteamId(player))].inventoryItems[i].itemCount = item.itemCount + 1
                                SLogic.UpdateUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, recoltPoint.itemId, item.itemCount + 1)
                                return
                            end
                        end
                    end
                    SetPlayerAnimation(player, "PICKUP_LOWER")
                end, '3000' , 3)
                return
            end
        end
    end
end)
