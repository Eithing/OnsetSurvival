AddRemoteEvent("OnOpenGarage", function(player)
    local x, y, z = GetPlayerLocation(player)
    local NearestGarage = GetNearestZone(g_Points, x, y, z)
    if NearestGarage ~= 0 then
        CallRemoteEvent(player, "OpenGarage", NearestGarage.id, PlayerData[player].vehicles)
    end
end)

AddRemoteEvent("StoreVehicleToGarage", function(player)
    local x, y, z = GetPlayerLocation(player)
    local NearestGarageStore = GetNearestZone(gstore_Points, x, y, z)
    if NearestGarageStore ~= 0 then
        local vehicle = GetPlayerVehicle(player)
        if vehicle ~= 0 and VehicleData[vehicle] ~= nil then
            -- On vien set les variables du véhicule en cache
            if SaveVehicule(player, vehicle, NearestGarageStore.id) ~= 0 then
                -- On enleve le véhicule du cache et on le considère rentrer puis on le delete
                DestroyVehicule(player, vehicle)

                AddNotification(player, "Votre véhicule à bien été stocker !", "success")
            end
            return
        end
    end
end)

AddRemoteEvent("SpawnVehicleFromGarage", function(player, vehicleid)
    local x, y, z = GetPlayerLocation(player)
    local NearestGarage = GetNearestZone(g_Points, x, y, z)
    if NearestGarage ~= 0 then
        local vehicle = Garage_GetVehicleById(player, vehicleid)
        if vehicle ~= 0 then
            if tonumber(vehicle.garageid) == tonumber(NearestGarage.id) then
                if vehicle.state == 0 then
                    local spawnPoint = Garage_GetGoodSpawnPoint(player, NearestGarage)
                    if spawnPoint ~= 0 then
                        local newvehicle = CreateVehicle(vehicle.modelid, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.rotationz)
                        VehicleData[newvehicle] = {id = vehicle.id, garageid = vehicle.garageid, compteId = vehicle.compteId, modelid = vehicle.modelid, health = vehicle.health, degats = SLogic.json_decode(vehicle.degats), imageid = vehicle.imageid, nom = vehicle.nom, cles = vehicle.cles, poids = vehicle.poids, fuel = vehicle.fuel, inventory = {}, locked = false}
                        
                        SetPlayerInVehicle(player, newvehicle)
                        SetVehicleRespawnParams(newvehicle, false)
                        SetVehicleHealth(newvehicle, tonumber(vehicle.health))
                        SetFuel(newvehicle, tonumber(vehicle.fuel))
                        local plate = "EYNWA-"..tonumber(vehicle.modelid)..tonumber(vehicle.compteId)
                        SetVehicleLicensePlate(newvehicle, plate)

                        local damagedparts = SLogic.json_decode(vehicle.degats)
                        for w, x in pairs(damagedparts) do
                            SetVehicleDamage(newvehicle, w, x)
                        end

                        vehicle.state = 1

                        SLogic.UpdateVehicleById(vehicle)
                        print("Vehicule update for "..tostring(vehicle.id))
                        
                        AddNotification(player, "Votre véhicule à été sorti !", "success")
                        return
                    else
                        AddNotification(player, "Impossible de trouver une zone !", "error")
                        return
                    end
                else
                    AddNotification(player, "Le véhicule est déjà sorti !", "error")
                    return
                end
            end
        end
    end
end)

AddEvent("OnPackageStop", function()
    for k, vehicle in pairs(VehicleData) do
        vehicle.state = 0
        SLogic.UpdateVehicleById(vehicle)
        DestroyVehicle(k)
        VehicleData[k] = nil
    end
end)


-- FONCTIONS --
function Garage_GetVehicleById(player, id)
    local found = 0
    if PlayerData[player] ~= nil then
        for k,v in pairs(PlayerData[player].vehicles) do
            if tonumber(v.id) == tonumber(id) then
                found = v
                break
            end
        end
    end

    return found
end

function Garage_GetGoodSpawnPoint(player, garage)
    local found = 0
	for k, v in pairs(garage.spawnPoints) do
        local FoundVehicle = GetNearestVehicle(v.x, v.y, v.z)
        if FoundVehicle == 0 then
            found = v
            break
        end
	end

	return found
end

function GetNearestVehicle(x, y, z)
	local found = 0
	local nearest_dist = 150

	for _,v in pairs(GetAllVehicles()) do
		local x2, y2, z2 = GetVehicleLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < nearest_dist then
			found = v
			break
		end
    end
	return found
end

function SaveVehicule(player, vehicle, garageid)
    local found = 0
    local cvehicledata = VehicleData[vehicle]
    if cvehicledata ~= nil then
        if cvehicledata.id ~= nil then
            cvehicledata.garageid = tonumber(garageid)
            cvehicledata.fuel = math.clamp(VehicleData[vehicle].fuel, 0, 100)
            cvehicledata.health = math.clamp(GetVehicleHealth(vehicle), 0, v_health)
            local alldamages = {}
            for i=1, 8 do
                table.insert(alldamages, GetVehicleDamage(vehicle, i))
            end
            cvehicledata.degats = SLogic.json_encode(alldamages)

            print("Vehicule Saved for "..tostring(cvehicledata.id))
            found = cvehicledata
        end
    end
    return found
end

function DestroyVehicule(player, vehicle)
    local vehicledata = VehicleData[vehicle]
    if vehicledata ~= nil then
        vehicledata.state = 0
        UpdateOrInsertVehicle(player, vehicle)
        print("Vehicule destroy for "..tostring(vehicledata.id))
        DestroyVehicle(vehicle)
        VehicleData[vehicle] = nil
    end
end

function UpdateOrInsertVehicle(player, vehicle)
    local cvehicledata = VehicleData[vehicle]
    if cvehicledata ~= nil then
        if tonumber(cvehicledata.compteId) == tonumber(PlayerData[player].id) then
            if PlayerData[player] ~= nil then
                local pvehicledata = Garage_GetVehicleById(player, cvehicledata.id)
                if pvehicledata ~= 0 then
                    pvehicledata.garageid = tonumber(cvehicledata.garageid)
                    pvehicledata.fuel = math.clamp(cvehicledata.fuel, 0, 100)
                    pvehicledata.health = math.clamp(cvehicledata.health, 0, v_health)
                    local alldamages = {}
                    for i=1, 8 do
                        table.insert(alldamages, GetVehicleDamage(vehicle, i))
                    end
                    pvehicledata.degats = cvehicledata.degats
                    pvehicledata.state = 0

                    SLogic.UpdateVehicleById(pvehicledata)
                    print("Vehicule Saved for "..tostring(pvehicledata.id))
                end
            end
        else
            local vehicleowner = GetPlayerByCompteId(tonumber(cvehicledata.compteId))
            if vehicleowner ~= 0 then
                if PlayerData[vehicleowner] ~= nil then
                    for k,v in pairs(PlayerData[vehicleowner].vehicles) do
                        if tonumber(v.id) == tonumber(cvehicledata.id) then
                            PlayerData[vehicleowner].vehicles[k] = nil
                            break
                        end
                    end
                end
            end
            SLogic.DeleteVehicleById(cvehicledata.id)
            table.insert(PlayerData[player].vehicles, SLogic.InsertVehicle(tonumber(PlayerData[player].id), cvehicledata))
        end
    end
end