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