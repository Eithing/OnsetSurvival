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
AddEvent("SetRadioVisibility", SetRadioVisibility)


AddEvent("OnChangeRadio", function(id)
    SetRadioVisibility()
    SViewModel.ExecuteFromServer("radio:getplayersinvehicle", nil, nil, tonumber(id))
end)
