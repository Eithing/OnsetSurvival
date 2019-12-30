local delayconsume = 1000 -- delai de la cosomation d'essence
local consomevalue = 1 -- Nombre d'essence retirer a chaque verification

AddEvent("OnPackageStart", function()
    print("Vehicle ServerSide Loaded")
    CreateTimer(function()
        for k,v in pairs(GetAllVehicles()) do
            if GetVehicleEngineState(k) then
                if VehicleData[k] == nil then
                    VehicleData[k] = {}
                    VehicleData[k].fuel = 100
                end
                if(GetVehicleVelocity(v) < 0 or GetVehicleVelocity(v) > 0)then
                    ConsumeFuel(v, consomevalue)
                    --print(VehicleData[k].fuel) -- Print l'essence du véhicule
                end
                print("Vie du véhicule : "..GetVehicleHealth(v))
                if VehicleData[k].fuel == 0 then
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
        VehicleData[vehicle].fuel = 100
    end
    if seat == 1 then
        CallRemoteEvent(player, "OnUpdateVehicleHud")
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
            VehicleData[vehicle].fuel = 100
        else
            VehicleData[vehicle].fuel = VehicleData[vehicle].fuel + count
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
            VehicleData[vehicle].fuel = 100
        else
            VehicleData[vehicle].fuel = VehicleData[vehicle].fuel - count
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
function addfuel_commands(player)
    if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
	    AddFuel(player, 10)
        print("Admin : Essence ajoutée")
    end
	return
end
AddCommand("addfuel", addfuel_commands)

function consumefuel_commands(player)
    if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
	    ConsumeFuel(GetPlayerVehicle(player), 10)
        print("Admin : Essence consumée")
    end
	return
end
AddCommand("consumefuel", consumefuel_commands)