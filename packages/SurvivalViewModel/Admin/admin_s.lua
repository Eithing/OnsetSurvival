AddRemoteEvent("OpenAdminContext", function(player)
	if UserData[tostring(GetPlayerSteamId(player))].admin then
		CallRemoteEvent(player, "AdminOpenMenu")
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

function cmd_commands(player)
	local x, y, z = GetPlayerLocation(player)
	AddPlayerChat(player, "x = "..x..",y = "..y..",z = "..z)
	
	print("x = "..x..",y = "..y..",z = "..z)
	return
end
AddCommand("pos", cmd_commands)