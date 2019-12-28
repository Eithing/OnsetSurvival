local compteur = {}

AddEvent("OnPlayerDamage", function(player, damagetype, amount)
	CallRemoteEvent(player, "OnGetHealthUpdated")
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

		if tonumber(UserData[tostring(GetPlayerSteamId(v))].eat) > 0 then
			UserData[tostring(GetPlayerSteamId(v))].eat = UserData[tostring(GetPlayerSteamId(v))].eat - toRemove
		end
		if tonumber(UserData[tostring(GetPlayerSteamId(v))].drink) > 0 then
			UserData[tostring(GetPlayerSteamId(v))].drink = UserData[tostring(GetPlayerSteamId(v))].drink - toRemove
		end
		if tonumber(UserData[tostring(GetPlayerSteamId(v))].eat) == 0 or tonumber(UserData[tostring(GetPlayerSteamId(v))].drink) == 0 then
			UserData[tostring(GetPlayerSteamId(v))].health = UserData[tostring(GetPlayerSteamId(v))].health - 1
			SetPlayerHealth(v, UserData[tostring(GetPlayerSteamId(v))].health)
			CallRemoteEvent(v, "OnGetHealthUpdated")
		end
		CallRemoteEvent(v, "OnUpdateVitalIndicator", UserData[tostring(GetPlayerSteamId(v))].eat, UserData[tostring(GetPlayerSteamId(v))].drink)
	end
end, '30000' , UpdateVital)

AddEvent("OnPlayerDeath", function(player, instigator)
	UserData[tostring(GetPlayerSteamId(player))].eat = 100
	UserData[tostring(GetPlayerSteamId(player))].drink = 100
	UserData[tostring(GetPlayerSteamId(player))].health = 100
end)

AddRemoteEvent("OnKeyPressed", function(player)
	CreateCountTimer(function(await)
		if GetPlayerMovementMode(player) == 3 then
			if compteur[player] ~= nil then
				compteur[player].isRunning = 1
			else
				compteur[player] = {time = GetTimeSeconds(),
									isRunning = 1,
									calculedTime = 0}
			end
		end
	end, 200, 1)
end)

AddRemoteEvent("OnKeyReleased", function(player)
	CreateCountTimer(function(await)
		if GetPlayerMovementMode(player) ~= 3 then
			if compteur[player] ~= nil and compteur[player].isRunning == 1 then
				compteur[player].isRunning = 0
				compteur[player].calculedTime =  compteur[player].calculedTime + (GetTimeSeconds() - compteur[player].time)
				compteur[player].time = GetTimeSeconds()
			end
		end
	end, 200, 1)
end)

AddCommand("kill", function(player, damage) SetPlayerHealth(player, 0) end)