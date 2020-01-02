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
AddEvent("SetGarageVisibility", SetGarageVisibility )

function OnSpawnVehicle(idUnique)
    CallRemoteEvent("UpdateWeight", SView.SetGarageVisibility())
    CallRemoteEvent("SpawnVehicle", idUnique)
    AddPlayerChat("OnSpawnVehicle")
end
AddEvent("OnSpawnVehicle", OnSpawnVehicle)