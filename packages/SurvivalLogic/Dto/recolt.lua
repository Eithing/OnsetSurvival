local RecoltData = {}

function GetAllRecolts()
	local result = mariadb_await_query(Sql, "SELECT * FROM recolt")

    local rows = mariadb_get_row_count()
	for i=1, rows do
		local id = mariadb_get_value_name(i, "")
		RecoltData[i] = {	x = mariadb_get_value_name(i, "x"),
						y = mariadb_get_value_name(i, "y"),
						radius = mariadb_get_value_name(i, "radius"),
						nom = mariadb_get_value_name(i, "nom"),
						itemId = mariadb_get_value_name(i, "itemId"),
						id = mariadb_get_value_name(i, "id")}
	end
	mariadb_delete_result(result)
	return RecoltData
end
AddFunctionExport("GetAllRecolts", GetAllRecolts)