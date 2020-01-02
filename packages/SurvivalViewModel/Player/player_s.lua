local x,y,z
AddEvent("OnPlayerSteamAuth",function (player)
	SetPlayerPropertyValue(player, "PlayerIsCharged", false, true)
	UserData[tostring(GetPlayerSteamId(player))] = SLogic.GetUserBySteamId(tostring(GetPlayerSteamId(player))) or nil
	if UserData[tostring(GetPlayerSteamId(player))] == nil then
		SetPlayerLocation(player, p_spawn.x, p_spawn.y, p_spawn.z)
		print("new player "..GetPlayerSteamId(player))

		-- On vien set les variables UserData du joueur
		UserData[tostring(GetPlayerSteamId(player))] = {}
		UserData[tostring(GetPlayerSteamId(player))].inventoryItems = {}
		UserData[tostring(GetPlayerSteamId(player))].Vehicles = {}
		UserData[tostring(GetPlayerSteamId(player))].eat = p_defaulthunger
		UserData[tostring(GetPlayerSteamId(player))].drink = p_defaultthirst
		UserData[tostring(GetPlayerSteamId(player))].health = p_defaulthealth
		UserData[tostring(GetPlayerSteamId(player))].argent = p_defaultargent
		UserData[tostring(GetPlayerSteamId(player))].clothing = p_defaultclothing
		UserData[tostring(GetPlayerSteamId(player))].SteamId = tostring(GetPlayerSteamId(player))
		UserData[tostring(GetPlayerSteamId(player))].admin = 0
		UserData[tostring(GetPlayerSteamId(player))].PickupS = false

		-- On affiche le menu de créaction de personnage
		CallRemoteEvent(player, "DisplayCreateCharacter", p_defaultclothing)
	else
		SetPlayerLocation(player, UserData[tostring(GetPlayerSteamId(player))].positionX, UserData[tostring(GetPlayerSteamId(player))].positionY, UserData[tostring(GetPlayerSteamId(player))].positionZ)
		SetPlayerHealth(player, UserData[tostring(GetPlayerSteamId(player))].health)
		UserData[tostring(GetPlayerSteamId(player))].inventoryItems = SLogic.GetUserInventory(player, UserData[tostring(GetPlayerSteamId(player))].id)
		UserData[tostring(GetPlayerSteamId(player))].Vehicles = SLogic.GetUserVehicle(player, UserData[tostring(GetPlayerSteamId(player))].id)
		CallRemoteEvent(player, "SetPlayerClothing", UserData[tostring(GetPlayerSteamId(player))].clothing)
		UpdateWeight(player)
		SetPlayerPropertyValue(player, "PlayerIsCharged", true, true)	
	end
	SetPlayerPropertyValue(player, "harvesting", false)
end)

AddEvent("OnPlayerDeath", function(player, instigator)
	SetPlayerSpawnLocation(player, p_spawn.x, p_spawn.y, p_spawn.z, 90.0)
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

AddRemoteEvent("InsertPlayer", function(player, firstName, lastName, clothing)
	-- Changement des variables require
	UserData[tostring(GetPlayerSteamId(player))].prenom = firstName
	UserData[tostring(GetPlayerSteamId(player))].nom = lastName
	UserData[tostring(GetPlayerSteamId(player))].clothing = math.floor(clothing)

	CallRemoteEvent(player, "SetPlayerClothing", math.floor(clothing))

	-- Set de la position du joueur
	local x, y, z = GetPlayerLocation(player)
	UserData[tostring(GetPlayerSteamId(player))].positionX = x
	UserData[tostring(GetPlayerSteamId(player))].positionY = y
	UserData[tostring(GetPlayerSteamId(player))].positionZ = z+800

	-- Insert dans la base de donnée
	SLogic.InsertNewUser(UserData[tostring(GetPlayerSteamId(player))])
	Delay(500, function()
		UserData[tostring(GetPlayerSteamId(player))] = SLogic.GetUserBySteamId(UserData[tostring(GetPlayerSteamId(player))].SteamId)
		UserData[tostring(GetPlayerSteamId(player))].inventoryItems = {}
		SetPlayerPropertyValue(player, "PlayerIsCharged", true, true)
	end)
	
end)