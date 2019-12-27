AddEvent("OnPlayerSteamAuth",function (player)
    for i, user in ipairs(UserData) do
		if user.steamId == tostring(GetPlayerSteamId(player)) then
			return
		end
    end
    print("new player "..user.steamId)
    CallRemoteEvent(player, "DisplayCreateCharacter")
end)

AddEvent("OnPlayerJoin", function(player)
	if UserData[player] == nil then
		SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
	else
		SetPlayerSpawnLocation(player, UserData[player].positionX, UserData[player].positionY, UserData[player].positionZ, 90.0)
		SetPlayerHealth(player, UserData[player].health)
	end
end)

AddEvent("OnPlayerDeath", function(player, instigator)
	SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
end)

AddEvent("OnPlayerQuit", function(player)
	local x, y, z = GetPlayerLocation(player)
	UpdatePlayer(x, y, z + 15, player)
end)

--TODO A faire coterDTO
function UpdatePlayer(x, y, z, player)
	local requette = mariadb_prepare(sql, "UPDATE comptes SET positionX = '?', positionY = '?', positionZ = '?',eat = '?',drink = '?', health = '?' WHERE SteamId = '?';",
										x, y, z,
										UserData[player].eat, UserData[player].drink, GetPlayerHealth(player),
										tostring(GetPlayerSteamId(player)))
	UserData[player].positionX = x
	UserData[player].positionY = y
	UserData[player].positionZ = z
	UserData[player].health = GetPlayerHealth(player)
	mariadb_query(sql, requette)
end