AddRemoteEvent("OpenAdminContext", function(player)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
		CallRemoteEvent(player, "AdminOpenMenu")
	end
end)

AddRemoteEvent("OnAdminAction", function(player, context, actionId)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
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
	end
end)

function pos_commands(player)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
		local x, y, z = GetPlayerLocation(player)
		AddPlayerChat(player, "x = "..x..",y = "..y..",z = "..z)
		
		print("x = "..x..",y = "..y..",z = "..z)
	end
	return
end
AddCommand("pos", pos_commands)

--[[ function cmd_commandsNPC(player)
	local x, y, z = GetPlayerLocation(player)
	CreateNPC(x+100, y, z, 84.066261291504)
end
AddCommand("npc", cmd_commandsNPC) ]]

function spawn_commands(player) -- Commande pour pouvoir ce re TP au niveau de la station service (Pour le bug de passage sous la map)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
		SetPlayerLocation(player, 125773.000000, 80246.000000, 1645.000000)
		print("Admin : Téléportation validé")
	end
	return
end
AddCommand("spawn", spawn_commands)

-- Se teleporter a un joueur
function goTo(player, player2)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
		if IsValidPlayer(player2) then
			local x, y, z = GetPlayerLocation(player2)
			z = z + 30
			SetPlayerLocation(player, x, y, z)
		else
			AddPlayerChat(player, "Admin : Aucun joueur trouvée")
		end
	end
end
AddCommand("goto", goTo)

-- Teleporter un joueur a sois
function bring(player, player2)
	if tonumber(UserData[tostring(GetPlayerSteamId(player))].admin) == 1 then
		if IsValidPlayer(player2) then
			local x, y, z = GetPlayerLocation(player)
			x = x + 25
			y = y + 25
			SetPlayerLocation(player2, x, y, z)
			AddPlayerChat(player2, GetPlayerName(player).." vous a téléporter.")
		else
			AddPlayerChat(player, "Admin : Aucun joueur trouvée")
		end
	end
end
AddRemoteEvent("bring", bring)