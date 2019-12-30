AddEvent("OnKeyRelease", function(key)
    if key == "F4" then
        CallRemoteEvent("OpenAdminContext")
    end
end)

function AdminOpenMenu(player)
    CallRemoteEvent("UpdateWeight", SView.SetAdminVisibility())
end
AddRemoteEvent("AdminOpenMenu",  AdminOpenMenu)
