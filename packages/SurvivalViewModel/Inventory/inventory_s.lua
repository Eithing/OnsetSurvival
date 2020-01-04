AddRemoteEvent("RequestPopulateInventory", function(player)
	CallRemoteEvent(player, "PopulateInventory", PlayerData[player].inventory)
end)

AddRemoteEvent("equipWeapon", function(player, id, slot, ammo)
	SetPlayerWeapon(player, id, ammo, true, slot, false)
end)

-- Remove --
function RemoveItem(player, idUnique, count)
	for i, item in pairs(PlayerData[player].inventory) do
		if item.id == idUnique then
			item.itemCount = math.clamp(math.floor(item.itemCount - count), 0, 99)
			if(item.itemCount > 1)then
				SLogic.UpdatePlayerItem(item)
			else
				SLogic.RemovePlayerItem(idUnique)
				PlayerData[player].inventory[i] = nil
			end
			return
		end
	end
end
AddRemoteEvent("RemoveItem", RemoveItem)

function DropItem(player, idUnique)
	local x,y,z = GetPlayerLocation(player)
	local newitem
	for i, item in pairs(PlayerData[player].inventory) do
		if item.id == idUnique then
			local newitem = CreatePickup(item.modelId, x, y, z - 88)
			ItemPickups[newitem] = {}
			ItemPickups[newitem].item = item
			SLogic.RemovePlayerItem(idUnique)
			PlayerData[player].inventory[i] = nil
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
		if item.itemId == Pitem.itemId then
			item.var = SLogic.json_decode(item.var)
			item.itemCount = math.floor(item.itemCount + Pitem.itemCount)
			for vi, ivar in pairs(SLogic.json_decode(Pitem.var)) do
				table.insert(item.var, ivar)
			end
			item.var = SLogic.json_encode(item.var)
			SLogic.UpdatePlayerItem(item)
			CallRemoteEvent(player, "UpdateItemInventory", item)
			found = true
			return
		end
	end
	if(found == false)then
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
end

-- Use --
function UseItem(player, idUnique)
	local UsingItem = GetItemByIdUnique(player, idUnique) -- Information dans l'inventaire
	if(tonumber(UsingItem.itemId) == 29)then -- Bidon d'essence
		local vehicle, Dist = VGetNearestVehicle(player, 200)
		if(IsValidVehicle(vehicle))then
			if GetPlayerVehicle(player) == vehicle then
				return
			end
			AddFuel(vehicle, 40)
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
			SetVehicleHealth(vehicle, math.clamp(GetVehicleHealth(vehicle)+200, 0, 1500))
		end
	end
	if(tonumber(UsingItem.itemId) ~= 30)then
		RemoveItem(player, idUnique, 1)
	end
end
AddRemoteEvent("UseItem", UseItem)

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