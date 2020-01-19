function OnUpdateFuel(fuel)
	SView.ExecuteJs("vehicle", "UpdateFuel("..fuel..")")
end
AddRemoteEvent("OnUpdateFuel",  OnUpdateFuel)

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
local radiohud = false
local VehRadio = {}
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
        CallRemoteEvent("radio:getplayersinvehicle", 2)
    end

    -- Radio volume
    if key == 'Num +' then        
        CallRemoteEvent("radio:getplayersinvehicle", nil, 1)
    elseif key == 'Num -' then        
        CallRemoteEvent("radio:getplayersinvehicle", nil, 0)
    end
end)

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

function OnUpdateRadio(radio, id)
    SView.ExecuteJs("vehicle", "UpdateRadio('"..tostring(radio).."')")
    SView.ExecuteJs("vehicle", "setChannel("..tonumber(id)..")")
end
AddRemoteEvent("OnUpdateRadio",  OnUpdateRadio)