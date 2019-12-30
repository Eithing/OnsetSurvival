AddEvent("OnKeyRelease", function(key)
    if key == "F3" then
        CallRemoteEvent("UpdateWeight", SView.SetCraftVisibility())
    end
end)