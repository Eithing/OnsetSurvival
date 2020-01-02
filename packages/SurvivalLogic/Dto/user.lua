function GetUserBySteamId(steamId)
    print(steamId)
	local query = mariadb_prepare(Sql, "SELECT * FROM comptes WHERE steamid = '?';", tostring(steamId))
	local result = mariadb_await_query(Sql, query)

	local User = false
    local rows = mariadb_get_row_count()
    local resulting = mariadb_get_assoc(1)
	mariadb_delete_result(result)
	return rows, resulting
end
AddFunctionExport("GetUserBySteamId", GetUserBySteamId)

function UpdateUser(user)
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

function InsertNewUser(steamid)
    local query = mariadb_prepare(sql, "INSERT INTO comptes (id, admin, argent, health,  armor, hunger, thirst, nom, clothing, inventory, created, position, steamid) VALUES (NULL, 0, 0, 100, 0, 100, 100, '', '[]', '[]', 0, '[]', '?');",
		tostring(steamid))
    mariadb_query(sql, query)
    return mariadb_get_insert_id()
end
AddFunctionExport("InsertNewUser", InsertNewUser)