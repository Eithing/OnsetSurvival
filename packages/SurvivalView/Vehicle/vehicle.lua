function SetVehicleVisibility()
    if GetWebVisibility(VehicleHud) == WEB_HITINVISIBLE then
        SetVisibility(VehicleHud, "Hidden")
        return false
    else
        SetVisibility(VehicleHud, "HitInvisible")
        return true
    end
end
AddFunctionExport("SetVehicleVisibility", SetVehicleVisibility)

function SetRadioVisibility()
    if GetWebVisibility(VehicleHud) == WEB_VISIBLE then
        SetVisibility(VehicleHud, "HitInvisible")
        ShowMouseCursor(false)
        SetIgnoreLookInput(false)
        SetIgnoreMoveInput(false)
        SetInputMode(INPUT_GAME)
        ExecuteJs("vehicle", "expand()")
        return true
    else
        SetVisibility(VehicleHud, "VisibleMove")
        ExecuteJs("vehicle", "expand()")
        return true
    end
end
AddFunctionExport("SetRadioVisibility", SetRadioVisibility)

AddEvent("OnChangeRadio", function(id)
    SViewModel.ExecuteFromServer("radio:getplayersinvehicle", nil, nil, tonumber(id))
end)

AddEvent("OnChangePause", function()
    local vehicle = SViewModel.GetVehicleInData()
    if vehicle ~= false then
        SViewModel.ExecuteFromServer("radio:getplayersinvehicle", vehicle.RadioStatus)
    end
end)

AddEvent("OnChangeVolume", function(type)
    SViewModel.ExecuteFromServer("radio:getplayersinvehicle", nil, tonumber(type))
end)

AddEvent("SetRadioVisibility", function()
    CallRemoteEvent("UpdateWeight", SetRadioVisibility())
end)