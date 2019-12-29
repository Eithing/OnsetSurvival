local ItemData = {}

function GetAllItems()
	local result = mariadb_await_query(Sql, "SELECT * FROM items")

    local rows = mariadb_get_row_count()
	for i=1, rows do
		local id = mariadb_get_value_name(i, "")
		ItemData[i] = {	id = mariadb_get_value_name(i, "id"),
						nom = mariadb_get_value_name(i, "nom"),
						poids = mariadb_get_value_name(i, "poids"),
						type = mariadb_get_value_name(i, "type"),
						imageId = mariadb_get_value_name(i, "imageId")}
	end
	mariadb_delete_result(result)
	return ItemData
end
AddFunctionExport("GetAllItems", GetAllItems)

function GetModelFromItem(id)
	local query = mariadb_prepare(Sql, "SELECT modelId FROM items INNER JOIN compte_item ON items.id = compte_item.itemid WHERE compte_item.idUnique = '?';", id)
	local result = mariadb_await_query(Sql, query)

	local rows = mariadb_get_row_count()
	local modelId
	for i=1, rows do
		modelId = mariadb_get_value_name(i, "modelId")
	end
	mariadb_delete_result(result)
	return modelId
end
AddFunctionExport("GetModelFromItem", GetModelFromItem)