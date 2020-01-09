-- CRAFT CONFIG --
c_Receipts = {}

AddEvent("OnPackageStart", function()
	Delay(math.Seconds(1), function()
		CreateCraft(26, 20, GetItemDataByItemID(26).nom,  "item", GetItemDataByItemID(26).type, {
			{name = GetItemDataByItemID(40).nom, itemId = 34, count = 20},
			{name = GetItemDataByItemID(41).nom, itemId = 41, count = 20}
		}, 5)
		
		CreateCraft(25, 25, "Dacia 2000", "vehicle", "cars", {
			{name = GetItemDataByItemID(40).nom, itemId = 40, count = 20},
			{name = GetItemDataByItemID(41).nom, itemId = 41, count = 20},
			{name = GetItemDataByItemID(43).nom, itemId = 43, count = 20}
		}, 5)
	end)
end)


function RequestPopulateCraft(player)
	if PlayerData[player].inventory == nil then
		Delay(500, function()
			RequestPopulateCraft(player)
		end)
	else
		CallRemoteEvent(player, "PopulateCraft", PlayerData[player].inventory, c_Receipts)
		UpdateWeight(player, false)
	end
end
AddRemoteEvent("RequestPopulateCraft", RequestPopulateCraft)

function Craft(player, id, count)
	UpdateWeight(player, false)
	local itemcraft = GetCraft(id)
	if itemcraft ~= 0 then
		if itemcraft.type == "vehicle" then
			count = 1
		end
		print(count)
		local needitems = SLogic.json_decode(itemcraft.need)
		for k, v in pairs(needitems) do
			local itemcount = GetItemCountByItemID(player, v.itemId)
			if (itemcount.id == 0 or itemcount.count == 0) or tonumber(itemcount.count) < (tonumber(v.count)*count) then
				AddNotification(player, "Vous avez pas assez de ressources sur vous!", "error")
				return false
			else
				RemoveItem(player, tonumber(itemcount.id), (tonumber(v.count)*count))
			end
		end

		SetPlayerAnimation(player, 'COMBINE')
		Delay(math.Seconds(itemcraft.time*count), function()
			if itemcraft.type == "item" then
				local CraftItem = {}
				local itemData = GetItemDataByItemID(itemcraft.itemId)
				CraftItem = {
					nom = itemData.nom,
					poids = tonumber(itemData.poids),
					type = itemData.type,
					imageId = tonumber(itemData.imageId),
					modelId = tonumber(itemData.modelId),
					compteId = tonumber(PlayerData[player].id),
					itemId = tonumber(itemData.id),
					maxStack = tonumber(itemData.maxStack),
					isstackable = itemData.isstackable,
					value = tonumber(itemData.value),
					itemCount = tonumber(count),
					var = "[]",
				}
				PickupItem(player, CraftItem)
				Delay(800, function()
					CallRemoteEvent(player, "PopulateCraft", PlayerData[player].inventory, c_Receipts)
				end)
			end
			if itemcraft.type == "vehicle" then
				local x, y, z = GetPlayerLocation(player)
				local vehicle = GetVehiclesDataByVehicleID(itemcraft.itemId)
				local newvehicle = CreateVehicle(vehicle.modelId, x, y, z, GetPlayerHeading(player))
				local vcles = PlayerData[player].id..vehicle.modelId..Random(0, 9999)
                VehicleData[newvehicle] = {id = 0, garageid = 1, compteId = 0, modelid = vehicle.modelId, health = v_health, degats = {}, imageid = vehicle.imageId, nom = vehicle.nom, cles = vcles, poids = vehicle.poids, fuel = 100, inventory = {}, locked = false}
				SetPlayerInVehicle(player, newvehicle)

				local CraftItem = {}
				local itemData = GetItemDataByItemID(30) -- clé id
				CraftItem = {
					nom = itemData.nom,
					poids = tonumber(itemData.poids),
					type = itemData.type,
					imageId = tonumber(itemData.imageId),
					modelId = tonumber(itemData.modelId),
					compteId = tonumber(PlayerData[player].id),
					itemId = tonumber(itemData.id),
					maxStack = tonumber(itemData.maxStack),
					isstackable = itemData.isstackable,
					value = tonumber(itemData.value),
					itemCount = tonumber(count),
					var = SLogic.json_encode({VehicleData[newvehicle].cles}),
				}
				PickupItem(player, CraftItem)
				Delay(800, function()
					CallRemoteEvent(player, "PopulateCraft", PlayerData[player].inventory, c_Receipts)
				end)
			end
			SetPlayerAnimation(player, 'STOP')
			UpdateWeight(player, false)
		end)
	end
end
AddRemoteEvent("Craft", Craft)

-- FONCTIONS --

function CreateCraft(itemId, imageId, nom, type, itemType, need, time)
	table.insert(c_Receipts, {
		id = Random(0, 99999),
		itemId = itemId,
		type = type,
		itemType = itemType,
		imageId = imageId,
		nom = nom,
		time = time,
		need = SLogic.json_encode(need)
	})
end

function GetCraft(id)
	for k, v in pairs(c_Receipts) do
		if tonumber(v.id) == tonumber(id) then
			return v
		end
	end
	return 0
end