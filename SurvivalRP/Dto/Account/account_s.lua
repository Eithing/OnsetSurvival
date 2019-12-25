InventoryItems = {}

AddRemoteEvent("InsertPlayer", function(player, name, surname)
	local x, y, z = GetPlayerLocation(player)
	local requette = mariadb_prepare(	sql, 
										"INSERT INTO comptes (`SteamId`, `nom`, `prenom`, `admin`, `positionX`, `positionY`, `positionZ`, `eat`, `drink`) VALUES ('?','?','?','?','?','?','?','?','?');",
										tostring(GetPlayerSteamId(player)),
										name,surname,
										0,x,y,z,100,100)
	for i, user in ipairs(UserData) do
		if user.steamId == tostring(GetPlayerSteamId(player)) then
			return
		end
	end
	if tostring(GetPlayerSteamId(player)) == "0" or tostring(GetPlayerSteamId(player)) == nil then
		ServerExit()
	else
		mariadb_query(sql, requette)
		UserData[player].nom = name
		UserData[player].prenom = surname
		UserData[player].admin = 0
		UserData[player].steamId = tostring(GetPlayerSteamId(player))
		UserData[player].positionX = x
		UserData[player].positionY = y
		UserData[player].positionZ = z
		UserData[player].eat = 100
		UserData[player].drink = 100
		UserData[player].health = 100
	end
end)

AddEvent("OnPlayerJoin", function(player)
	if UserData[player] == nil then
		SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
	else
		SetPlayerSpawnLocation(player, UserData[player].positionX, UserData[player].positionY, UserData[player].positionZ, 90.0)
		SetPlayerHealth(player, UserData[player].health)
		GetUserInventory(player)
	end
end)

AddEvent("OnPlayerDeath", function(player, instigator)
	SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
end)

AddEvent("OnPlayerQuit", function(player)
	local x, y, z = GetPlayerLocation(player)
	UpdatePlayer(x, y, z + 15, player)
end)

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

function GetUserInventory(player)
	local inventoryRequest = mariadb_prepare(sql, "SELECT * FROM items INNER JOIN compte_item ON items.id = compte_item.itemid WHERE compte_item.compteId = '?';", UserData[player].id)
	mariadb_query(sql, inventoryRequest, function()
		local rows = mariadb_get_row_count()
		for i=1, rows do
			local id = mariadb_get_value_name(i, "")
			InventoryItems[i] = {id = mariadb_get_value_name(i, "id"),
								nom = mariadb_get_value_name(i, "nom"),
								poids = mariadb_get_value_name(i, "poids"),
								type = mariadb_get_value_name(i, "type"),
								imageId = mariadb_get_value_name(i, "imageId"),
								itemCount = mariadb_get_value_name(i, "itemCount"),
								compteId = mariadb_get_value_name(i, "compteId"),
								itemId = mariadb_get_value_name(i, "itemId")}
		end
		

		UserData[player].inventoryItems = InventoryItems
		--[[ GET INVENTORY FOR PLAYER
			for i, inventoryItems in ipairs(UserData[player].inventoryItems) do
			if inventoryItems.compteId == UserData[player].id then
				print(inventoryItems.itemId)
			end
		end ]]
	end)
end