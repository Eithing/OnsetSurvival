local GarageData = {}

function GetAllGarages()
	local result = mariadb_await_query(Sql, "SELECT * FROM garage")

    local rows = mariadb_get_row_count()
	for i=1, rows do
		GarageData[i] = {	x = mariadb_get_value_name(i, "x"),
						y = mariadb_get_value_name(i, "y"),
						radius = mariadb_get_value_name(i, "radius"),
						nom = mariadb_get_value_name(i, "nom"),
						id = mariadb_get_value_name(i, "id")}
	end
	mariadb_delete_result(result)
	return GarageData
end
AddFunctionExport("GetAllGarages", GetAllGarages)

function GetUserVehicle(player, id)
	local userVehicle = {}
	
	local query = mariadb_prepare(Sql, "SELECT idUnique, compteId, fuel, health, degats, cles, garageid, vehicles.nom, vehicles.modelId, vehicles.imageId FROM player_vehicles INNER JOIN vehicles ON vehicles.modelId = player_vehicles.modelId WHERE player_vehicles.compteId = '?'", id)
	
	local result = mariadb_await_query(Sql, query)
	
	local rows = mariadb_get_row_count()
	for i=1, rows do
		userVehicle[i] = {id = mariadb_get_value_name(i, "idUnique"),
		compteId = mariadb_get_value_name(i, "compteId"),
		nom = mariadb_get_value_name(i, "nom"),
		modelId = mariadb_get_value_name(i, "modelId"),
		fuel = mariadb_get_value_name(i, "fuel"),
		health = mariadb_get_value_name(i, "health"),
		cles = mariadb_get_value_name(i, "cles"),
		imageId = mariadb_get_value_name(i, "imageId"),
		garageid = mariadb_get_value_name(i, "garageid")}
	end
	mariadb_delete_result(result)
	return userVehicle
end
AddFunctionExport("GetUserVehicle", GetUserVehicle)