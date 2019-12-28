local InventoryItems = {}

function GetUserInventory(player, id)
	local query = mariadb_prepare(Sql, "SELECT * FROM items INNER JOIN compte_item ON items.id = compte_item.itemid WHERE compte_item.compteId = '?';", id)
	local result = mariadb_await_query(Sql, query)

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
	mariadb_delete_result(result)
	return InventoryItems
end
AddFunctionExport("GetUserInventory", GetUserInventory)

function SetUserInventory(playerId, itemId, count)
	local query = mariadb_prepare(Sql, "INSERT INTO compte_item(itemCount, compteId, itemId) VALUES ('?','?','?')", count, playerId, itemId)
	local result = mariadb_await_query(Sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("SetUserInventory", SetUserInventory)

function UpdateUserInventory(playerId, itemId, count)
	local query = mariadb_prepare(Sql, "UPDATE compte_item SET itemCount = '?' WHERE compteId='?' and itemId='?'", count, playerId, itemId)
	local result = mariadb_await_query(Sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("UpdateUserInventory", UpdateUserInventory)
