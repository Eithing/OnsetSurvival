AddRemoteEvent("RequestPopulateInventory", function(player)
	CallRemoteEvent(player, "PopulateInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
end)

AddRemoteEvent("equipWeapon", function(player, id, slot, ammo)
	SetPlayerWeapon(player, id, ammo, true, slot, false)
end)

AddRemoteEvent("RemoveItem", function(player, idUnique)
	local x,y,z = GetPlayerLocation(player)
	local modelId = SLogic.GetModelFromItem(idUnique)

	for i, item in ipairs(UserData[tostring(GetPlayerSteamId(player))].inventoryItems) do
		if item.idUnique == idUnique then
			UserData[tostring(GetPlayerSteamId(player))].inventoryItems[i] = nil
<<<<<<< HEAD
			return
=======
>>>>>>> 56bd6fd... delete useless print
		end
	end
	SLogic.RemoveItemInventory(idUnique)
	CreatePickup(modelId, x, y, z - 88)
end)