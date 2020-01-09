AddEvent("OnKeyRelease", function(key)
    if key == "F3" then
        RemoveAllHud("craft")
        CallRemoteEvent("UpdateWeight", SView.SetCraftVisibility())
    end
end)