AddRemoteEvent("RequestPopulateInventory", function(player)
	CallRemoteEvent(player, "PopulateInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
end)

AddRemoteEvent("equipWeapon", function(player, id, slot, ammo)
	SetPlayerWeapon(player, id, ammo, true, slot, false)
end)

AddRemoteEvent("RemoveItem", function(player, idUnique)
	local x,y,z = GetPlayerLocation(player)
	local newitem

	for i, item in ipairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		if item.idUnique == idUnique then
			UserData[tostring(GetPlayerSteamId(player))].inventoryItems[i] = nil
			local newitem = CreatePickup(item.modelId, x, y, z - 88)
			ItemPickups[newitem] = {}
			ItemPickups[newitem].item = item
			SLogic.RemoveItemInventory(idUnique)
			break
		end
	end
end)

AddEvent("OnPlayerPickupHit", function(player, Pickup)
	if(ItemPickups[Pickup] ~= nil) then
		PickupItem(player, ItemPickups[Pickup].item.itemId, ItemPickups[Pickup].item.itemCount)
		DestroyPickup(Pickup)
		table.remove(ItemPickups, Pickup)
	end
end)

function PickupItem(player, itemid, Count)
	if GetPlayerVehicle(player) ~= 0 then
        return
    end
	local found = false
	for i, item in ipairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		if item.itemId == itemid then
			SLogic.UpdateUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, item.itemId, item.itemCount + Count)
			item.itemCount = math.floor(item.itemCount + Count)
			CallRemoteEvent(player, "ReloadInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
			found = true
			break
		end
	end
	if(found == false)then
		SLogic.SetUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, itemid, Count)
		table.insert(UserData[tostring(GetPlayerSteamId(player))].inventoryItems, CreateItemDataByItemID(player,itemid, count))
		print(CreateItemDataByItemID(player,itemid, count))
		CallRemoteEvent(player, "ReloadInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
	end
end

function UseItem(player, itemId, type)
	print(player, itemId, type)
	if(item.type == "consommable")then
		if(item.itemId == 29)then -- Bidon d'essence
			local vehicle = GetNearestVehicle(player)
			if(IsValidVehicle(vehicle))then
				AddFuel(vehicle, count)
			end
		end
	end
end
AddRemoteEvent("OnUseItem", UseItem)

function CreateItemDataByItemID(player, itemID, count)
	local inv = UserData[tostring(GetPlayerSteamId(player))].inventoryItems
	local Id_Unique = inv[#inv].idUnique+1 or 1
	local item
	local data = GetItemDataByItemID(itemID)
	item = {itemID,
	nom = data.nom,
	poids = data.poids,
	type = data.type,
	imageId = data.imageId,
	itemCount = count,
	compteId = UserData[tostring(GetPlayerSteamId(player))].id,
	itemId = itemID,
	modelId = data.modelId,
	idUnique = inv[#inv].idUnique+1}
	return item
end

function GetItemDataByItemID(itemID)
	local found
	for i, item in ipairs(ItemData) do
		if item.id == itemID then
			found = item
			break
		end
	end
	return found
end