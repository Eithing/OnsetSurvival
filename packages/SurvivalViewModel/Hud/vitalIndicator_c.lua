AddEvent("OnKeyPress", function(key)
	CallRemoteEvent("OnKeyPressed")
end)

AddEvent("OnKeyRelease", function(key)
	CallRemoteEvent("OnKeyReleased")
end)

function OnGetHealthUpdated(player)
	SView.ExecuteJs("vitalIndicator", "ChangeColor("..GetPlayerHealth()..")")
end
AddRemoteEvent("OnGetHealthUpdated",  OnGetHealthUpdated)

function OnUpdateVitalIndicator(eat, drink)
	SView.ExecuteJs("vitalIndicator", "UpdateVital("..eat..","..drink..")")
end
AddRemoteEvent("OnUpdateVitalIndicator",  OnUpdateVitalIndicator)

AddEvent("OnPlayerSpawn", function(player)
	OnGetHealthUpdated()
end)
