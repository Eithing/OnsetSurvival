-- Fuel
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
    if VehicleData[vehicle] == nil then
        VehicleData[vehicle] = {}
        VehicleData[vehicle].fuel = v_defaultFuel
    end

    if seat == 1 then
        CallRemoteEvent(player, "OnUpdateVehicleHud")
        CallRemoteEvent(player, "OnUpdateFuel", VehicleData[vehicle].fuel)
        CallRemoteEvent(player, "radio:EnterRadio", vehicle)
        if VehicleData[vehicle].fuel <= 0 then
            StopVehicleEngine(vehicle)
        end
    end
    return true
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

-- Repair
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

-- Lock - UnLock
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
        SetVehiclePropertyValue(vehicle, "locked", true, true)
        AddNotification(player, "Véhicule verrouillé !", "success")
        CallRemoteEvent(player, "PlayAudioFile", "carUnlock.mp3", x, y, z, 300, 0.7)
    end
end

function UnLockVehicle(player, vehicle)
    if VehicleData[vehicle] ~= nil then
        local x, y, z = GetVehicleLocation(vehicle)
        VehicleData[vehicle].locked = false
        SetVehiclePropertyValue(vehicle, "locked", false, true)
        AddNotification(player, "Véhicule déverrouillé !", "success")
        CallRemoteEvent(player, "PlayAudioFile", "carLock.mp3", x, y, z, 300, 0.7)
    end
end

-- UnFlip
function UnflipVehicle(player) 
    local vehicle = VGetNearestVehicle(player, 120)
    if vehicle ~= 0 and IsValidVehicle(vehicle) then
        local rx, ry, rz = GetVehicleRotation(vehicle)
        SetVehicleRotation(vehicle, 0, ry, 0 )
    end
end
AddRemoteEvent("UnflipVehicle", UnflipVehicle)

-- ChangeSeat
AddRemoteEvent("ChangeSeat", function(player, seat)
    local veh = tonumber(GetPlayerVehicle(player))
    local seatplace = tonumber(seat)
    if GetPlayerVehicleSeat(player) ~= seatplace then
        if GetVehiclePassenger(veh, seatplace) > 0 then
            AddNotification(player, "Impossible de changer de place !", "error")
        else
            SetPlayerInVehicle(player, veh, seatplace)
        end
    end
 end)

--[[ RADIO SYSTEM ]]
sr = ImportPackage("soundstreamer")

local VehicleRadio = {}
AddRemoteEvent("radio:getplayersinvehicle", function(player, radioStatus, volume, channel)
    local vehicle = GetPlayerVehicle(player) -- On récupère le véhicle
    if VehicleRadio[vehicle] == nil then
        VehicleRadio[vehicle] = {}
        VehicleRadio[vehicle].vehicle = vehicle
        VehicleRadio[vehicle].track = nil
        VehicleRadio[vehicle].volume = 0.5
        VehicleRadio[vehicle].CurrentRadio = 1
        VehicleRadio[vehicle].isEnabled = false
    end
    VehicleRadio[vehicle].vehicle = vehicle
    VehicleRadio[vehicle].LastPos = GetVehicleLocation(vehicle)
    local x, y, z = GetVehicleLocation(vehicle)
    
    if volume ~= nil then
        if volume == 1 and VehicleRadio[vehicle].volume < 1.0 then --Monte le son
            VehicleRadio[vehicle].volume = math.clamp(VehicleRadio[vehicle].volume + 0.05, 0, 1)
        elseif volume == 0 and VehicleRadio[vehicle].volume > 0.0 then -- baisse le son
            VehicleRadio[vehicle].volume = math.clamp(VehicleRadio[vehicle].volume - 0.05, 0, 1)
        end
        sr.SetSound3DVolume(VehicleRadio[vehicle].track, VehicleRadio[vehicle].volume)
    elseif channel ~= nil then
        sr.DestroySound3D(VehicleRadio[vehicle].track)
        VehicleRadio[vehicle].track = nil
        VehicleRadio[vehicle].CurrentRadio = channel
        VehicleRadio[vehicle].track = sr.CreateSound3D(v_radios[VehicleRadio[vehicle].CurrentRadio].url, x, y, z, 800.0)
        sr.SetSound3DVolume(VehicleRadio[vehicle].track, VehicleRadio[vehicle].volume)
        CallRemoteEvent(player, "OnUpdateRadio", v_radios[VehicleRadio[vehicle].CurrentRadio].label, VehicleRadio[vehicle].CurrentRadio)
    elseif radioStatus ~= nil then
        if (radioStatus == true or radioStatus == 2) and VehicleRadio[vehicle].isEnabled == false then
            if VehicleRadio[vehicle].track == nil then
                VehicleRadio[vehicle].track = sr.CreateSound3D(v_radios[VehicleRadio[vehicle].CurrentRadio].url, x, y, z, 800.0)
                sr.SetSound3DVolume(VehicleRadio[vehicle].track, VehicleRadio[vehicle].volume)
                VehicleRadio[vehicle].isEnabled = true
            end
        elseif (radioStatus == false or radioStatus == 2) and VehicleRadio[vehicle].isEnabled == true then
            sr.DestroySound3D(VehicleRadio[vehicle].track)
            VehicleRadio[vehicle].track = nil
            VehicleRadio[vehicle].isEnabled = false
        end
    end

    SetVehiclePropertyValue(vehicle, "RadioPause", VehicleRadio[vehicle].isEnabled, true)
end)

CreateTimer(function()
    for k, v in pairs(VehicleRadio) do
        local vehicle = v.vehicle
        local pos = GetVehicleLocation(vehicle)
        if IsValidVehicle(vehicle) and VehicleRadio[vehicle] ~= nil and VehicleRadio[vehicle].track ~= nil then
            local x, y, z = GetVehicleLocation(vehicle)
            sr.SetSound3DLocation(VehicleRadio[vehicle].track, x, y, z)
            VehicleRadio[vehicle].LastPos = pos
        end
    end
end, 100)

-- PlayerExitDamage
AddRemoteEvent("OnPlayerExitDamage", function(player, speed)
    if speed > 15 then
        local calcul = speed/1.5
        sethealth(player, GetPlayerHealth(player) - calcul)
    end
end)

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

function GetVehiclesDataByVehicleID(VehicleID)
	local found = 0
	for i, vehicle in pairs(VehicleDB) do
		if tonumber(vehicle.id) == tonumber(VehicleID) then
			found = vehicle
			break
		end
	end
	return found
end

function GetSpeedVehicle(vehicle) -- Impossible de savoir si le véhicle et en marche avant ou arriere
    local x, y, z = GetVehicleVelocity(vehicle)
    local len = math.sqrt(x * x + y * y + z * z)
    local kmh = string.sub(math.ceil(len * 36.0), 0, 2)
    if tonumber(kmh) > 99 then
        kmh = string.sub(kmh, 0, 3)
    end
    return kmh
end