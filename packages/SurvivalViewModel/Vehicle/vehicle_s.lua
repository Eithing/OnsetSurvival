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
                end
            end
        end
    end, v_delayconsume)
end)


AddEvent("OnPlayerEnterVehicle", function(player, vehicle, seat )
    if VehicleData[vehicle] == nil then
        VehicleData[vehicle] = {}
        VehicleData[vehicle].fuel = v_defaultFuel
    end
    if seat == 1 then
        CallRemoteEvent(player, "OnUpdateVehicleHud")
        CallRemoteEvent(player, "OnUpdateFuel", VehicleData[vehicle].fuel)
        if VehicleData[vehicle].fuel == 0 then
            StopVehicleEngine(vehicle)
        end
    end
end)

AddEvent("OnPlayerLeaveVehicle", function(player, vehicle, seat)
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
    end
    local driver = GetVehicleDriver(vehicle)
    if IsValidPlayer(driver) then
        CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
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
    end
    local driver = GetVehicleDriver(vehicle)
    if IsValidPlayer(driver) then
        CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
    end
end
AddRemoteEvent("SetFuel", SetFuel)

-- Fonction --
function GetNearestVehicle(player, nearest_dist) -- Trouvée le véhicule le plus proche
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