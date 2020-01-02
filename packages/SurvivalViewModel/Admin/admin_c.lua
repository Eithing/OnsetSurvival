AddEvent("OnKeyRelease", function(key)
    if key == "F4" then
        CallRemoteEvent("OpenAdminContext")
    end
end)

function AdminOpenMenu(player)
    SView.SetAdminVisibility()
end
AddRemoteEvent("AdminOpenMenu",  AdminOpenMenu)