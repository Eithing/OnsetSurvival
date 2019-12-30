local maxWeight = 100
AddRemoteEvent("RequestPopulateInventory", function(player)
	CallRemoteEvent(player, "PopulateInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
	UpdateWeight(player)
end)

AddRemoteEvent("equipWeapon", function(player, id, slot, ammo)
	SetPlayerWeapon(player, id, ammo, true, slot, false)
end)

AddEvent("OnPlayerSteamAuth", function(player)
	UpdateWeight(player, false)
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
	UpdateWeight(player)
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
			CallRemoteEvent(player, "UpdateItemInventory", item)
			found = true
			break
		end
	end
	if(found == false)then
		SLogic.SetUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, itemid, Count)
		CreateItemDataByItemID(player)
	end
	UpdateWeight(player)
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
	UpdateWeight()
end
AddRemoteEvent("OnUseItem", UseItem)

function CreateItemDataByItemID(player)
	local newItem = SLogic.GetLastUserItem(UserData[tostring(GetPlayerSteamId(player))].id)
	table.insert(UserData[tostring(GetPlayerSteamId(player))].inventoryItems, newItem)
	CallRemoteEvent(player, "AddItemInventory", newItem)
	UpdateWeight(player)
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

function UpdateWeight(player, visibility)
	local weight = 0
	for i, item in ipairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		weight = weight + (item.poids * item.itemCount)
	end

	if weight > maxWeight then
		if UserData[tostring(GetPlayerSteamId(player))].inventoryItems.IsInMaxWeight ~= true then
			CallRemoteEvent(player, "IsGettingMaxWeight", false)
			UserData[tostring(GetPlayerSteamId(player))].inventoryItems.IsInMaxWeight = true
		end
		CallRemoteEvent(player, "IsGettingMaxWeight", true)
	else
		if visibility ~= true then
			CallRemoteEvent(player, "IsGettingCorrectWeight")
		end
		UserData[tostring(GetPlayerSteamId(player))].inventoryItems.IsInMaxWeight = false
	end
end
AddRemoteEvent("UpdateWeight", UpdateWeight)

