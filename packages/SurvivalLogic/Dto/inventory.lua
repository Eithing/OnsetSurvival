local InventoryItems = {}

function GetUserInventory(player, id)
	local query = mariadb_prepare(Sql, "SELECT * FROM items INNER JOIN compte_item ON items.id = compte_item.itemId WHERE compte_item.compteId = '?'", id)
	local result = mariadb_await_query(Sql, query)

	local rows = mariadb_get_row_count()
	for i=1, rows do
		InventoryItems[i] = {id = mariadb_get_value_name(i, "id"),
							nom = mariadb_get_value_name(i, "nom"),
							poids = mariadb_get_value_name(i, "poids"),
							type = mariadb_get_value_name(i, "type"),
							imageId = mariadb_get_value_name(i, "imageId"),
							itemCount = mariadb_get_value_name(i, "itemCount"),
							compteId = mariadb_get_value_name(i, "compteId"),
							itemId = mariadb_get_value_name(i, "itemId"),
							modelId = mariadb_get_value_name(i, "modelId"),
							var = mariadb_get_value_name(i, "var"),
							idUnique = mariadb_get_value_name(i, "idUnique")}
	end
	mariadb_delete_result(result)
	return InventoryItems
end
AddFunctionExport("GetUserInventory", GetUserInventory)

function SetUserInventory(playerId, itemId, count, var)
	local query = mariadb_prepare(Sql, "INSERT INTO compte_item(itemCount, compteId, itemId, var) VALUES ('?','?','?','?')", count, playerId, itemId, json_encode(var))
	local result = mariadb_query(Sql, query)
	mariadb_delete_result(result)
	return GetLastUserItem(playerId)
end
AddFunctionExport("SetUserInventory", SetUserInventory)

function GetLastUserItem(playerId)
	local query = mariadb_prepare(Sql, "SELECT * FROM items INNER JOIN compte_item ON items.id = compte_item.itemid WHERE compteId='?' ORDER BY idUnique DESC LIMIT 0,1", playerId)
	local result = mariadb_await_query(Sql, query)

	local InventoryItems
	local rows = mariadb_get_row_count()
	for i=1, rows do
		InventoryItems = {id = mariadb_get_value_name(i, "id"),
							nom = mariadb_get_value_name(i, "nom"),
							poids = mariadb_get_value_name(i, "poids"),
							type = mariadb_get_value_name(i, "type"),
							imageId = mariadb_get_value_name(i, "imageId"),
							itemCount = mariadb_get_value_name(i, "itemCount"),
							compteId = mariadb_get_value_name(i, "compteId"),
							itemId = mariadb_get_value_name(i, "itemId"),
							modelId = mariadb_get_value_name(i, "modelId"),
							var = mariadb_get_value_name(i, "var"),
							idUnique = mariadb_get_value_name(i, "idUnique")}
	end
	mariadb_delete_result(result)
	return InventoryItems
end
AddFunctionExport("GetLastUserItem", GetLastUserItem)

function UpdateUserInventory(playerId, idUnique, count, var)
	local query = mariadb_prepare(Sql, "UPDATE compte_item SET itemCount = '?', var= '?' WHERE compteId='?' and idUnique='?'", count, json_encode(var), playerId, idUnique)
	local result = mariadb_query(Sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("UpdateUserInventory", UpdateUserInventory)

function RemoveItemInventory(idUnique)
	local query = mariadb_prepare(Sql, "DELETE FROM compte_item WHERE idUnique = '?';", idUnique)
	local result = mariadb_query(Sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("RemoveItemInventory", RemoveItemInventory)

function JsonDecode(var)
	return json_decode(var)
end
AddFunctionExport("JsonDecode", JsonDecode)