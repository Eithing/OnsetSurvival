function GetVehiclesBySteamId(compteId)
    local query = mariadb_prepare(sql, "SELECT * FROM player_vehicles WHERE compteId = '?';", compteId)
    local result = mariadb_await_query(sql, query)
    local Player_Vehicles = {}
    local rows = mariadb_get_row_count() or 0
	for i=1, rows do
        Player_Vehicles[i] = {	id = mariadb_get_value_name(i, "id"),
                        compteId = mariadb_get_value_name(i, "compteId"),
						modelid = mariadb_get_value_name(i, "modelId"),
						fuel = mariadb_get_value_name(i, "fuel"),
						health = mariadb_get_value_name(i, "health"),
						cles = mariadb_get_value_name(i, "cles"),
						garageid = mariadb_get_value_name(i, "garageid"),
						degats = mariadb_get_value_name(i, "degats"),
						state = 0}
	end
	mariadb_delete_result(result)
	return rows, Player_Vehicles
end
AddFunctionExport("GetVehiclesBySteamId", GetVehiclesBySteamId)