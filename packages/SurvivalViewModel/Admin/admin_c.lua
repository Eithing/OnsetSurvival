AddEvent("OnKeyRelease", function(key)
    if key == "F4" then
        CallRemoteEvent("OpenAdminContext")
    end
end)

function AdminOpenMenu(player)
    RemoveAllHud("admin")
    CallRemoteEvent("UpdateWeight", SView.SetAdminVisibility())
end
AddRemoteEvent("AdminOpenMenu",  AdminOpenMenu)