local compteur = {}

AddEvent("OnPlayerDamage", function(player, damagetype, amount)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end)

AddEvent("OnPlayerSpawn", function(player)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), 100, 100)
end)

local function PlayerChargeHud(player)
	if PlayerData[player] == nil or PlayerData[player].hunger == nil or PlayerData[player].thirst == nil then
		Delay(500, function()
			PlayerChargeHud(player)
		end)
	else
		CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
		return
	end
end

AddRemoteEvent("OnPlayerHudLoadComplete", function(player)
	PlayerChargeHud(player)
end)

AddEvent("OnPlayerQuit", function(player)
    compteur[player] = nil
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
			if PlayerData[v].vitalnotif == false then
				PlayerData[v].vitalnotif = true
				AddNotification(v, "Vous avez besoin de boire ou manger !", "error")

				Delay((p_delayvitalnotif*1000), function()
					PlayerData[v].vitalnotif = false
				end)
			end
			SetPlayerHealth(v, GetPlayerHealth(v) - 1)
		end
		CallRemoteEvent(v, "OnUpdateVitalIndicator", GetPlayerHealth(v), PlayerData[v].hunger, PlayerData[v].thirst)
	end
end, '30000' , UpdateVital)

AddEvent("OnPlayerDeath", function(player, instigator)
	PlayerData[player].hunger = p_defaulthunger
	PlayerData[player].thirst = p_defaultthirst
	PlayerData[player].health = p_defaulthealth
	PlayerData[player].vitalnotif = false

    CallRemoteEvent(player, "OnUpdateVitalIndicator", 0, PlayerData[player].hunger, PlayerData[player].thirst)
    compteur[player] = nil
end)

AddRemoteEvent("OnKeyPressed", function(player)
    Delay(200, function()
        if GetPlayerMovementMode(player) == 3 then
            if compteur[player] ~= nil then
                compteur[player].isRunning = 0
				compteur[player].calculedTime =  compteur[player].calculedTime + (GetTimeSeconds() - compteur[player].time)
				compteur[player].time = GetTimeSeconds()
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

function sethealth(player, count)
	PlayerData[player].health = math.clamp(count,0,100)
	SetPlayerHealth(player, math.clamp(count,0,100))
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end

function sethunger(player, count)
	PlayerData[player].hunger = math.clamp(count,0,p_defaulthunger)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end

function setthirst(player, count)
	PlayerData[player].thirst = math.clamp(count,0,p_defaultthirst)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end

function addhealth(player, count)
	PlayerData[player].health = math.clamp(GetPlayerHealth(player)+count,0,100)
	SetPlayerHealth(player, PlayerData[player].health)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end

function addhunger(player, count)
	PlayerData[player].hunger = math.clamp(PlayerData[player].hunger+count,0,p_defaulthunger)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end

function addthirst(player, count)
	PlayerData[player].thirst = math.clamp(PlayerData[player].thirst+count,0,p_defaultthirst)
	CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
end