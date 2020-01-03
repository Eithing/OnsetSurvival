function OnPackageStart()
    print("Player ServerSide Loaded (Save All toutes les "..s_SaveAll.."m)")
    -- Save all player data automatically 
    CreateTimer(function()
		for k, v in pairs(GetAllPlayers()) do
            SavePlayer(v)
		end
		print("All players have been saved !")
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
        print("Data created for : "..player)

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
		--No IP ban found for this account
		if (PlayerData[player].id == 0) then
			CreatePlayerAccount(player)
		else
			LoadPlayerAccount(player, lrowns, lresult)
		end
	elseif rows == 1 then
		print("Kicking "..GetPlayerName(player).." because their IP was banned ("..result.reason..")")
        
        KickPlayer(player, "🚨 You have been banned from the server. (raison : "..result.reason..")")
	end
end

function CreatePlayerAccount(player)
    PlayerData[player].id = SLogic.InsertNewUser(player)

	CallRemoteEvent(player, "DisplayCreateCharacter")

	setPositionAndSpawn(player, nil)

	print("Player ID "..PlayerData[player].id.." created for "..player)
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

		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armor']))
		--setPlayerThirst(player, tonumber(result['thirst']))
		--setPlayerHunger(player, tonumber(result['hunger']))
		setPositionAndSpawn(player, PlayerData[player].position)

		if PlayerData[player].created == 0 then
			CallRemoteEvent(player, "DisplayCreateCharacter")
		else
			SetPlayerName(player, PlayerData[player].name)
		
			ChangeOtherPlayerClothes(player, player)
		end

        print("Player ID "..PlayerData[player].id.." loaded for "..GetPlayerIP(player))
        CallRemoteEvent(player, "OnUpdateVitalIndicator", GetPlayerHealth(player), PlayerData[player].hunger, PlayerData[player].thirst)
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
	print("Data destroyed for : "..player)
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
    
    print("Data saved for : "..player)

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

-- Teleport --
function PlayerTeleport(player, x, y, z)
    SetPlayerLocation(player, x, y, z+250)
end

-- Notification --
function AddNotification(player, msg, type)
    if msg == "" or msg == nil then
        print("Notification : Message Invalide")
        return
    end
    if type == "" or type == nil then
        type = "default"
    end
    CallRemoteEvent(player, "ClientAddNotification", msg, type)
end