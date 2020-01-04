function GetVehiclesBySteamId(compteId)
    local query = mariadb_prepare(sql, "SELECT player_vehicles.id, player_vehicles.compteId, player_vehicles.fuel, player_vehicles.state, player_vehicles.health, player_vehicles.cles, player_vehicles.garageid, player_vehicles.degats, vehicles.nom, vehicles.modelId, vehicles.imageId, vehicles.class, vehicles.poids FROM player_vehicles INNER JOIN vehicles ON vehicles.modelId = player_vehicles.modelId WHERE compteId = '?';", compteId)
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
						nom = mariadb_get_value_name(i, "nom"),
						class = mariadb_get_value_name(i, "class"),
						poids = mariadb_get_value_name(i, "poids"),
						imageid = mariadb_get_value_name(i, "imageId"),
						state = tonumber(mariadb_get_value_name(i, "state"))}
	end
	mariadb_delete_result(result)
	return rows, Player_Vehicles
end
AddFunctionExport("GetVehiclesBySteamId", GetVehiclesBySteamId)

function InsertVehicle(playerid, veh)
	local query = mariadb_prepare(sql, "INSERT INTO player_vehicles (compteId, modelId, fuel, health, cles, garageid, degats, state) VALUES ('?', '?', '?', '?', '?', '?', '?', '?');",
		playerid,
		veh.modelid,
        veh.fuel,
        veh.health,
		veh.cles,
		veh.garageid,
		veh.degats,
		veh.state
	)
	mariadb_await_query(sql, query)
	
    return mariadb_get_insert_id()
end
AddFunctionExport("InsertVehicle", InsertVehicle)

function UpdateVehicleById(veh)
	local query = mariadb_prepare(sql, "UPDATE player_vehicles SET health = '?', fuel = '?', degats = '?', cles = '?', garageid = '?', state = '?' WHERE id = '?' LIMIT 1;",
        veh.health,
        veh.fuel,
		veh.degats,
		veh.cles,
		veh.garageid,
		veh.state,
		veh.id
	)
    mariadb_query(sql, query)
end
AddFunctionExport("UpdateVehicleById", UpdateVehicleById)

function DeleteVehicleById(vehid)
	local query = mariadb_prepare(sql, "DELETE FROM player_vehicles WHERE id = '?' LIMIT 1;",
		vehid
	)
    mariadb_query(sql, query)
end
AddFunctionExport("DeleteVehicleById", DeleteVehicleById)