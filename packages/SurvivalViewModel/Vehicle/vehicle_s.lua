local delayconsume = 1000 -- delai de la cosomation d'essence
local consomevalue = 1 -- Nombre d'essence retirer a chaque verification
local defaultFuel = 100

AddEvent("OnPackageStart", function()
    print("Vehicle ServerSide Loaded")
    CreateTimer(function()
        for k,v in pairs(GetAllVehicles()) do
            if GetVehicleEngineState(v) then
                if VehicleData[k] == nil then
                    VehicleData[k] = {}
                    VehicleData[k].fuel = defaultFuel
                end
                if(GetVehicleVelocity(v) < 0 or GetVehicleVelocity(v) > 0)then
                    ConsumeFuel(v, consomevalue)
                    --print(VehicleData[k].fuel) -- Print l'essence du véhicule
                end
                if VehicleData[k].fuel <= 0 then
                    StopVehicleEngine(k)
                    VehicleData[k].fuel = 0
                end
            end
        end
    end, delayconsume)
end)


AddEvent("OnPlayerEnterVehicle", function( player, vehicle, seat )
    if VehicleData[vehicle] == nil then
        VehicleData[vehicle] = {}
        VehicleData[vehicle].fuel = defaultFuel
    end
    if seat == 1 then
        CallRemoteEvent(player, "OnUpdateVehicleHud")
        CallRemoteEvent(player, "OnUpdateFuel", VehicleData[vehicle].fuel)
        if VehicleData[vehicle].fuel == 0 then
            StopVehicleEngine(vehicle)
        end
    end
end)

AddEvent("OnPlayerLeaveVehicle", function( player, vehicle, seat)
    if seat == 1 then
        CallRemoteEvent(player, "OnUpdateVehicleHud")
        StopVehicleEngine(vehicle)
    end
end)

function AddFuel(vehicle, count)
    if vehicle > 0 then
        if VehicleData[vehicle] == nil then
            VehicleData[vehicle] = {}
            VehicleData[vehicle].fuel = defaultFuel
        else
            VehicleData[vehicle].fuel = math.clamp(VehicleData[vehicle].fuel + count, 0, 100)
        end
        local driver = GetVehicleDriver(vehicle)
        if(driver)then
            CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
        end
    end

    --print(VehicleData[vehicle].fuel) Pour verifier l'essence
end
AddRemoteEvent("AddFuel", AddFuel)

function ConsumeFuel(vehicle, count)
    if vehicle > 0 then
        if VehicleData[vehicle] == nil then
            VehicleData[vehicle] = {}
            VehicleData[vehicle].fuel = defaultFuel
        else
            VehicleData[vehicle].fuel = math.clamp(VehicleData[vehicle].fuel - count, 0, 100)
        end
    end
    local driver = GetVehicleDriver(vehicle)
    if(driver)then
        CallRemoteEvent(driver, "OnUpdateFuel", VehicleData[vehicle].fuel)
    end

    --print(VehicleData[vehicle].fuel) Pour verifier l'essence
end
AddRemoteEvent("ConsumeFuel", ConsumeFuel)

-- Commande DEV
function addfuel_commands(player, count)
    if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
	    AddFuel(GetPlayerVehicle(player), count)
        print("Admin : Essence ajoutée")
    end
	return
end
AddCommand("addfuel", addfuel_commands)

function consumefuel_commands(player, count)
    if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
	    ConsumeFuel(GetPlayerVehicle(player), count)
        print("Admin : Essence consumée")
    end
	return
end
AddCommand("consumefuel", consumefuel_commands)

-- Find Car --
function GetNearestVehicle(player, nearest_dist)
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