AddRemoteEvent("RequestPopulateInventory", function(player)
	for i, user in ipairs(UserData) do		
        if user.steamId == tostring(GetPlayerSteamId(player)) then
			CallRemoteEvent(player, "PopulateInventory", UserData[player].inventoryItems)
			return
		end
	end
end)

AddRemoteEvent("equipWeapon", function(player, id, slot, ammo)
	SetPlayerWeapon(player, id, ammo, true, slot, false)
end)
