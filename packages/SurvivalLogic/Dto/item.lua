local ItemData = {}

function GetAllItems()
	local query = mariadb_prepare(sql, "SELECT * FROM items")
	local result = mariadb_await_query(sql, query)

    local rows = mariadb_get_row_count()
	for i=1, rows do
		ItemData[i] = {	id = mariadb_get_value_name(i, "id"),
						nom = mariadb_get_value_name(i, "nom"),
						poids = mariadb_get_value_name(i, "poids"),
						type = mariadb_get_value_name(i, "type"),
						imageId = mariadb_get_value_name(i, "imageId"),
						modelId = mariadb_get_value_name(i, "modelId")}
	end
	mariadb_delete_result(result)
	return ItemData
end
AddFunctionExport("GetAllItems", GetAllItems)

function GetModelFromItem(id)
	local query = mariadb_prepare(sql, "SELECT modelId FROM items INNER JOIN compte_item ON items.id = compte_item.itemid WHERE compte_item.idUnique = '?';", id)
	local result = mariadb_await_query(sql, query)

	local rows = mariadb_get_row_count()
	local modelId
	for i=1, rows do
		modelId = mariadb_get_value_name(i, "modelId")
	end
	mariadb_delete_result(result)
	return modelId
end
AddFunctionExport("GetModelFromItem", GetModelFromItem)