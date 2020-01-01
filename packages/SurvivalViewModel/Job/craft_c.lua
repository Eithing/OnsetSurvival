AddEvent("OnKeyRelease", function(key)
    if key == "F3" then
        if(GetPlayerPropertyValue(GetPlayerId(), "PlayerIsCharged") == true)then
            CallRemoteEvent("UpdateWeight", SView.SetCraftVisibility())
        end
    end
end)