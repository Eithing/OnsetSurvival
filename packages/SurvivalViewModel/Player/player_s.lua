function OnPackageStart()
    -- Save all player data automatically 
    CreateTimer(function()
		for k, v in pairs(GetAllPlayers()) do
            SavePlayer(v)
		end
		print("All players have been saved !")
    end, 30000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerSteamAuth(player)
    CreatePlayerData(player)

    OnLoadPlayer(player, GetPlayerSteamId(player))
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

function OnPlayerQuit(player)
    SavePlayer(player)
    DestroyPlayerData(player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

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
        PlayerData[player].inventory = {}
        PlayerData[player].clothing = {}
        PlayerData[player].onAction = false
        PlayerData[player].isActioned = false
        PlayerData[player].position = {}
        PlayerData[player].created = 0
        print("Data created for : "..player)

        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR")
        table.insert(PlayerData[player].clothing, { 250, 240, 190, 1 })
        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR")
        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR")
        table.insert(PlayerData[player].clothing, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR")

        for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
            ChangeOtherPlayerClothes(k, player)
        end
    end
end

function OnLoadPlayer(player, steamid)
    local rows, result = SLogic.GetUserBySteamId(player)
    print(rows, result.id)
    if rows > 0 then
        PlayerData[player].id = result.id
    end
    if (PlayerData[player].id == 0) then
        CreatePlayerAccount(player)
    else
        LoadPlayerAccount(player, rows, result)
    end
end

function CheckForIPBan(player)
	local query = mariadb_prepare(sql, "SELECT ipbans.reason FROM ipbans WHERE ipbans.ip = '?' LIMIT 1;",
		GetPlayerIP(player))

    mariadb_query(sql, query)
    
    if (mariadb_get_row_count() == 0) then
		--No IP ban found for this account
		if (PlayerData[player].id == 0) then
			CreatePlayerAccount(player)
		else
			LoadPlayerAccount(player)
		end
	else
		print("Kicking "..GetPlayerName(player).." because their IP was banned")

		local result = mariadb_get_assoc(1)
        
        KickPlayer(player, "🚨 You have been banned from the server.")
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
		PlayerData[player].name = tostring(result.nom)
        PlayerData[player].position = SLogic.json_decode(result.position)
        PlayerData[player].health = math.tointeger(result.health)
        PlayerData[player].armor = math.tointeger(result.armor)
        PlayerData[player].hunger = math.tointeger(result.hunger)
		PlayerData[player].thirst = math.tointeger(result.thirst)
		PlayerData[player].clothing = SLogic.json_decode(result.clothing)
		PlayerData[player].inventory = SLogic.json_decode(result.inventory)
		PlayerData[player].admin = math.tointeger(result.admin)
		PlayerData[player].created = math.tointeger(result.created)

		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armor']))
		--setPlayerThirst(player, tonumber(result['thirst']))
		--setPlayerHunger(player, tonumber(result['hunger']))
		setPositionAndSpawn(player, PlayerData[player].position)

		if PlayerData[player].created == 0 then
			CallRemoteEvent(player, "DisplayCreateCharacter")
		else
			SetPlayerName(player, PlayerData[player].name)
		
			CallRemoteEvent(player, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], 0, 0, 0, 0)
			CallRemoteEvent(player, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], 0, 0, 0, 0)
			CallRemoteEvent(player, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], 0, 0, 0, 0)
            CallRemoteEvent(player, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
		end

		print("Player ID "..PlayerData[player].id.." loaded for "..GetPlayerIP(player))
	end
end

function setPositionAndSpawn(player, position) 
	SetPlayerSpawnLocation(player, 227603, -65590, 400, 0 )
	if position ~= nil and position.x ~= nil and position.y ~= nil and position.z ~= nil then
		SetPlayerLocation(player, PlayerData[player].position.x, PlayerData[player].position.y, PlayerData[player].position.z + 250) -- Pour empêcher de se retrouver sous la map
	else
		SetPlayerLocation(player, 227603, -65590, 400)
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

	SLogic.UpdateUser(player, PlayerData[player])
    
    print("Data saved for : "..player)
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

end)


