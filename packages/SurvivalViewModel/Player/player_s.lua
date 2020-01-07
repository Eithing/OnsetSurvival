function OnPackageStart()
    print("Player ServerSide Loaded (Save All toutes les "..s_SaveAll.."m)")
    -- Save all player data automatically 
    CreateTimer(function()
		for k, v in pairs(GetAllPlayers()) do
            SavePlayer(v)
		end
        print("All players have been saved !")
        
        for k, v in pairs(GetAllVehicles()) do
            if VehicleData[v] ~= nil then
                local playerveh = GetPlayerByCompteId(VehicleData[v].compteId)
                if playerveh ~= 0 then
                    SaveVehicule(v, playerveh, VehicleData[v].garageid)
                end
            end
		end
		print("All Vehicules have been saved !")
    end, s_SaveAll*60000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerSteamAuth(player)
    CreatePlayerData(player)

    OnLoadPlayer(player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

function OnPlayerQuit(player)
    SavePlayer(player)
    DestroyPlayerData(player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

AddEvent("OnPlayerSpawn", function(player)
    ChangeOtherPlayerClothes(player, player)
end)


-- Player Data --
function CreatePlayerData(player)
    if PlayerData[player] == nil then
        PlayerData[player] = {}

        PlayerData[player].id = 0
        PlayerData[player].steamid = GetPlayerSteamId(player)
        PlayerData[player].name = GetPlayerName(player)
        PlayerData[player].admin = 0
        PlayerData[player].health = 100
        PlayerData[player].armor = 100
        PlayerData[player].hunger = 100
        PlayerData[player].thirst = 100
        PlayerData[player].argent = 0
        PlayerData[player].inventory = {}
        PlayerData[player].clothing = {}
        PlayerData[player].onAction = false
        PlayerData[player].isActioned = false
        PlayerData[player].position = {}
        PlayerData[player].created = 0
        PlayerData[player].vitalnotif = false
        PlayerData[player].vehicles = {}
        PlayerData[player].IsInMaxWeight = false
        PlayerData[player].NotifWeight = false
        PlayerData[player].MaxWeight = i_maxWeight
        print("PlayerData created for : "..player)

        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR")
        table.insert(PlayerData[player].clothing, { 250, 240, 190, 1 })
        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR")
        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR")
        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR")

        ChangeOtherPlayerClothes(player, player)

        for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
            ChangeOtherPlayerClothes(k, player)
        end
    end
end

function OnLoadPlayer(player)
    local rows, result = SLogic.GetUserBySteamId(player)
    if rows > 0 then
        PlayerData[player].id = result.id
    end
    CheckForIPBan(player, rows, result)
end

function CheckForIPBan(player, lrowns, lresult)
	local rows, result = SLogic.GetBanIp(GetPlayerIP(player))
    
    if (rows == 0) then
		CheckForSteamIDBan(player, lrowns, lresult)
	elseif rows == 1 then
		print("Kicking "..tostring(GetPlayerSteamId(player))..", banned by IP ("..result.reason..")")
        
        KickPlayer(player, "🚨 Vous avez été ban de ce serveur ! (raison : "..result.reason..")")
	end
end

function CheckForSteamIDBan(player, lrowns, lresult)
	local rows, result = SLogic.GetBanSteamID(tostring(GetPlayerSteamId(player)))
    if (rows == 0) then
		--No IP ban found for this account
		if (PlayerData[player].id == 0) then
			CreatePlayerAccount(player)
		else
			LoadPlayerAccount(player, lrowns, lresult)
		end
	elseif rows == 1 then
		print("Kicking "..tostring(GetPlayerSteamId(player))..", banned by SteamID ("..result.reason..")")
        
        KickPlayer(player, "🚨 Vous avez été ban de ce serveur ! (raison : "..result.reason..")")
	end
end

function CreatePlayerAccount(player)
    PlayerData[player].id = SLogic.InsertNewUser(player, i_maxWeight)

	CallRemoteEvent(player, "DisplayCreateCharacter")

	setPositionAndSpawn(player, nil)

	print("PlayerID "..PlayerData[player].id.." a crée un compte ("..player..")")
end

function LoadPlayerAccount(player, rows, result)
	if (rows == 0) then
		--This case should not happen but still handle it
		KickPlayer(player, "An error occured while loading your account 😨")
	else
        PlayerData[player].steamid = tostring(result.steamid)
		PlayerData[player].name = tostring(result.name)
        PlayerData[player].position = SLogic.json_decode(result.position)
        PlayerData[player].health = math.tointeger(result.health)
        PlayerData[player].armor = math.tointeger(result.armor)
        PlayerData[player].hunger = math.tointeger(result.hunger)
        PlayerData[player].thirst = math.tointeger(result.thirst)
        PlayerData[player].argent = math.tointeger(result.argent)
		PlayerData[player].clothing = SLogic.json_decode(result.clothing)
		PlayerData[player].inventory = SLogic.GetPlayerInventory(PlayerData[player].id)
		PlayerData[player].admin = math.tointeger(result.admin)
        PlayerData[player].created = math.tointeger(result.created)
        local playervehicles_rows, playervehicles_r = SLogic.GetVehiclesBySteamId(PlayerData[player].id)
        PlayerData[player].vehicles = playervehicles_r
        PlayerData[player].IsInMaxWeight = false
        PlayerData[player].NotifWeight = false
        PlayerData[player].MaxWeight = math.tointeger(result.maxweight)

		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armor']))
		setPositionAndSpawn(player, PlayerData[player].position)

		if PlayerData[player].created == 0 then
			CallRemoteEvent(player, "DisplayCreateCharacter")
		else
			SetPlayerName(player, PlayerData[player].name)
		
			ChangeOtherPlayerClothes(player, player)
		end

        UpdateWeight(player, false)
        CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
        print("PlayerID "..PlayerData[player].id.." à charger son compte ("..GetPlayerIP(player)..")")
	end
end

function setPositionAndSpawn(player, position) 
	SetPlayerSpawnLocation(player, p_spawn.x, p_spawn.y, p_spawn.z, 0 )
    if position ~= nil and position.x ~= nil and position.y ~= nil and position.z ~= nil then
        PlayerTeleport(player, PlayerData[player].position.x, PlayerData[player].position.y, PlayerData[player].position.z)
        Delay(1, function()
            PlayerTeleport(player, PlayerData[player].position.x, PlayerData[player].position.y, PlayerData[player].position.z)
        end)
    else
        PlayerTeleport(player, p_spawn.x, p_spawn.y, p_spawn.z)
	end
end

function DestroyPlayerData(player)
	if (PlayerData[player] == nil) then
		return
	end

	PlayerData[player] = nil
	print("PlayerData destroyed for : "..player)
end

function SavePlayer(player)
	if (PlayerData[player] == nil) then
		return
	end

	if (PlayerData[player].id == 0) then
		return
	end


	-- Sauvegarde de la position du joueur
	local x, y, z = GetPlayerLocation(player)
    PlayerData[player].position = {x= x, y= y, z= z}
    
    PlayerData[player].health = GetPlayerHealth(player)
    
    PlayerData[player].armor = GetPlayerArmor(player)

	SLogic.UpdateUser(player, PlayerData[player])
    
    print("PlayerData saved for : "..player)

    AddNotification(player, "Votre personnage a bien été sauvegarder !", "success")
end

function IsAdmin(player)
	return PlayerData[player].admin == 1
end
AddFunctionExport("isAdmin", IsAdmin)

function ChangeOtherPlayerClothes(player, otherplayer)
    if PlayerData[otherplayer] == nil then
        return
    end
    if PlayerData[otherplayer].clothing == nil then
        return
    end
    if PlayerData[otherplayer].clothing[1] == nil then
        return
    end

    CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 0, PlayerData[otherplayer].clothing[1], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 1, PlayerData[otherplayer].clothing[3], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 4, PlayerData[otherplayer].clothing[4], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 5, PlayerData[otherplayer].clothing[5], 0, 0, 0, 0)
end
AddRemoteEvent("ServerChangeOtherPlayerClothes", ChangeOtherPlayerClothes)

AddRemoteEvent("InsertPlayer", function(player, name)
    PlayerData[player].created = 1
    PlayerData[player].name = tostring(name)
    PlayerData[player].steamid = tostring(GetPlayerSteamId(player))
    SavePlayer(player, PlayerData[player])
end)

-- Argent (money) --
function updateHudMoney(player)
    CallRemoteEvent(player, "UpdateMoneyInventory", PlayerData[player].argent)
end

function getMoney(player)
    return PlayerData[player].argent
end

function haveMoney(player, money)
    local calcul = PlayerData[player].argent - money
    if calcul >= 0 then
        return true
    else
        return false
    end
end

function setMoney(player, money)
    PlayerData[player].argent = math.clamp(money, 0, p_maxMoney)
    updateHudMoney(player)
end

function addMoney(player, money)
    local calcul = PlayerData[player].argent - money
    PlayerData[player].argent = math.clamp(calcul, 0, p_maxMoney)
    updateHudMoney(player)
end

function removeMoney(player, money)
    local calcul = PlayerData[player].argent - money
    if calcul >= 0 then
        PlayerData[player].argent = math.clamp(calcul, 0, p_maxMoney)
        updateHudMoney(player)
        return true
    else
        return false
    end
end

-- Teleport --
function PlayerTeleport(player, x, y, z)
    SetPlayerLocation(player, x, y, z+250)
end

-- GetPlayerByCompteId --
function GetPlayerByCompteId(compteid)
    local found = 0
    for k,v in pairs(GetAllPlayers()) do
        if tonumber(PlayerData[v].id) == tonumber(compteid) then
            found = v
            break
        end
    end

    return found
end

-- Notification --
function AddNotification(player, msg, type, delay)
    if msg == "" or msg == nil then
        print("Notification : Message Invalide")
        return
    end
    if type == "" or type == nil then
        type = "default"
    end
    if delay == nil or delay == 0 then
        delay = 20
    end
    return CallRemoteEvent(player, "ClientAddNotification", msg, type, delay)
end