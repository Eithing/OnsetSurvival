function SetVehicleVisibility()
    if GetWebVisibility(VehicleHud) == WEB_VISIBLE then
        SetVisibility(VehicleHud, "Hidden")
    else
        SetVisibility(VehicleHud, "VisibleStatic")
    end
end
AddFunctionExport("SetVehicleVisibility", SetVehicleVisibility)