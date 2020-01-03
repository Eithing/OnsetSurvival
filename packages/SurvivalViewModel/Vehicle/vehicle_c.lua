function OnUpdateFuel(fuel)
	SView.ExecuteJs("vehicle", "UpdateFuel("..fuel..")")
end
AddRemoteEvent("OnUpdateFuel",  OnUpdateFuel)

AddRemoteEvent("OnUpdateVehicleHud", function()
    SView.SetVehicleVisibility()
end)