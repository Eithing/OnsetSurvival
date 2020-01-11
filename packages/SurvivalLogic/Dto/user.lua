function GetUserBySteamId(player)
    local query = mariadb_prepare(sql, "SELECT * FROM comptes WHERE steamid = '?' LIMIT 1;", tostring(GetPlayerSteamId(player)))
    local result = mariadb_await_query(sql, query)
    local User
	local rows = mariadb_get_row_count() or 0
	for i=0, rows do
		User = { id = mariadb_get_value_name(i, "id"),
					name = mariadb_get_value_name(i, "nom"),
					admin = mariadb_get_value_name(i, "admin"),
					steamid = mariadb_get_value_name(i, "steamid"),
					position = mariadb_get_value_name(i, "position"),
					armor = mariadb_get_value_name(i, "armor"),
					created = mariadb_get_value_name(i, "created"),
					clothing = mariadb_get_value_name(i, "clothing"),
					maxweight = mariadb_get_value_name(i, "maxweight"),
					argent = mariadb_get_value_name(i, "argent"),
					hunger = mariadb_get_value_name(i, "hunger"),
					thirst = mariadb_get_value_name(i, "thirst"),
					health = mariadb_get_value_name(i, "health")}
	end
	mariadb_delete_result(result)
	
	if(rows == 0 or rows == nil or rows == false)then
		rows = 0
	end
	return rows, User
end
AddFunctionExport("GetUserBySteamId", GetUserBySteamId)

function UpdateUser(player, user)
	local query = mariadb_prepare(sql, "UPDATE comptes SET admin = ?, argent = ?, health = ?,  armor = ?, hunger = ?, thirst = ?, nom = '?', maxweight = '?', clothing = '?', created = '?', position = '?', steamid = '?' WHERE id = ? LIMIT 1;",
        user.admin,
        user.argent,
		user.health,
		GetPlayerArmor(player),
		user.hunger,
		user.thirst,
		user.name,
		user.MaxWeight,
		json_encode(user.clothing),
		user.created,
        json_encode(user.position),
        tostring(user.steamid),
		user.id
	)
    mariadb_query(sql, query)
end
AddFunctionExport("UpdateUser", UpdateUser)

function InsertNewUser(player, maxweight)
    local query = mariadb_prepare(sql, "INSERT INTO comptes (id, admin, argent, health,  armor, hunger, thirst, nom, clothing, maxweight, created, position, steamid) VALUES (NULL, 0, 0, 100, 0, 100, 100, '', '[]', '?', 0, '[]', '?');",
    maxweight, tostring(GetPlayerSteamId(player)))
	mariadb_await_query(sql, query)
	
	local lastid = mariadb_get_insert_id()
	if(lastid == false)then
		lastid = 0
	end
    return lastid
end
AddFunctionExport("InsertNewUser", InsertNewUser)

function UpdateMoney(player, user)
	local query = mariadb_prepare(sql, "UPDATE comptes SET argent = ? WHERE id = ? LIMIT 1;",
        user.argent,
		user.id
	)
    mariadb_query(sql, query)
end
AddFunctionExport("UpdateMoney", UpdateMoney)

-- BANS --

function NewBanIp(ip, reason)
    local query = mariadb_prepare(sql, "INSERT INTO ipbans (ip, reason, date) VALUES ('?', '?', NOW());", steamid, reason)
    local result = mariadb_query(sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("NewBanIp", NewBanIp)

function GetBanIp(ip)
    local query = mariadb_prepare(sql, "SELECT * FROM ipbans WHERE ipbans.ip = '?' LIMIT 1;", ip)
    local result = mariadb_await_query(sql, query)
    local User
    local rows = mariadb_get_row_count() or 0
	User = {	id = mariadb_get_value_name(1, "id"),
				ip = mariadb_get_value_name(1, "ip"),
				reason = mariadb_get_value_name(1, "reason"),
				date = mariadb_get_value_name(1, "date")}
	mariadb_delete_result(result)
	return rows, User
end
AddFunctionExport("GetBanIp", GetBanIp)

function NewBanSteamID(steamid, reason)
    local query = mariadb_prepare(sql, "INSERT INTO bans (steamid, reason, date) VALUES ('?', '?', NOW());", steamid, reason)
    local result = mariadb_query(sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("NewBanSteamID", NewBanSteamID)

function GetBanSteamID(steamid)
    local query = mariadb_prepare(sql, "SELECT * FROM bans WHERE bans.steamid = '?' LIMIT 1;", steamid)
    local result = mariadb_await_query(sql, query)
    local User
    local rows = mariadb_get_row_count() or 0
	User = {	id = mariadb_get_value_name(1, "id"),
				steamid = mariadb_get_value_name(1, "steamid"),
				reason = mariadb_get_value_name(1, "reason"),
				date = mariadb_get_value_name(1, "date")}
	mariadb_delete_result(result)
	return rows, User
end
AddFunctionExport("GetBanSteamID", GetBanSteamID)