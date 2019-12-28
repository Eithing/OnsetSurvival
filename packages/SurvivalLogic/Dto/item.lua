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