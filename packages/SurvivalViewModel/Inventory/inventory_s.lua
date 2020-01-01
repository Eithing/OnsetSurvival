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

-- Remove --
function RemoveItem(player, idUnique, count)
	for i, item in pairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		if item.idUnique == idUnique then
			item.itemCount = math.clamp(math.floor(item.itemCount - count), 0, 99)
			if(item.itemCount > 1)then
				SLogic.UpdateUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, idUnique, item.itemCount)
				--CallRemoteEvent(player, "UpdateItemInventory", item) Inutile mais au cas ou, on garde
			else
				SLogic.RemoveItemInventory(idUnique)
				UserData[tostring(GetPlayerSteamId(player))].inventoryItems[i] = nil
			end
			UpdateWeight(player)
			return
		end
	end
end
AddRemoteEvent("RemoveItem", RemoveItem)

function DropItem(player, idUnique)
	local x,y,z = GetPlayerLocation(player)
	local newitem
	for i, item in pairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		if item.idUnique == idUnique then
			local newitem = CreatePickup(item.modelId, x, y, z - 88)
			ItemPickups[newitem] = {}
			ItemPickups[newitem].item = item
			SLogic.RemoveItemInventory(idUnique)
			UserData[tostring(GetPlayerSteamId(player))].inventoryItems[i] = nil
			UpdateWeight(player)
			break
		end
	end
end
AddRemoteEvent("DropItem", DropItem)

-- Pickup --
AddEvent("OnPlayerPickupHit", function(player, Pickup)
	if(ItemPickups[Pickup] ~= nil)then
		if UserData[tostring(GetPlayerSteamId(player))].PickupS == true then
			return
		end
		if GetPlayerVehicle(player) ~= 0 then
			return
		end
		PickupItem(player, ItemPickups[Pickup].item)
		DestroyPickup(Pickup)
		ItemPickups[Pickup] = nil
		UserData[tostring(GetPlayerSteamId(player))].PickupS = true
		Delay(2000, function()
			UserData[tostring(GetPlayerSteamId(player))].PickupS = false
		end)
	end
end)

function PickupItem(player, Pitem)
	local found = false
	for i, item in ipairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		if item.itemId == Pitem.itemId then
			item.itemCount = math.floor(item.itemCount + Pitem.itemCount)
			for vi, ivar in pairs(Pitem.var) do
				table.insert(item.var, ivar)
			end
			SLogic.UpdateUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, item.idUnique, item.itemCount, item.var)
			CallRemoteEvent(player, "UpdateItemInventory", item)
			found = true
			return
		end
	end
	if(found == false)then
		SLogic.SetUserInventory(UserData[tostring(GetPlayerSteamId(player))].id, Pitem.itemId, Pitem.itemCount, Pitem.var)
		Delay(500, function()
			Player_CreateNewItem(player)
		end)
	end
	UpdateWeight(player)
end

function Player_CreateNewItem(player)
	local newItem = SLogic.GetLastUserItem(UserData[tostring(GetPlayerSteamId(player))].id)
	table.insert(UserData[tostring(GetPlayerSteamId(player))].inventoryItems, newItem)
	CallRemoteEvent(player, "AddItemInventory", newItem)
	UpdateWeight(player)
end

-- Use --
function UseItem(player, idUnique)
	local UsingItem = GetItemByIdUnique(player, idUnique) -- Informatio dans l'inventaire
	local UsingItemData = GetItemDataByItemID(UsingItem.itemId) -- Information sur l'item
	if(tonumber(UsingItem.itemId) == 29)then -- Bidon d'essence
		local vehicle, Dist = GetNearestVehicle(player, 200)
		if(IsValidVehicle(vehicle))then
			if GetPlayerVehicle(player) == vehicle then
				return
			end
			AddFuel(vehicle, 40)
		end
	end
	if(tonumber(UsingItem.itemId) == 30)then --Clé
		print("Clé")
	end
	if(tonumber(UsingItem.itemId) == 31)then --Kit de réparation
		local vehicle, Dist = GetNearestVehicle(player, 200)
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

	UpdateWeight(player)
end
AddRemoteEvent("UseItem", UseItem)

-- Weight --
function UpdateWeight(player, visibility)
	local weight = 0
	for i, item in ipairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		weight = weight + (item.poids * item.itemCount)
	end

	if weight > i_maxWeight then
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

-- Fonctions --
function GetItemByIdUnique(player, idUnique)
	local found
	for i, item in pairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		if item.idUnique == idUnique then
			found = item
			break
		end
	end
	return found
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