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
                                SLogic.UpdateUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, recoltPoint.itemId, item.itemCount + 1)
                                UserData[tostring(GetPlayerSteamId(player))].inventoryItems[i].itemCount = math.floor(item.itemCount + 1)
                                CallRemoteEvent(player, "ReloadInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
                                SetPlayerPropertyValue(player, "harvesting", false)
                                return
                            end
                        end
                        local itemInventory = SLogic.SetUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, recoltPoint.itemId, 1)
                        table.insert(UserData[tostring(GetPlayerSteamId(player))].inventoryItems, itemInventory)
                        CallRemoteEvent(player, "ReloadInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
                        SetPlayerPropertyValue(player, "harvesting", false)
                    end
                    SetPlayerAnimation(player, "PICKUP_LOWER")
                end, '3000' , 3)
                return
            end
        end
    end
end)
