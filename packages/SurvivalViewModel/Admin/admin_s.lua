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
		VehicleData[vehicle] = {}
		VehicleData[vehicle].fuel = 100
		SetVehicleHealth(vehicle, 1500)
	end
end)

function cmd_commands(player)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
		local x, y, z = GetPlayerLocation(player)
		AddPlayerChat(player, "x = "..x..",y = "..y..",z = "..z)
		
		print("x = "..x..",y = "..y..",z = "..z)
	end
	return
end
AddCommand("pos", cmd_commands)

function respawn_commands(player) -- Commande pour pouvoir ce re TP au niveau de la station service (Pour le bug de passage sous la map)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
		SetPlayerLocation(player, 125773.000000, 80246.000000, 1645.000000)
		print("Admin : Téléportation validé")
	end
	return
end
AddCommand("respawn", respawn_commands)