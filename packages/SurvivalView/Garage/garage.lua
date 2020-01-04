function SetGarageVisibility()
    if GetWebVisibility(garageHud) == WEB_VISIBLE then
        SetVisibility(garageHud, "Hidden")
        return false
    else
        SetVisibility(garageHud, "VisibleStatic")
        return true
    end
end
AddFunctionExport("SetGarageVisibility", SetGarageVisibility)
AddEvent("SetGarageVisibility",  SetGarageVisibility)

AddEvent("OnSpawnVehicle", function(id)
    SetGarageVisibility()
    SViewModel.ExecuteFromServer("SpawnVehicleFromGarage", math.floor(id))
end)