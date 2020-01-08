function OnUpdateFuel(fuel)
	SView.ExecuteJs("vehicle", "UpdateFuel("..fuel..")")
end
AddRemoteEvent("OnUpdateFuel",  OnUpdateFuel)

function OnUpdateRadio(radio)
    SView.ExecuteJs("vehicle", "UpdateRadio('"..tostring(radio).."')")
end
AddRemoteEvent("OnUpdateRadio",  OnUpdateRadio)

AddRemoteEvent("OnUpdateVehicleHud", function()
    CallRemoteEvent("UpdateWeight", SView.SetVehicleVisibility())
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

AddEvent("OnPlayerEnterVehicle", function(player, vehicle, seat)
    -- CallRemoteEvent("radio:getplayersinvehicle", true)
end)

AddEvent("OnPlayerStartExitVehicle", function(vehicle)
    -- CallRemoteEvent("radio:getplayersinvehicle", false)
end)