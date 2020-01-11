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
		if tonumber(item.id) == tonumber(idUnique) then
			item.itemCount = math.clamp(item.itemCount - tonumber(count), 0, tonumber(item.maxStack))
			if(item.itemCount > 1)then
				SLogic.UpdatePlayerItem(item)
				CallRemoteEvent(player, "UpdateItemInventory", item)
			else
				SLogic.RemovePlayerItem(tonumber(item.id))
				CallRemoteEvent(player, "RemoveItemInventory", item)
				PlayerData[player].inventory[i] = nil
			end
			UpdateWeight(player, false)
			return
		end
	end
end
AddRemoteEvent("RemoveItem", RemoveItem)

function RemoveItemByItemID(player, itemId, count)
	count = tonumber(count)
	for i, item in pairs(PlayerData[player].inventory) do
		if tonumber(item.itemId) == tonumber(itemId) and count > 0 then
			item.itemCount = math.clamp(item.itemCount - count, 0, tonumber(item.maxStack))
			if(item.itemCount > 1)then
				SLogic.UpdatePlayerItem(item)
				CallRemoteEvent(player, "UpdateItemInventory", item)
			else
				SLogic.RemovePlayerItem(tonumber(item.id))
				CallRemoteEvent(player, "RemoveItemInventory", item)
				PlayerData[player].inventory[i] = nil
			end
			count = math.floor(count - item.itemCount)
		end
	end
	UpdateWeight(player, false)
end
AddRemoteEvent("RemoveItem", RemoveItem)

function DropItem(player, idUnique, count)
	if GetPlayerMovementMode(player) == 5 then
		AddNotification(player, "Vous ne pouvez pas jeter un objet !", "error")
		return
	end
	local x,y,z = GetPlayerLocation(player)
	local newitem
	for i, item in pairs(PlayerData[player].inventory) do
		if tonumber(item.id) == tonumber(idUnique) then
			local newitem = CreateObject(item.modelId, x, y, z - 94, 90, 0, 0)
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
			SetObjectPropertyValue(newitem, "IsItemInventory", true, true)
			SetObjectPropertyValue(newitem, "DontCollison", true, true)

			local itemc = math.floor(math.clamp(item.itemCount - count, 0, tonumber(item.maxStack)))
			if itemc <= 0 then
				item.itemCount = 0
				SLogic.RemovePlayerItem(idUnique)
				PlayerData[player].inventory[i] = nil
				CallRemoteEvent(player, "RemoveItemInventory", item)
			else
				item.itemCount = itemc
				SLogic.UpdatePlayerItem(item)
				CallRemoteEvent(player, "UpdateItemInventory", item)
			end
			UpdateWeight(player, false)
			break
		end
	end
end
AddRemoteEvent("DropItem", DropItem)

