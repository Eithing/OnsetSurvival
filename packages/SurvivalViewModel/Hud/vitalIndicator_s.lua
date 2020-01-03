local compteur = {}

AddEvent("OnPlayerDamage", function(player, damagetype, amount)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end)

AddEvent("OnPlayerSteamAuth", function(player)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end)


CreateTimer(function(UpdateVital)
	for _, v in pairs(GetAllPlayers()) do
		local toRemove = 0.4
		if compteur[v] ~= nil then
			if compteur[v].isRunning == 1 then
				compteur[v].calculedTime = compteur[v].calculedTime + (GetTimeSeconds() - compteur[v].time)
				compteur[v].time = GetTimeSeconds()
			end
			local percent = (compteur[v].calculedTime * 100) / 30
			toRemove = ((percent * 1.3) / 100) + 0.4
			compteur[v].calculedTime = 0
        end
		if tonumber(PlayerData[v].hunger) > 0 then
			PlayerData[v].hunger = math.clamp((PlayerData[v].hunger - toRemove), 0, 100) 
		end
		if tonumber(PlayerData[v].thirst) > 0 then
			PlayerData[v].thirst = math.clamp((PlayerData[v].thirst - toRemove), 0, 100) 
		end
		if tonumber(PlayerData[v].hunger) <= 0 or tonumber(PlayerData[v].thirst) <= 0 then
			SetPlayerHealth(v, GetPlayerHealth(player) - 1)
		end
		CallRemoteEvent(v, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[v].hunger, PlayerData[v].thirst)
	end
end, '30000' , UpdateVital)

AddEvent("OnPlayerDeath", function(player, instigator)
	PlayerData[player].hunger = p_defaulthunger
	PlayerData[player].thirst = p_defaultthirst
	PlayerData[player].health = p_defaulthealth
end)

AddRemoteEvent("OnKeyPressed", function(player)
    Delay(200, function()
        if GetPlayerMovementMode(player) == 3 then
            if compteur[player] ~= nil then
                compteur[player].isRunning = 1
            else
                compteur[player] = {time = GetTimeSeconds(),
                                    isRunning = 1,
                                    calculedTime = 0}
            end
        end
    end)
end)

AddRemoteEvent("OnKeyReleased", function(player)
    Delay(200, function()
        if GetPlayerMovementMode(player) ~= 3 then
			if compteur[player] ~= nil and compteur[player].isRunning == 1 then
				compteur[player].isRunning = 0
				compteur[player].calculedTime =  compteur[player].calculedTime + (GetTimeSeconds() - compteur[player].time)
				compteur[player].time = GetTimeSeconds()
			end
		end
    end)
end)