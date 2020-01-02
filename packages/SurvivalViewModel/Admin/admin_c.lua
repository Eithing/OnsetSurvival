AddEvent("OnKeyRelease", function(key)
    if key == "F4" then
        if(GetPlayerPropertyValue(GetPlayerId(), "PlayerIsCharged") == true)then
            CallRemoteEvent("OpenAdminContext")
        end
    end
end)

function AdminOpenMenu(player)
    CallRemoteEvent("UpdateWeight", SView.SetAdminVisibility())
end
AddRemoteEvent("AdminOpenMenu",  AdminOpenMenu)