AddEvent("OnKeyPress", function(key)
	CallRemoteEvent("OnKeyPressed")
end)

AddEvent("OnKeyRelease", function(key)
	CallRemoteEvent("OnKeyReleased")
end)

function OnUpdateVitalIndicator(health, eat, drink)
    AddPlayerChat("message")
    AddPlayerChat(health..eat..drink)
	SView.ExecuteJs("vitalIndicator", "UpdateVital("..health..","..eat..","..drink..")")
end
AddRemoteEvent("OnUpdateVitalIndicator",  OnUpdateVitalIndicator)
