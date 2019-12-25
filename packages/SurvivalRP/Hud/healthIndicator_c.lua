local healthBoard
local baseY = 1080
local calculedY = 1155
local movementMode

AddEvent("OnPackageStart", function()
	ShowWeaponHUD(false)
	ShowHealthHUD(false)
	local ScreenX, ScreenY = GetScreenSize()
	healthBoard = CreateWebUI(0, ((calculedY * ScreenY) / baseY), 450, 70, 1, 16)
	LoadWebFile(healthBoard, "http://asset/SurvivalRP/Hud/gui/health/health.html")
	SetWebVisibility(healthBoard, WEB_HITINVISIBLE)
end)

AddEvent("OnKeyPress", function(key)
	CallRemoteEvent("OnKeyPressed")
end)

AddEvent("OnKeyRelease", function(key)
	CallRemoteEvent("OnKeyReleased")
end)

AddEvent("OnPackageStop", function()
	DestroyWebUI(healthBoard)
end)

AddEvent("OnResolutionChange", function(width, height)
	local ScreenX, ScreenY = GetScreenSize()
	SetWebLocation(healthBoard, 0, ((calculedY * ScreenY) / baseY))
end)

function OnGetHealthUpdated(player)
	ExecuteWebJS(healthBoard, "ChangeColor("..GetPlayerHealth()..")")
end
AddRemoteEvent("OnGetHealthUpdated",  OnGetHealthUpdated)

function OnUpdateVitalIndicator(eat, drink)
	ExecuteWebJS(healthBoard, "UpdateVital("..eat..","..drink..")")
end
AddRemoteEvent("OnUpdateVitalIndicator",  OnUpdateVitalIndicator)

AddEvent("OnPlayerSpawn", function(playerid)
	OnGetHealthUpdated()
	local playerMovementMode = GetPlayerMovementMode(playerid)
end)

function SetOceanHeight(hauteur)
	SetOceanWaterLevel(hauteur)
end
AddRemoteEvent("SetOceanHeight",  SetOceanHeight)
