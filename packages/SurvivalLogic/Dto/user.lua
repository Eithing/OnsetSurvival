local UserData = {}

function GetAllUsers()
	local result = mariadb_await_query(Sql, "SELECT * FROM comptes ORDER BY id ASC")

    local rows = mariadb_get_row_count()
	for i=1, rows do
		local id = mariadb_get_value_name(i, "")
		UserData[mariadb_get_value_name(i, "SteamId")] = {	id = mariadb_get_value_name(i, "id"),
						nom = mariadb_get_value_name(i, "nom"),
						prenom = mariadb_get_value_name(i, "prenom"),
						admin = mariadb_get_value_name(i, "admin"),
						SteamId = mariadb_get_value_name(i, "SteamId"),
						positionX = mariadb_get_value_name(i, "positionX"),
						positionY = mariadb_get_value_name(i, "positionY"),
						positionZ = mariadb_get_value_name(i, "positionZ"),
						clothing = mariadb_get_value_name(i, "clothing"),
						argent = mariadb_get_value_name(i, "argent"),
						eat = mariadb_get_value_name(i, "eat"),
						drink = mariadb_get_value_name(i, "drink"),
						health = mariadb_get_value_name(i, "health")}
	end
	mariadb_delete_result(result)
	return UserData
end
AddFunctionExport("GetAllUsers", GetAllUsers)

function GetUserBySteamId(steamId)
	local query = mariadb_prepare(Sql, "SELECT * FROM comptes WHERE SteamId = '?';", steamId)
	local result = mariadb_await_query(Sql, query)

	local User
    local rows = mariadb_get_row_count()
	for i=1, rows do
		User = {	id = mariadb_get_value_name(i, "id"),
						nom = mariadb_get_value_name(i, "nom"),
						prenom = mariadb_get_value_name(i, "prenom"),
						admin = mariadb_get_value_name(i, "admin"),
						SteamId = mariadb_get_value_name(i, "SteamId"),
						positionX = mariadb_get_value_name(i, "positionX"),
						positionY = mariadb_get_value_name(i, "positionY"),
						positionZ = mariadb_get_value_name(i, "positionZ"),
						clothing = mariadb_get_value_name(i, "clothing"),
						argent = mariadb_get_value_name(i, "argent"),
						eat = mariadb_get_value_name(i, "eat"),
						drink = mariadb_get_value_name(i, "drink"),
						health = mariadb_get_value_name(i, "health")}
	end
	mariadb_delete_result(result)
	return User
end
AddFunctionExport("GetUserBySteamId", GetUserBySteamId)

function UpdateUser(user)
	print(user.nom, user.prenom, user.admin, user.positionX, user.positionY, user.positionZ, user.clothing, user.argent, user.eat, user.drink, user.health, user.SteamId)
	local query = mariadb_prepare(Sql, "UPDATE comptes SET nom='?',prenom='?',admin='?',positionX='?',positionY='?',positionZ='?',clothing='?',argent='?',eat='?',drink='?',health='?' WHERE SteamId = '?'",
											user.nom, user.prenom, user.admin, user.positionX, user.positionY, user.positionZ, user.clothing, user.argent, user.eat, user.drink, user.health, user.SteamId)
	local result = mariadb_query(Sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("UpdateUser", UpdateUser)

function InsertNewUser(user)
	local query = mariadb_prepare(Sql, "INSERT INTO comptes(nom, prenom, clothing, argent, SteamId, positionX, positionY, positionZ, eat, drink, health) VALUES ('?','?','?','?','?','?','?','?','?','?','?')",
											user.nom, user.prenom, user.clothing, user.argent, user.SteamId, user.positionX, user.positionY, user.positionZ, user.eat, user.drink, user.health)
	local result = mariadb_query(Sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("InsertNewUser", InsertNewUser)