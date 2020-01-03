AddEvent("OnKeyPress", function(key)
	CallRemoteEvent("OnKeyPressed")
end)

AddEvent("OnKeyRelease", function(key)
	CallRemoteEvent("OnKeyReleased")
end)

function OnUpdateVitalIndicator(health, eat, drink)
    --AddPlayerChat(health.." || "..eat.." || "..drink)    FO DEBUG "hunger / thirst"  TODO 
	SView.ExecuteJs("vitalIndicator", "UpdateVital("..health..","..eat..","..drink..")")
end
AddRemoteEvent("OnUpdateVitalIndicator",  OnUpdateVitalIndicator)

