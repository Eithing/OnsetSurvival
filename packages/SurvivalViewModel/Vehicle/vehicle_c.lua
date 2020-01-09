function OnUpdateFuel(fuel)
	SView.ExecuteJs("vehicle", "UpdateFuel("..fuel..")")
end
AddRemoteEvent("OnUpdateFuel",  OnUpdateFuel)

function OnUpdateRadio(id, radio)
    SView.ExecuteJs("vehicle", "UpdateRadio('"..tostring(radio).."')")
    SView.ExecuteJs("vehicle", "setChannel("..tonumber(id)..")")
end
AddRemoteEvent("OnUpdateRadio",  OnUpdateRadio)

AddRemoteEvent("OnUpdateVehicleHud", function()
    CallRemoteEvent("UpdateWeight", SView.SetVehicleVisibility())
    SetVehicleInfo()
end)

-- Enter - Exit Véhicle
local EnterExitVar = {
    notif = false,
    delay = 5
}
function OnPlayerStartEnterVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") == true then
        if EnterExitVar.notif == false then 
            AddNotification("Véhicule verrouillé !", "error", EnterExitVar.delay)
            EnterExitVar.notif = true
            Delay(math.Seconds(EnterExitVar.delay), function()
                EnterExitVar.notif = false
            end)
        end
        return false 
    end 
end
AddEvent("OnPlayerStartEnterVehicle", OnPlayerStartEnterVehicle)

function OnPlayerStartExitVehicle(vehicle)
    if GetVehiclePropertyValue(vehicle, "locked") == true then 
        if EnterExitVar.notif == false then
            AddNotification("Véhicule verrouillé !", "error", EnterExitVar.delay)
            EnterExitVar.notif = true
            Delay(math.Seconds(EnterExitVar.delay), function()
                EnterExitVar.notif = false
            end)
        end
        return false 
    end 

    local speed = math.tointeger(math.floor(GetVehicleForwardSpeed(vehicle)))
    CallRemoteEvent("OnPlayerExitDamage", speed)
end
AddEvent("OnPlayerStartExitVehicle", OnPlayerStartExitVehicle)

-- Changement de place dans un véhicle
local Seats = {
    {key = "Ampersand", seat = 1},
    {key = "é", seat = 2},
    {key = "Quote", seat = 3},
    {key = "Apostrophe", seat = 4}
}
local SeatsVar = {
    bool = false,
    delay = 1
}
function OnKeyPress(key)
	if PlayerIsInVehicle() == false then
		return
    end
    if SeatsVar.bool == true then
        return
    end
    for k, v in pairs(Seats) do
        if key == v.key then
            CallRemoteEvent("ChangeSeat", v.seat)
            SeatsVar.bool = true
            Delay(math.Seconds(SeatsVar.delay), function()
                SeatsVar.bool = false
            end)
            break
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

--[[ RADIO SYSTEM - github.com/frederic2ec/onsetrp/blob/master/vehicle_radio ]]
local VehRadio = {}
local radiohud = false
AddEvent("OnKeyPress", function(key)
    if PlayerIsInVehicle() == false then
		return
    end
    local vehicle = GetPlayerVehicle()
    if IsCtrlPressed() == false and key == 'R' and radiohud == false then
        CallRemoteEvent("UpdateWeight", SView.SetRadioVisibility())
        radiohud = true
        Delay(math.Seconds(1), function()
            radiohud = false
        end)
    end
    -- Radio ON/OFF    
    if IsCtrlPressed() and key == 'R' then
        CallRemoteEvent("radio:getplayersinvehicle", VehRadio[vehicle].RadioStatus)
        SetVehicleInfo()
    end

    -- Radio volume
    if VehRadio[vehicle].RadioStatus == 1 and key == 'Num +' then        
        CallRemoteEvent("radio:getplayersinvehicle", VehRadio[vehicle].RadioStatus, 1)
    elseif VehRadio[vehicle].RadioStatus == 1 and key == 'Num -' then        
        CallRemoteEvent("radio:getplayersinvehicle", VehRadio[vehicle].RadioStatus, 0)
    end
end)

AddEvent("OnPlayerEnterVehicle", function(player, vehicle, seat)
    if VehRadio[vehicle] == nil then
        VehRadio[vehicle] = {}
        VehRadio[vehicle].Vehicle = vehicle
        VehRadio[vehicle].RadioStatus = 0
        VehRadio[vehicle].Track = nil
        VehRadio[vehicle].CurrentRadio = 1
        VehRadio[vehicle].Volume = 0.5
    end
    if VehRadio[vehicle].RadioStatus == 1 then
        StartRadio(vehicle)
    end
end)

AddEvent("OnPlayerStartExitVehicle", function(vehicle)
    -- StopRadio(vehicle)
end)

AddRemoteEvent("radio:switchtrack3d", function(vehicle)
    if VehRadio[vehicle] == nil then
        VehRadio[vehicle] = {}
        VehRadio[vehicle].Vehicle = vehicle
        VehRadio[vehicle].RadioStatus = 1
        VehRadio[vehicle].Track = nil
        VehRadio[vehicle].CurrentRadio = 1
        VehRadio[vehicle].Volume = 0.5
    end
    if VehRadio[vehicle].Track ~= nil then
        DestroySound(VehRadio[vehicle].Track)
    end
    if VehRadio[vehicle].RadioStatus == 1 then
        local x, y, z = GetVehicleLocation(vehicle)
        VehRadio[vehicle].Track = CreateSound3D(v_radios[VehRadio[vehicle].CurrentRadio].url, x, y, z, 600)
        SetSoundVolume(VehRadio[vehicle].Track, VehRadio[vehicle].Volume)
    end
end)

