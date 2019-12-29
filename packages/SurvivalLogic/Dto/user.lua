local UserData = {}

--[[ function UpdatePlayer(x, y, z, player)
	print("update from dto")
	local requette = mariadb_prepare(Sql, "UPDATE comptes SET positionX = '?', positionY = '?', positionZ = '?',eat = '?',drink = '?', health = '?' WHERE SteamId = '?';",
										x, y, z,
										UserData[tostring(GetPlayerSteamId(player))].eat, UserData[tostring(GetPlayerSteamId(player))].drink, GetPlayerHealth(player),
										tostring(GetPlayerSteamId(player)))
	UserData[tostring(GetPlayerSteamId(player))].positionX = x
	UserData[tostring(GetPlayerSteamId(player))].positionY = y
	UserData[tostring(GetPlayerSteamId(player))].positionZ = z
	UserData[tostring(GetPlayerSteamId(player))].health = GetPlayerHealth(player)
	mariadb_query(Sql, requette)
end
AddFunctionExport("UpdatePlayer", UpdatePlayer) ]]

function GetAllUsers()
	local result = mariadb_await_query(Sql, "SELECT * FROM comptes ORDER BY id ASC")

    local rows = mariadb_get_row_count()
	for i=1, rows do
		local id = mariadb_get_value_name(i, "")
		UserData[mariadb_get_value_name(i, "SteamId")] = {	id = mariadb_get_value_name(i, "id"),
						nom = mariadb_get_value_name(i, "nom"),
						prenom = mariadb_get_value_name(i, "prenom"),
						admin = mariadb_get_value_name(i, "admin"),
						steamId = mariadb_get_value_name(i, "SteamId"),
						positionX = mariadb_get_value_name(i, "positionX"),
						positionY = mariadb_get_value_name(i, "positionY"),
						positionZ = mariadb_get_value_name(i, "positionZ"),
						eat = mariadb_get_value_name(i, "eat"),
						drink = mariadb_get_value_name(i, "drink"),
						health = mariadb_get_value_name(i, "health")}
	end
	mariadb_delete_result(result)
	return UserData
end
AddFunctionExport("GetAllUsers", GetAllUsers)

function GetUserBySteamId(steamId)
	local query = mariadb_prepare(Sql, "SELECT id, nom, prenom, admin, SteamId, positionX, positionY, positionZ, eat, drink, health FROM comptes WHERE SteamId = '?';", steamId)
	local result = mariadb_await_query(Sql, query)

	local User
    local rows = mariadb_get_row_count()
	for i=1, rows do
		User = {	id = mariadb_get_value_name(i, "id"),
						nom = mariadb_get_value_name(i, "nom"),
						prenom = mariadb_get_value_name(i, "prenom"),
						admin = mariadb_get_value_name(i, "admin"),
						steamId = mariadb_get_value_name(i, "SteamId"),
						positionX = mariadb_get_value_name(i, "positionX"),
						positionY = mariadb_get_value_name(i, "positionY"),
						positionZ = mariadb_get_value_name(i, "positionZ"),
						eat = mariadb_get_value_name(i, "eat"),
						drink = mariadb_get_value_name(i, "drink"),
						health = mariadb_get_value_name(i, "health")}
	end
	mariadb_delete_result(result)
	return User
end
AddFunctionExport("GetUserBySteamId", GetUserBySteamId)

function UpdateUser(user)
	local query = mariadb_prepare(Sql, "UPDATE comptes SET nom='?',prenom='?',positionX='?',positionY='?',positionZ='?',eat='?',drink='?',health='?' WHERE SteamId = '?'",
											user.nom, user.prenom, user.positionX, user.positionY, user.positionZ, user.eat, user.drink, user.health, user.SteamId)
	mariadb_query(Sql, query)
end
AddFunctionExport("UpdateUser", UpdateUser)