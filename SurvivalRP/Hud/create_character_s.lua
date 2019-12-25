AddEvent("OnPlayerSteamAuth",function (player)
    for i, user in ipairs(UserData) do
		if user.steamId == tostring(GetPlayerSteamId(player)) then
			return
		end
    end
    
    print("no user")
    CallRemoteEvent(player, "DisplayCreateCharacter")
end)