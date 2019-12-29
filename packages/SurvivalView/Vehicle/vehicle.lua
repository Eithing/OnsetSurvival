function SetVehicleVisibility()
    if GetWebVisibility(VehicleHud) == WEB_HITINVISIBLE then
        SetVisibility(VehicleHud, "Hidden")
    else
        SetVisibility(VehicleHud, "HitInvisible")
    end
end
AddFunctionExport("SetVehicleVisibility", SetVehicleVisibility)