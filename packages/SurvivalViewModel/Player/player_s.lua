local x,y,z
AddEvent("OnPlayerSteamAuth",function (player)
	UserData[tostring(GetPlayerSteamId(player))] = SLogic.GetUserBySteamId(tostring(GetPlayerSteamId(player))) or nil
	if UserData[tostring(GetPlayerSteamId(player))] == nil then
		SetPlayerLocation(player, 125773.000000, 80246.000000, 1755.000000)
		print("new player "..GetPlayerSteamId(player))

		-- On vien set les variables UserData du joueur
		UserData[tostring(GetPlayerSteamId(player))] = {}
		UserData[tostring(GetPlayerSteamId(player))].inventoryItems = {}
		UserData[tostring(GetPlayerSteamId(player))].eat = 100
		UserData[tostring(GetPlayerSteamId(player))].drink = 100
		UserData[tostring(GetPlayerSteamId(player))].health = 100
		UserData[tostring(GetPlayerSteamId(player))].PickupS = false

		-- On affiche le menu de créaction de personnage
		CallRemoteEvent(player, "DisplayCreateCharacter")
	else
		SetPlayerLocation(player, UserData[tostring(GetPlayerSteamId(player))].positionX, UserData[tostring(GetPlayerSteamId(player))].positionY, UserData[tostring(GetPlayerSteamId(player))].positionZ)
		SetPlayerHealth(player, UserData[tostring(GetPlayerSteamId(player))].health)
		UserData[tostring(GetPlayerSteamId(player))].inventoryItems = SLogic.GetUserInventory(player, UserData[tostring(GetPlayerSteamId(player))].id)
	end
	SetPlayerPropertyValue(player, "harvesting", false)
end)

AddEvent("OnPlayerDeath", function(player, instigator)
	SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1755.000000, 90.0)
end)

AddEvent("OnPlayerQuit", function(player)
	-- On vient update les info en cache
	local x, y, z = GetPlayerLocation(player)
	UserData[tostring(GetPlayerSteamId(player))].positionX = x
	UserData[tostring(GetPlayerSteamId(player))].positionY = y
	UserData[tostring(GetPlayerSteamId(player))].positionZ = z+800

	-- On update la base de données
	SLogic.UpdateUser(UserData[tostring(GetPlayerSteamId(player))])

	-- On l'enleve du cache
	UserData[tostring(GetPlayerSteamId(player))] = nil
end)

AddRemoteEvent("InsertPlayer", function(player, firstName, lastName)
	-- Changement des variables require
	UserData[tostring(GetPlayerSteamId(player))].prenom = firstName
	UserData[tostring(GetPlayerSteamId(player))].nom = lastName
	UserData[tostring(GetPlayerSteamId(player))].SteamId = tostring(GetPlayerSteamId(player))

	-- Set de la position du joueur
	local x, y, z = GetPlayerLocation(player)
	UserData[tostring(GetPlayerSteamId(player))].positionX = x
	UserData[tostring(GetPlayerSteamId(player))].positionY = y
	UserData[tostring(GetPlayerSteamId(player))].positionZ = z

	-- Insert dans la base de donnée
	SLogic.InsertNewUser(UserData[tostring(GetPlayerSteamId(player))])
end)