-- Pickup --
AddRemoteEvent("ItemPickup", function(player, Pickup)
	if IsValidObject(Pickup) and ItemPickups[Pickup] ~= nil then
		if PlayerData[player].PickupS == true then
			return
		end
		if GetPlayerVehicle(player) ~= 0 then
			return
		end
		PickupItem(player, ItemPickups[Pickup].item)
		DestroyObject(Pickup)
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
			local calcul = item.itemCount + Pitem.itemCount
			if tonumber(item.isstackable) ~= 0 and calcul <= tonumber(item.maxStack) then
				item.itemCount = math.floor(math.clamp(item.itemCount + Pitem.itemCount, 0, tonumber(item.maxStack)))
				SLogic.UpdatePlayerItem(item)
				CallRemoteEvent(player, "UpdateItemInventory", item)
				UpdateWeight(player, false)
				found = true
				break
			end
		end
	end
	if found == false then
		local id = SLogic.SetUserInventory(PlayerData[player].id, Pitem)
		Delay(500, function()
			Player_CreateNewItem(player, id)
		end)
	end
end

function Player_CreateNewItem(player, id)
	local newItem = SLogic.GetLastPlayerItem(PlayerData[player].id, id)
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
	if UsingItem ~= 0 then
		if(tonumber(UsingItem.itemId) == 29)then -- Bidon d'essence
			local vehicle, Dist = VGetNearestVehicle(player, 200)
			if(IsValidVehicle(vehicle))then
				if GetPlayerVehicle(player) == vehicle then
					AddNotification(player, "Vous etes dans un véhicule !", "error")
					return
				end
				for i=1, tonumber(count) do
					if VehicleData[vehicle].fuel ~= 100 then
						AddFuel(vehicle, UsingItem.value)
					else
						if i == 1 then
							count = 0
						else
							count = i
						end
						break
					end
				end
			else
				AddNotification(player, "Aucun véhicule a proximité !", "error")
				count = 0
			end
		end
		if(tonumber(UsingItem.itemId) == 30)then --Clé
			local vehicle, Dist = VGetNearestVehicle(player, 200)
			if(IsValidVehicle(vehicle))then
				if VehicleData[vehicle] ~= nil then
					for k, v in pairs(SLogic.json_decode(UsingItem.var)) do
						if tonumber(v) == tonumber(VehicleData[vehicle].cles) then
							LockUnLockVehicle(player, vehicle)
							count = 0
							break
						end
					end
				end
			else
				AddNotification(player, "Aucun véhicule a proximité !", "error")
				count = 0
			end
		end
		if(tonumber(UsingItem.itemId) == 31)then --Kit de réparation
			local vehicle, Dist = VGetNearestVehicle(player, 200)
			if(IsValidVehicle(vehicle))then
				for i=1, tonumber(count) do
					if GetVehicleHealth(vehicle) ~= v_health then
						SetVehicleHealth(vehicle, math.clamp(GetVehicleHealth(vehicle)+UsingItem.value, 0, v_health))
						if GetVehicleHealth(vehicle) > v_health/2 then
							for i=1, 8 do
								SetVehicleDamage(vehicle, i, 0)
							end
						end
					else
						if i == 1 then
							count = 0
						else
							count = i
						end
						break
					end
				end
			else
				AddNotification(player, "Aucun véhicule a proximité !", "error")
				count = 0
			end
		end
		if(tonumber(UsingItem.itemId) == 32)then --Coca Cola
			for i=1, tonumber(count) do
				if getthirst(player) ~= p_defaultthirst then
					addthirst(player, UsingItem.value)
				else
					if i == 1 then
						count = 0
					else
						count = i
					end
					break
				end
			end
		end
		if(tonumber(UsingItem.itemId) == 33)then --Chips
			for i=1, tonumber(count) do
				if gethunger(player) ~= p_defaulthunger then
					addhunger(player, UsingItem.value)
				else
					if i == 1 then
						count = 0
					else
						count = i
					end
					break
				end
			end
		end

		if count > 0 then
			RemoveItem(player, tonumber(idUnique), tonumber(count))
		end
		
		UpdateWeight(player, false)
	end
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
			CallRemoteEvent(player, "IsGettingMaxWeight", math.ceil(weight), PlayerData[player].MaxWeight, PlayerData[player].argent)
			PlayerData[player].IsInMaxWeight = true
		end
		CallRemoteEvent(player, "IsGettingMaxWeight", math.ceil(weight), PlayerData[player].MaxWeight, PlayerData[player].argent)
		if PlayerData[player].NotifWeight == false then
			AddNotification(player, "Vous êtes trop lourd, vous ne pouvez plus bouger!", "error")
			PlayerData[player].NotifWeight = true
			Delay(math.Seconds(p_delayNotif), function()
				PlayerData[player].NotifWeight = false
			end)
		end
	else
		if visibility ~= true then
			CallRemoteEvent(player, "IsGettingCorrectWeight", math.ceil(weight), PlayerData[player].MaxWeight, PlayerData[player].argent)
		end
		PlayerData[player].IsInMaxWeight = false
	end

	Delay(800, function()
		CallRemoteEvent(player, "PopulateCraft", PlayerData[player].inventory, c_Receipts)
	end)
end
AddRemoteEvent("UpdateWeight", UpdateWeight)

-- Mort
AddEvent("OnPlayerDeath", function(player, instigator)
	-- supression suivit sac + apparition au sol
	if (PlayerData[player].bag ~= 0) then
		DestroyObject(PlayerData[player].bag)
		PlayerData[player].bag = 0
	end
	local x, y, z = GetPlayerLocation(player)
	local object = CreateObject(1282, x, y, z-100)
	DeadPlayerBags[object] = {}
	DeadPlayerBags[object].inventory = PlayerData[player].inventory
	DeadPlayerBags[object].x = x
	DeadPlayerBags[object].y = y
	DeadPlayerBags[object].z = z
	PlayerData[player].bag = object
	
	SetObjectPropertyValue(object, "DontCollison", true, true)

	Delay(p_bagDisappearTime, function()
		DestroyObject(object)
		DeadPlayerBags[object] = nil
	end)
end)

-- SearchProximityInventory --
function SearchProximityInventory(player, visibility)
	local found = false
	if visibility then
		local x,y,z = GetPlayerLocation(player)
		for i, inventory in pairs(DeadPlayerBags) do
			if GetDistance3D(x, y, z, inventory.x, inventory.y, inventory.z) < 100 then
				SetPlayerAnimation(player, 'SIT06')
				found = true
				break
			end
		end
		if found == false then
		end
	else
		SetPlayerAnimation(player, 'STOP')
	end
end
AddRemoteEvent("SearchProximityInventory", SearchProximityInventory)

-- Fonctions --
function GetItemByIdUnique(player, idUnique)
	local found = 0
	for i, item in pairs(PlayerData[player].inventory) do
		if tonumber(item.id) == tonumber(idUnique) then
			found = item
			break
		end
	end
	return found
end

function GetItemByItemID(player, itemId)
	local found = 0
	for i, item in pairs(PlayerData[player].inventory) do
		if tonumber(item.itemId) == tonumber(itemId) then
			found = item
			break
		end
	end
	return found
end

function GetItemCountByItemID(player, itemId)
	local count = 0
	for i, item in pairs(PlayerData[player].inventory) do
		if tonumber(item.itemId) == tonumber(itemId) then
			count = count + item.itemCount
		end
	end
	return count
end

function GetItemDataByItemID(itemID)
	local found = 0
	for i, item in pairs(ItemDB) do
		if tonumber(item.id) == tonumber(itemID) then
			found = item
			break
		end
	end
	return found
end