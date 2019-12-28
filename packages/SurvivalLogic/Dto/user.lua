local UserData = {}

function UpdatePlayer(x, y, z, player)
	print("update from dto")
	local requette = mariadb_prepare(sql, "UPDATE comptes SET positionX = '?', positionY = '?', positionZ = '?',eat = '?',drink = '?', health = '?' WHERE SteamId = '?';",
										x, y, z,
										UserData[tostring(GetPlayerSteamId(player))].eat, UserData[tostring(GetPlayerSteamId(player))].drink, GetPlayerHealth(player),
										tostring(GetPlayerSteamId(player)))
	UserData[tostring(GetPlayerSteamId(player))].positionX = x
	UserData[tostring(GetPlayerSteamId(player))].positionY = y
	UserData[tostring(GetPlayerSteamId(player))].positionZ = z
	UserData[tostring(GetPlayerSteamId(player))].health = GetPlayerHealth(player)
	mariadb_query(sql, requette)
	print("update done !")
end
AddFunctionExport("UpdatePlayer", UpdatePlayer)

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