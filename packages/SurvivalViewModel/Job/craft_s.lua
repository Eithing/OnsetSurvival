-- CRAFT CONFIG --
c_Receipts = {}

AddEvent("OnPackageStart", function()
	Delay(math.Seconds(1), function()
		CreateItemCraft(26, 20, {
			{name = GetItemDataByItemID(52).nom, itemId = 52, count = 20},
			{name = GetItemDataByItemID(53).nom, itemId = 53, count = 20}
		}, 5)
		
		CreateCraft(25, 25, "Dacia 2000", "vehicle", "cars", {
			{name = GetItemDataByItemID(51).nom, itemId = 51, count = 20},
			{name = GetItemDataByItemID(52).nom, itemId = 52, count = 20},
			{name = GetItemDataByItemID(53).nom, itemId = 53, count = 20}
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
	local itemcraft = GetCraft(id)
	if itemcraft ~= 0 then
		if itemcraft.type == "vehicle" then
			count = 1
		end
		local needitems = SLogic.json_decode(itemcraft.need)
		for k, v in pairs(needitems) do
			local id = GetItemByItemID(player, v.itemId)
			local itemcount = GetItemCountByItemID(player, v.itemId)
			if tonumber(itemcount) < (tonumber(v.count)*count) then
				AddNotification(player, "Vous avez pas assez de ressources sur vous!", "error")
				return false
			else
				RemoveItemByItemID(player, v.itemId, (tonumber(v.count)*count))
			end
		end

		SetPlayerAnimation(player, 'COMBINE')
		Delay(math.Seconds(itemcraft.time*count), function()
			if itemcraft.type == "item" then
				local itemData = GetItemDataByItemID(itemcraft.itemId)
				count = tonumber(count)
				for i=1, count do
					if count > 0 then
						local CraftItem = {}
						local calcul = math.clamp(tonumber(count), 0, tonumber(itemData.maxStack))
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
							itemCount = calcul,
							var = "[]",
						}
						PickupItem(player, CraftItem)
						count = count - calcul
					end
				end
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
				SetVehicleRespawnParams(newvehicle, false)
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

	for k, v in pairs(need) do
		local theitem = GetItemDataByItemID(tonumber(v.itemId))
		if theitem == 0 then
			print("Impossible de créer le craft ("..v.itemId..") | 'SurvivalViewModel/Job/craft_s.lua':127")
			return false
		end
	end

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
	print("Nouveau craft : "..nom)
end

function CreateItemCraft(itemId, imageId, need, time)
	local theitem = GetItemDataByItemID(tonumber(itemId))
	if theitem ~= 0 then
		table.insert(c_Receipts, {
			id = Random(0, 99999),
			itemId = itemId,
			type = "item",
			itemType = theitem.type,
			imageId = imageId,
			nom = theitem.nom,
			time = time,
			need = SLogic.json_encode(need)
		})
		print("Nouveau craft : "..theitem.nom)
		return true
	else
		print("Impossible de créer le craft ("..itemId..") | 'SurvivalViewModel/Job/craft_s.lua':152")
		return false
	end
end

function GetCraft(id)
	for k, v in pairs(c_Receipts) do
		if tonumber(v.id) == tonumber(id) then
			return v
		end
	end
	return 0
end