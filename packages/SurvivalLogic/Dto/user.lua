function GetUserBySteamId(player)
    local query = mariadb_prepare(sql, "SELECT * FROM comptes WHERE steamid = '?' LIMIT 1;", GetPlayerSteamId(player))
    local result = mariadb_await_query(sql, query)
    local User
    local rows = mariadb_get_row_count()
	for i=1, rows do
		User = {	id = mariadb_get_value_name(i, "id"),
						name = mariadb_get_value_name(i, "nom"),
						admin = mariadb_get_value_name(i, "admin"),
						steamid = mariadb_get_value_name(i, "steamid"),
						position = mariadb_get_value_name(i, "position"),
						armor = mariadb_get_value_name(i, "armor"),
						created = mariadb_get_value_name(i, "created"),
                        clothing = mariadb_get_value_name(i, "clothing"),
                        inventory = mariadb_get_value_name(i, "inventory"),
						argent = mariadb_get_value_name(i, "argent"),
						hunger = mariadb_get_value_name(i, "hunger"),
						thirst = mariadb_get_value_name(i, "thirst"),
						health = mariadb_get_value_name(i, "health")}
	end
	mariadb_delete_result(result)
	return rows, User
end
AddFunctionExport("GetUserBySteamId", GetUserBySteamId)

function UpdateUser(player, user)
    print(user.admin,
    user.argent,
    100,
    GetPlayerArmor(player),
    user.hunger,
    user.thirst,
    user.name,
    json_encode(user.clothing),
    json_encode(user.inventory),
    user.created,
    json_encode(user.position),
    user.steamid,
    user.id)
	local query = mariadb_prepare(sql, "UPDATE comptes SET admin = ?, argent = ?, health = ?,  armor = ?, hunger = ?, thirst = ?, nom = '?', clothing = '?', inventory = '?', created = '?', position = '?', steamid = '?' WHERE id = ? LIMIT 1;",
        user.admin,
        user.argent,
		100,
		GetPlayerArmor(player),
		user.hunger,
		user.thirst,
		user.name,
		json_encode(user.clothing),
		json_encode(user.inventory),
		user.created,
        json_encode(user.position),
        user.steamid,
		user.id
	)
    mariadb_query(sql, query)
end
AddFunctionExport("UpdateUser", UpdateUser)

function InsertNewUser(player)
    local query = mariadb_prepare(sql, "INSERT INTO comptes (id, admin, argent, health,  armor, hunger, thirst, nom, clothing, inventory, created, position, steamid) VALUES (NULL, 0, 0, 100, 0, 100, 100, '', '[]', '[]', 0, '[]', '?');",
		GetPlayerSteamId(player))
    mariadb_await_query(sql, query)
    return mariadb_get_insert_id()
end
AddFunctionExport("InsertNewUser", InsertNewUser)

function GetBanIp(ip)
    local query = mariadb_prepare(sql, "SELECT * FROM ipbans WHERE ipbans.ip = '?' LIMIT 1;", ip)
    local result = mariadb_await_query(sql, query)
    local User
    local rows = mariadb_get_row_count()
	for i=1, rows do
		User = {	id = mariadb_get_value_name(i, "id"),
						ip = mariadb_get_value_name(i, "ip"),
						reason = mariadb_get_value_name(i, "reason"),
						date = mariadb_get_value_name(i, "date")}
	end
	mariadb_delete_result(result)
	return rows, User
end
AddFunctionExport("GetBanIp", GetBanIp)