-- VEHICLES DATA --
local AllVehicles = {}
function GetAllVehicles()
    local query = mariadb_prepare(sql, "SELECT * FROM vehicles;")
    local result = mariadb_await_query(sql, query)
    local rows = mariadb_get_row_count() or 0
	for i=1, rows do
        AllVehicles[i] = {	id = mariadb_get_value_name(i, "idveh"),
                        nom = mariadb_get_value_name(i, "nom"),
                        class = mariadb_get_value_name(i, "class"),
                        poids = mariadb_get_value_name(i, "poids"),
                        imageId = mariadb_get_value_name(i, "imageId"),
                        modelId = mariadb_get_value_name(i, "modelId")}
	end
	mariadb_delete_result(result)
	return AllVehicles
end
AddFunctionExport("GetAllVehicles", GetAllVehicles)