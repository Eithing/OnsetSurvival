local isAiming = nil
local keyForAim = nil
AddEvent("OnPlayerSpawn", function(playerid)
	SetPlayerClothingPreset(GetPlayerId(), 7)
	SetNearClipPlane(15)
end)





--
--	FEATURE FIRST PERSON ON SCOPE KO
--
--[[ AddEvent("OnKeyPress", function(key)
	CreateCountTimer(function()
		if IsPlayerAiming(GetPlayerId()) and IsFirstPersonCamera() == false then
			EnableFirstPersonCamera(true)
			
			keyForAim = key
			isAiming = true
		end
	end, '50' , 1)
end)

AddEvent("OnKeyRelease", function(key)
	
	if keyForAim == key and isAiming then
		EnableFirstPersonCamera(false)
		isAiming = false
	end
end) ]]

