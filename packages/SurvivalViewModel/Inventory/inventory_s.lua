AddRemoteEvent("RequestPopulateInventory", function(player)
	CallRemoteEvent(player, "PopulateInventory", UserData[tostring(GetPlayerSteamId(player))].inventoryItems)
end)

AddRemoteEvent("equipWeapon", function(player, id, slot, ammo)
	SetPlayerWeapon(player, id, ammo, true, slot, false)
end)
