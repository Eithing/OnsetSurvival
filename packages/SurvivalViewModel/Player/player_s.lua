local x,y,z
AddEvent("OnPlayerSteamAuth",function (player)
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
	print("try update")
	SLogic.UpdatePlayer(x, y, (z + 15), player)
end)