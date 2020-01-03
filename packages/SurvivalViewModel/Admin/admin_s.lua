AddRemoteEvent("OpenAdminContext", function(player)
	if IsAdmin(player) then
		CallRemoteEvent(player, "AdminOpenMenu")
	end
end)

AddRemoteEvent("OnAdminAction", function(player, context, actionId)
	if IsAdmin(player) then
		if(context == "weapons")then
			SetPlayerWeapon(player, actionId, 999, true, 1)

		elseif(context == "cars")then
			local x, y, z = GetPlayerLocation(player)
			local h = GetPlayerHeading(player)
			local vehicle = CreateVehicle(actionId, x, y, z, h)
			SetPlayerInVehicle(player, vehicle)
			SetVehicleHealth(vehicle, 1500)
			SetVehicleRespawnParams(vehicle, false)
		end
	end
end)

-- Position
function pos_commands(player)
	if IsAdmin(player) then
		local x, y, z = GetPlayerLocation(player)
		AddPlayerChat(player, "x = "..x..",y = "..y..",z = "..z)
		
		print("x = "..x..",y = "..y..",z = "..z)
	end
	return
end
AddCommand("pos", pos_commands)

-- Kill
function kill_commands(player)
	if IsAdmin(player) then
		SetPlayerHealth(player, 0)
		print("Admin : Player kill "..player)
	end
	return
end
AddCommand("kill", kill_commands)

-- Health
function health_commands(player, health)
	count = tonumber(health)
	if IsAdmin(player) then
		SetPlayerHealth(player, health)
		print("Admin : Vie set = "..health)
	end
	return
end
AddCommand("health", health_commands)

-- Armor
function armor_commands(player, armor)
	count = tonumber(armor)
	if IsAdmin(player) then
		SetPlayerArmor(player, armor)
		print("Admin : Armure set = "..armor)
	end
	return
end
AddCommand("armor", armor_commands)

-- Faim
function sethunger_commands(player, count)
	count = tonumber(count)
    if IsAdmin(player) then
	    sethunger(player, count)
        print("Admin : Faim set = "..count)
    end
	return
end
AddCommand("sethunger", sethunger_commands)

-- Soif
function setthirst_commands(player, count)
	count = tonumber(count)
    if IsAdmin(player) then
	    setthirst(player, count)
        print("Admin : Soif set = "..count)
    end
	return
end
AddCommand("setthirst", setthirst_commands)

-- Spawn un npc
function npc_commands(player)
	if IsAdmin(player) then
		local x, y, z = GetPlayerLocation(player)
		local npc = CreateNPC(x+100, y, z, 84.066261291504)
		Delay(180000, function()
			if IsValidNPC(npc) then
				DestroyNPC(npc)
			end
		end)
		
	end
end
AddCommand("npc", npc_commands)


-- Teleportation --
function spawn_commands(player) -- Commande pour pouvoir ce re TP au niveau de la station service (Pour le bug de passage sous la map)
	if IsAdmin(player) then
		SetPlayerLocation(player, 125773.000000, 80246.000000, 1645.000000+250)
		print("Admin : Téléportation validé")
	end
	return
end
AddCommand("spawn", spawn_commands)

-- Se teleporter a un joueur
function goto_command(player, player2)
	if IsAdmin(player) then
		if IsValidPlayer(player2) then
			local x, y, z = GetPlayerLocation(player2)
			z = z + 30
			SetPlayerLocation(player, x, y, z)
			print("Admin : "..player.." goto "..player2)
		else
			print("Admin : Aucun joueur trouvée")
		end
	end
end
AddCommand("goto", goto_command)

-- Essence --
function addfuel_commands(player, count)
	count = tonumber(count)
    if IsAdmin(player) then
	    AddFuel(GetPlayerVehicle(player), count)
        print("Admin : Essence ajoutée")
    end
	return
end
AddCommand("addfuel", addfuel_commands)

function consumefuel_commands(player, count)
	count = tonumber(count)
    if IsAdmin(player) then
	    ConsumeFuel(GetPlayerVehicle(player), count)
        print("Admin : Essence consumée")
    end
	return
end
AddCommand("consumefuel", consumefuel_commands)

function setfuel_commands(player, count)
	count = tonumber(count)
    if IsAdmin(player) then
	    SetFuel(GetPlayerVehicle(player), count)
        print("Admin : Essence set = "..count)
    end
	return
end
AddCommand("setfuel", setfuel_commands)