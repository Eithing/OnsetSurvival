--GetPlayerInventory --
function GetPlayerInventory(id)
    local query = mariadb_prepare(sql, "SELECT * FROM inventory WHERE compteId = '?';", id)
    local result = mariadb_await_query(sql, query)
    local Player_Inventory = {}
    local rows = mariadb_get_row_count() or 0
	for i=1, rows do
        Player_Inventory[i] = {	id = mariadb_get_value_name(i, "id"),
                        compteId = mariadb_get_value_name(i, "compteId"),
						itemId = mariadb_get_value_name(i, "itemId"),
						itemCount = mariadb_get_value_name(i, "itemCount"),
                        var = mariadb_get_value_name(i, "var")}
	end
	mariadb_delete_result(result)
	return Player_Inventory
end
AddFunctionExport("GetPlayerInventory", GetPlayerInventory)

-- Get Last Player Item --
function GetLastPlayerItem(id)
    local query = mariadb_prepare(sql, "SELECT * FROM inventory WHERE compteId = '?' ORDER BY DESC LIMIT 1;", id)
    local result = mariadb_await_query(sql, query)
    local Player_Inventory = {}
    local rows = mariadb_get_row_count() or 0
	Player_Inventory = {	id = mariadb_get_value_name(1, "id"),
                        compteId = mariadb_get_value_name(1, "compteId"),
						itemId = mariadb_get_value_name(1, "itemId"),
						itemCount = mariadb_get_value_name(1, "itemCount"),
						var = mariadb_get_value_name(1, "var")}
    mariadb_delete_result(result)
	return rows, Player_Inventory
end
AddFunctionExport("GetLastPlayerItem", GetLastPlayerItem)

-- Insert Item --
function SetUserInventory(compteId, itemId, count, var)
	local query = mariadb_prepare(Sql, "INSERT INTO inventory(compteId, itemId, itemCount, var) VALUES ('?','?','?','?')", compteId, itemId, count, json_encode(var))
	local result = mariadb_query(Sql, query)
	mariadb_delete_result(result)
	return GetLastPlayerItem(compteId)
end
AddFunctionExport("SetUserInventory", SetUserInventory)

-- Update Item --
function UpdatePlayerItem(item)
    local query = mariadb_prepare(sql, "UPDATE inventory SET itemCount = '?', var = '?' WHERE id = '?' ORDER BY DESC LIMIT 1;", item.itemCount, json_encode(item.var), item.id)
    local result = mariadb_query(sql, query)
    mariadb_delete_result(result)
    return true
end
AddFunctionExport("UpdatePlayerItem", UpdatePlayerItem)

-- Remove Item --
function RemovePlayerItem(item)
    local query = mariadb_prepare(sql, "DELETE FROM inventory WHERE id = '?';", item)
    local result = mariadb_query(sql, query)
    mariadb_delete_result(result)
    return true
end
AddFunctionExport("RemovePlayerItem", RemovePlayerItem)