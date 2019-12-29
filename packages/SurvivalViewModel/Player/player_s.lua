local x,y,z
AddEvent("OnPlayerSteamAuth",function (player)
	UserData[tostring(GetPlayerSteamId(player))] = SLogic.GetUserBySteamId(tostring(GetPlayerSteamId(player)))
	UserData[tostring(GetPlayerSteamId(player))].inventoryItems = SLogic.GetUserInventory(player, UserData[tostring(GetPlayerSteamId(player))].id)
	if UserData[tostring(GetPlayerSteamId(player))] == nil then
		SetPlayerLocation(player, 125773.000000, 80246.000000, 1645.000000)
		print("new player "..GetPlayerSteamId(player))
		CallRemoteEvent(player, "DisplayCreateCharacter")
	else
		SetPlayerLocation(player, UserData[tostring(GetPlayerSteamId(player))].positionX, UserData[tostring(GetPlayerSteamId(player))].positionY, UserData[tostring(GetPlayerSteamId(player))].positionZ)
		SetPlayerHealth(player, UserData[tostring(GetPlayerSteamId(player))].health)
	end
	SetPlayerPropertyValue(player, "harvesting", false)
end)

AddEvent("OnPlayerDeath", function(player, instigator)
	SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
end)

AddEvent("OnPlayerQuit", function(player)
	local x, y, z = GetPlayerLocation(player)
	SLogic.UpdateUser(UserData[tostring(GetPlayerSteamId(player))])
	-- Separ en list inventory items  listonlycreate(weapons) et listcreateorupdate(ressources)
	-- listonlycreate(weapons)
	-- SLogic.SetUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, recoltPoint.itemId, 1)
	-- listcreateorupdate(ressources)
	-- SLogic.UpdateUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, recoltPoint.itemId, item.itemCount + 1)   
	-- avec comme requette "INSERT INTO compte_item (compteId, itemCount, itemId) VALUES (21, 3, 9) ON DUPLICATE KEY UPDATE compteId=21, itemCount = 3, itemId = 9;"
	UserData[tostring(GetPlayerSteamId(player))] = nil
end)