SViewModel = ImportPackage("SurvivalViewModel")

local PlayerHud
local characterHud

AddEvent("OnPackageStart", function()
	ShowWeaponHUD(false)
    ShowHealthHUD(false)

    PlayerHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(PlayerHud, 1.0, 0.0)
    SetWebAnchors(PlayerHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(PlayerHud, "http://asset/SurvivalView/VitalIndicator/health.html")
    SetWebVisibility(PlayerHud, WEB_HITINVISIBLE)

    characterHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(characterHud, 1.0, 0.0)
    SetWebAnchors(characterHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(characterHud, "http://asset/SurvivalView/Character/character.html")
    SetWebVisibility(characterHud, WEB_HIDDEN)
end)

function updateHud()    
    ExecuteWebJS(PlayerHud, "SetHealth("..GetPlayerHealth()..");")
    ExecuteWebJS(PlayerHud, "SetThirst("..GetPlayerPropertyValue(GetPlayerId(), "thirst")..");")
    ExecuteWebJS(PlayerHud, "SetHunger("..GetPlayerPropertyValue(GetPlayerId(), "hunger")..");")
end

AddEvent( "OnGameTick", function()
    -- Hud refresh
    updateHud()
end )

function hideRPHud()
    SetWebVisibility(PlayerHud, WEB_HIDDEN)
end

function showRPHud()
    SetWebVisibility(PlayerHud, WEB_HITINVISIBLE)
end
AddFunctionExport("hideRPHud", hideRPHud)
AddFunctionExport("showRPHud", showRPHud)