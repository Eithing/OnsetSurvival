function RequestPopulateInventory(player)
	if PlayerData[player].inventory == nil then
		Delay(500, function()
			RequestPopulateInventory(player)
		end)
	else
		CallRemoteEvent(player, "PopulateInventory", PlayerData[player].inventory)
		UpdateWeight(player, false)
	end
end
AddRemoteEvent("RequestPopulateInventory", RequestPopulateInventory)


AddRemoteEvent("equipWeapon", function(player, id, slot, ammo)
	SetPlayerWeapon(player, id, ammo, true, slot, false)
end)

-- Remove --
function RemoveItem(player, idUnique, count)
	for i, item in pairs(PlayerData[player].inventory) do
		if item.id == idUnique then
			item.itemCount = math.clamp(item.itemCount - count, 0, i_maxStack)
			if(item.itemCount > 1)then
				SLogic.UpdatePlayerItem(item)
			else
				SLogic.RemovePlayerItem(idUnique)
				PlayerData[player].inventory[i] = nil
			end
			UpdateWeight(player, false)
			return
		end
	end
end
AddRemoteEvent("RemoveItem", RemoveItem)

function DropItem(player, idUnique, count)
	local x,y,z = GetPlayerLocation(player)
	local newitem
	for i, item in pairs(PlayerData[player].inventory) do
		if tonumber(item.id) == tonumber(idUnique) then
			local newitem = CreatePickup(item.modelId, x, y, z - 88)
			ItemPickups[newitem] = {}
			ItemPickups[newitem].item = {
				id = item.id,
				nom = item.nom,
				poids = item.poids,
				type = item.type,
				imageId = item.imageId,
				modelId = item.modelId,
				compteId = item.compteId,
				itemId = item.itemId,
				itemCount = tonumber(count),
				var = item.var
			}

			local itemc = math.floor(math.clamp(item.itemCount - count, 0, i_maxStack))
			if itemc <= 0 then
				item.itemCount = 0
				SLogic.RemovePlayerItem(idUnique)
				PlayerData[player].inventory[i] = nil
			else
				item.itemCount = itemc
				SLogic.UpdatePlayerItem(item)
			end
			UpdateWeight(player, false)
			break
		end
	end
end
AddRemoteEvent("DropItem", DropItem)

-- Pickup --
AddEvent("OnPlayerPickupHit", function(player, Pickup)
	if(ItemPickups[Pickup] ~= nil)then
		if PlayerData[player].PickupS == true then
			return
		end
		if GetPlayerVehicle(player) ~= 0 then
			return
		end
		PickupItem(player, ItemPickups[Pickup].item)
		DestroyPickup(Pickup)
		ItemPickups[Pickup] = nil
		PlayerData[player].PickupS = true
		Delay(2000, function()
			PlayerData[player].PickupS = false
		end)
	end
end)

function PickupItem(player, Pitem)
	local found = false
	for i, item in pairs(PlayerData[player].inventory) do
		if tonumber(item.itemId) == tonumber(Pitem.itemId) then
			item.itemCount = math.floor(math.clamp(item.itemCount + Pitem.itemCount, 0, i_maxStack))
			SLogic.UpdatePlayerItem(item)
			CallRemoteEvent(player, "UpdateItemInventory", item)
			UpdateWeight(player, false)
			found = true
			break
		end
	end
	if found == false then
		SLogic.SetUserInventory(PlayerData[player].id, Pitem.itemId, Pitem.itemCount, Pitem.var)
		Delay(500, function()
			Player_CreateNewItem(player)
		end)
	end
end

function Player_CreateNewItem(player)
	local newItem = SLogic.GetLastPlayerItem(PlayerData[player].id)
	table.insert(PlayerData[player].inventory, newItem)
	CallRemoteEvent(player, "AddItemInventory", newItem)
	UpdateWeight(player, false)
end

-- Use --
function UseItem(player, idUnique, count)
	if tonumber(count) == nil or tonumber(count) < 0 then
		return
	end
	local UsingItem = GetItemByIdUnique(player, idUnique) -- Information dans l'inventaire
	if(tonumber(UsingItem.itemId) == 29)then -- Bidon d'essence
		local vehicle, Dist = VGetNearestVehicle(player, 200)
		if(IsValidVehicle(vehicle))then
			if GetPlayerVehicle(player) == vehicle then
				return
			end
			for i=1, tonumber(count) do
				AddFuel(vehicle, i_item_fuel)
			end
		end
	end
	if(tonumber(UsingItem.itemId) == 30)then --Clé
		--print("Clé")
	end
	if(tonumber(UsingItem.itemId) == 31)then --Kit de réparation
		local vehicle, Dist = VGetNearestVehicle(player, 200)
		if(IsValidVehicle(vehicle))then
			for i=1, 8 do
				SetVehicleDamage(vehicle, i, 0)
			end
			for i=1, tonumber(count) do
				SetVehicleHealth(vehicle, math.clamp(GetVehicleHealth(vehicle)+i_item_repair, 0, 1500))
			end
		end
	end
	if(tonumber(UsingItem.itemId) ~= 30)then
		RemoveItem(player, idUnique, tonumber(count))
	end
	
	UpdateWeight(player, false)
end
AddRemoteEvent("UseItem", UseItem)

-- Weight (Gestion du poids) --

function UpdateWeight(player, visibility)
	local weight = 0
	for i, item in pairs(PlayerData[player].inventory) do
		weight = weight + (item.poids * item.itemCount)
	end

	if weight > PlayerData[player].MaxWeight then
		if PlayerData[player].IsInMaxWeight ~= true then
			CallRemoteEvent(player, "IsGettingMaxWeight", math.ceil(weight), PlayerData[player].MaxWeight)
			PlayerData[player].IsInMaxWeight = true
		end
		CallRemoteEvent(player, "IsGettingMaxWeight", math.ceil(weight), PlayerData[player].MaxWeight)
		if PlayerData[player].NotifWeight == false then
			AddNotification(player, "Vous êtes trop lourd, vous ne pouvez plus bouger!", "error")
			PlayerData[player].NotifWeight = true
			Delay(math.Seconds(p_delayNotif), function()
				PlayerData[player].NotifWeight = false
			end)
		end
	else
		if visibility ~= true then
			CallRemoteEvent(player, "IsGettingCorrectWeight", math.ceil(weight), PlayerData[player].MaxWeight)
		end
		PlayerData[player].IsInMaxWeight = false
	end
end
AddRemoteEvent("UpdateWeight", UpdateWeight)


-- Fonctions --
function GetItemByIdUnique(player, idUnique)
	local found
	for i, item in pairs(PlayerData[player].inventory) do
		if item.id == idUnique then
			found = item
			break
		end
	end
	return found
end

function GetItemDataByItemID(itemID)
	local found = 0
	for i, item in ipairs(ItemData) do
		if item.id == itemID then
			found = item
			break
		end
	end
	return found
end