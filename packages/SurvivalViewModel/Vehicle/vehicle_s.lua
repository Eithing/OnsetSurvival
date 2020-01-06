AddEvent("OnPackageStart", function()
    print("Vehicle ServerSide Loaded")
    CreateTimer(function()
        for k,v in pairs(GetAllVehicles()) do
            if GetVehicleEngineState(v) then
                if VehicleData[v] == nil then
                    VehicleData[v] = {}
                    VehicleData[v].fuel = v_defaultFuel
                end
                if(GetVehicleVelocity(v) < 0 or GetVehicleVelocity(v) > 0)then
                    ConsumeFuel(v, v_consomevalue)
                    --print(VehicleData[k].fuel) -- Print l'essence du véhicule
                end
                if VehicleData[v].fuel <= 0 then
                    StopVehicleEngine(v)
                    VehicleData[v].fuel = 0

                    local driver = GetVehicleDriver(v)
                    if IsValidPlayer(driver) then
                        AddNotification(driver, "La voiture a plus d'essence !", "error")
                    end
                end
            end
        end
    end, v_delayconsume)
end)

AddEvent("OnPlayerEnterVehicle", function(player, vehicle, seat)
    if VehicleData[vehicle] ~= nil then
        if VehicleData[vehicle].locked == true then
            AddNotification(player, "Le véhicule est vérouillé !", "error")
            return false
        end
    else
        VehicleData[vehicle] = {}
        VehicleData[vehicle].fuel = v_defaultFuel
    end

    if seat == 1 then
        CallRemoteEvent(player, "OnUpdateVehicleHud")
        CallRemoteEvent(player, "OnUpdateFuel", VehicleData[vehicle].fuel)
        if VehicleData[vehicle].fuel <= 0 then
            StopVehicleEngine(vehicle)
            AddNotification(player, "La voiture a plus d'essence !", "error")
        end
    end
    return true
end)

AddEvent("OnPlayerLeaveVehicle", function(player, vehicle, seat)

    if VehicleData[vehicle] ~= nil then
        if VehicleData[vehicle].locked == true then
            AddNotification(player, "Le véhicule est vérouillé !", "error")
            return false
        end
    end

    local x,y,z = GetVehicleVelocity(vehicle)
    if seat == 1 then
        CallRemoteEvent(player, "OnUpdateVehicleHud")
        StopVehicleEngine(vehicle)
    end

    -- Systeme de degats lors de la sortit du véhicule (En dev - Marche pas)
    --print("X : "..x,"Y : "..y,"Z : "..z)
    --if(speed > 0)then
    --    print(GetPlayerHealth(player))
    --    SetPlayerHealth(player, math.clamp(GetPlayerHealth(player) - 4 * speed, 0, 100))
    --    print(GetPlayerHealth(player))
    --end
    return true
end)

function AddFuel(vehicle, count)
    count = tonumber(count)
    if IsValidVehicle(vehicle) then
        if VehicleData[vehicle] == nil then
            VehicleData[vehicle] = {}
            VehicleData[vehicle].fuel = v_defaultFuel
        else
            VehicleData[vehicle].fuel = math.clamp(VehicleData[vehicle].fuel + count, 0, 100)
        end
        local driver = GetVehicleDriver(vehicle)
        if IsValidPlayer(driver) then
            CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
        end
    end
end
AddRemoteEvent("AddFuel", AddFuel)

function ConsumeFuel(vehicle, count)
    count = tonumber(count)
    if IsValidVehicle(vehicle) then
        if VehicleData[vehicle] == nil then
            VehicleData[vehicle] = {}
            VehicleData[vehicle].fuel = v_defaultFuel
        else
            VehicleData[vehicle].fuel = math.clamp(VehicleData[vehicle].fuel - count, 0, 100)
        end
        local driver = GetVehicleDriver(vehicle)
        if IsValidPlayer(driver) then
            CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
        end
    end
end
AddRemoteEvent("ConsumeFuel", ConsumeFuel)

function SetFuel(vehicle, count)
    count = tonumber(count)
    if IsValidVehicle(vehicle) then
        if VehicleData[vehicle] == nil then
            VehicleData[vehicle] = {}
            VehicleData[vehicle].fuel = v_defaultFuel
        else
            VehicleData[vehicle].fuel = math.clamp(count, 0, 100)
        end

        local driver = GetVehicleDriver(vehicle)
        if IsValidPlayer(driver) then
            CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
        end
    end
end
AddRemoteEvent("SetFuel", SetFuel)

function Repair(vehicle, count)
    count = tonumber(count)
    if IsValidVehicle(vehicle) then
        SetVehicleHealth(vehicle, math.clamp(GetVehicleHealth(vehicle) + count, 0, v_health))

        local driver = GetVehicleDriver(vehicle)
        if IsValidPlayer(driver) then
            CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
        end
    end
end
AddRemoteEvent("Repair", Repair)

function LockUnLockVehicle(player, vehicle)
    if VehicleData[vehicle] ~= nil then
        if VehicleData[vehicle].locked == true then
            UnLockVehicle(player, vehicle)
        else
            LockVehicle(player, vehicle)
        end
    end
end

function LockVehicle(player, vehicle)
    if VehicleData[vehicle] ~= nil then
        local x, y, z = GetVehicleLocation(vehicle)
        VehicleData[vehicle].locked = true
        AddNotification(player, "Véhicule verrouillé !", "success")
        CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3", x, y, z, 100)
    end
end

function UnLockVehicle(player, vehicle)
    if VehicleData[vehicle] ~= nil then
        local x, y, z = GetVehicleLocation(vehicle)
        VehicleData[vehicle].locked = false
        AddNotification(player, "Véhicule déverrouillé !", "success")
        CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3", x, y, z, 100)
    end
end

function UnflipVehicle(player) 
    local vehicle = VGetNearestVehicle(player, 120)
    if vehicle ~= 0 and IsValidVehicle(vehicle) then
        local rx, ry, rz = GetVehicleRotation(vehicle)
        SetVehicleRotation(vehicle, 0, ry, 0 )
    end
end
AddRemoteEvent("UnflipVehicle", UnflipVehicle)

-- Fonction --
function VGetNearestVehicle(player, nearest_dist) -- Trouvée le véhicule le plus proche
	local vehicles = GetStreamedVehiclesForPlayer(player)
	local found = 0
	local x, y, z = GetPlayerLocation(player)

	for _,v in pairs(vehicles) do
		local x2, y2, z2 = GetVehicleLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < nearest_dist then
			nearest_dist = dist
			found = v
		end
	end
	return found, nearest_dist
end