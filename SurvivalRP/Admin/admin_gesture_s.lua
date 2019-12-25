AddRemoteEvent("OpenAdminContext", function(player)
	for i, user in ipairs(UserData) do
		if user.steamId == tostring(GetPlayerSteamId(player)) then
			if tonumber(user.admin) == 1 then
				CallRemoteEvent(player, "AdminOpenMenu")
			end
			return
		end
	end
end)

AddRemoteEvent("OnAdminAction", function(player, context, actionId)
	if(context == "weapons")then
		SetPlayerWeapon(player, actionId, 999, true, 1)
	elseif(context == "cars")then
		local x, y, z = GetPlayerLocation(player)
        local h = GetPlayerHeading(player)
        local vehicle = CreateVehicle(actionId, x, y, z, h)
        SetPlayerInVehicle(player, vehicle)
	end
end)

function cmd_restartpack(player, package_)
	StopPackage(package_)

	Delay(500, function()
		StartPackage(package_)
	end)
end
AddCommand("reloadpack", cmd_restartpack)