AddRemoteEvent("radio:turnonradio", function(vehicle)
    StartRadio(vehicle)
end)

AddRemoteEvent("radio:turnoffradio", function(vehicle)
    StopRadio(vehicle)
    VehRadio[vehicle].RadioStatus = 0
end)

AddRemoteEvent("radio:setvolume", function(vehicle, volume)
    if VehRadio[vehicle] ~= nil then
        SetVolume(vehicle, volume)
    end
end)

AddRemoteEvent("radio:setchannel", function(vehicle, channel)
    if VehRadio[vehicle] ~= nil then
        SetChannel(vehicle, channel)
    end
end)

AddRemoteEvent("radio:EnterRadio", function(vehicle)
    if VehRadio[vehicle] ~= nil then
        OnUpdateRadio(VehRadio[vehicle].CurrentRadio, v_radios[VehRadio[vehicle].CurrentRadio].label)
    end
end)

function StartRadio(vehicle)
    if VehRadio[vehicle] == nil then
        VehRadio[vehicle] = {}
        VehRadio[vehicle].CurrentRadio = 1
        VehRadio[vehicle].Volume = 0.5
    end

    if VehRadio[vehicle] ~= nil and VehRadio[vehicle].Track ~= nil then
        DestroySound(VehRadio[vehicle].Track)
    end

    VehRadio[vehicle].RadioStatus = 1
    VehRadio[vehicle].Vehicle = vehicle
    VehRadio[vehicle].Track = nil
    
    VehRadio[vehicle].Track = CreateSound(v_radios[VehRadio[vehicle].CurrentRadio].url)
    SetSoundVolume(VehRadio[vehicle].Track, VehRadio[vehicle].Volume)
    OnUpdateRadio(VehRadio[vehicle].CurrentRadio, v_radios[VehRadio[vehicle].CurrentRadio].label)
end

function StopRadio(vehicle)
    if VehRadio[vehicle] ~= nil then
        if VehRadio[vehicle].Track ~= nil then
            DestroySound(VehRadio[vehicle].Track)
        end
        VehRadio[vehicle].Track = nil
        VehRadio[vehicle].Vehicle = nil
    end
end

function SetVolume(vehicle, volume)
    if volume == 1 and VehRadio[vehicle].Volume < 1.0 then --Monte le son
        VehRadio[vehicle].Volume = VehRadio[vehicle].Volume + 0.1
        SetSoundVolume(VehRadio[vehicle].Track, VehRadio[vehicle].Volume)
    elseif volume == 0 and VehRadio[vehicle].Volume > 0.0 then -- baisse le son
        VehRadio[vehicle].Volume = VehRadio[vehicle].Volume - 0.1
        SetSoundVolume(VehRadio[vehicle].Track, VehRadio[vehicle].Volume)
    end
end

function SetChannel(vehicle, channel)    
    if VehRadio[vehicle] ~= nil and VehRadio[vehicle].Track ~= nil then
        DestroySound(VehRadio[vehicle].Track)
    end
    VehRadio[vehicle].CurrentRadio = channel  
    
    VehRadio[vehicle].Track = CreateSound(v_radios[VehRadio[vehicle].CurrentRadio].url)
    SetSoundVolume(VehRadio[vehicle].Track, VehRadio[vehicle].Volume)
    OnUpdateRadio(VehRadio[vehicle].CurrentRadio, v_radios[VehRadio[vehicle].CurrentRadio].label)
end

AddEvent("OnVehicleStreamOut", function(vehicle, player)
    if VehRadio[vehicle] ~= nil then
        StopRadio(vehicle)
        VehRadio[vehicle] = nil
    end
end)

function GetVehicleInData()
    if PlayerIsInVehicle() == false then
		return false
    end
    local vehicle = GetPlayerVehicle()
    if VehRadio[vehicle] == nil then
        return false
    end
    return VehRadio[vehicle]
end
AddFunctionExport("GetVehicleInData", GetVehicleInData)


CreateTimer(function()
    SetVehicleInfo()
end, math.Seconds(1))

function SetVehicleInfo()
    if PlayerIsInVehicle() == false then
		return
    end
    local speed = math.tointeger(math.floor(GetVehicleForwardSpeed(GetPlayerVehicle())))
    if speed <= 0 then
        return
    end
    SView.ExecuteJs("vehicle", "UpdateSpeed('"..tostring(speed).."')")
    local x, y, z = GetVehicleLocation(GetPlayerVehicle())
    SView.ExecuteJs("vehicle", 'UpdatePos("'..math.ceil(x)..'","'..math.ceil(y)..'","'..math.ceil(z)..'")')
    local vehhealth = math.ceil(GetVehicleHealth(GetPlayerVehicle()) )
    SView.ExecuteJs("vehicle", "UpdateHealth('"..tostring(vehhealth).."')")
end