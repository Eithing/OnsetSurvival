--GetPlayerInventory --
function GetPlayerInventory(id)
    local query = mariadb_prepare(sql, "SELECT inventory.id, items.nom, items.poids, items.type, items.imageId, items.modelId, inventory.compteId, inventory.itemId, inventory.itemCount, inventory.var FROM items INNER JOIN inventory ON items.id = inventory.itemId WHERE inventory.compteId = '?';", id)
    local result = mariadb_await_query(sql, query)
    local Player_Inventory = {}
    local rows = mariadb_get_row_count() or 0
	for i=1, rows do
        Player_Inventory[i] = {	id = mariadb_get_value_name(i, "id"),
                        nom = mariadb_get_value_name(i, "nom"),
                        poids = mariadb_get_value_name(i, "poids"),
                        type = mariadb_get_value_name(i, "type"),
                        imageId = mariadb_get_value_name(i, "imageId"),
                        modelId = mariadb_get_value_name(i, "modelId"),
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
    local query = mariadb_prepare(sql, "SELECT inventory.id, items.nom, items.poids, items.type, items.imageId, items.modelId, inventory.compteId, inventory.itemId, inventory.itemCount, inventory.var FROM items INNER JOIN inventory ON items.id = inventory.itemId WHERE inventory.compteId = '?' ORDER BY inventory.id DESC LIMIT 1;", tonumber(id))
    local result = mariadb_await_query(sql, query)
    local Player_Inventory = {}
    local rows = mariadb_get_row_count() or 0
    for i=1, rows do
	    Player_Inventory = {id = mariadb_get_value_name(i, "id"),
            nom = mariadb_get_value_name(i, "nom"),
            poids = mariadb_get_value_name(i, "poids"),
            type = mariadb_get_value_name(i, "type"),
            imageId = mariadb_get_value_name(i, "imageId"),
            modelId = mariadb_get_value_name(i, "modelId"),
            compteId = mariadb_get_value_name(i, "compteId"),
            itemId = mariadb_get_value_name(i, "itemId"),
            itemCount = mariadb_get_value_name(i, "itemCount"),
            var = mariadb_get_value_name(i, "var")}
    end
    mariadb_delete_result(result)
	return Player_Inventory
end
AddFunctionExport("GetLastPlayerItem", GetLastPlayerItem)

-- Insert Item --
function SetUserInventory(compteId, itemId, count, var)
	local query = mariadb_prepare(sql, "INSERT INTO inventory(compteId, itemId, itemCount, var) VALUES ('?','?','?','?')", tonumber(compteId), tonumber(itemId), tonumber(count), var)
	local result = mariadb_query(sql, query)
	mariadb_delete_result(result)
end
AddFunctionExport("SetUserInventory", SetUserInventory)

-- Update Item --
function UpdatePlayerItem(item)
    local query = mariadb_prepare(sql, "UPDATE inventory SET itemCount = '?', var = '?' WHERE id = '?' ORDER BY id DESC LIMIT 1;", tonumber(item.itemCount), item.var, tonumber(item.id))
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