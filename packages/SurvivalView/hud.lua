SViewModel = ImportPackage("SurvivalViewModel")

--local PlayerHud
--local characterHud

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

    adminHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(adminHud, 1.0, 0.0)
    SetWebAnchors(adminHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(adminHud, "http://asset/SurvivalView/Admin/admin.html")
    SetWebVisibility(adminHud, WEB_HIDDEN)
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

function ExecuteJs(hud, js)
    if hud == "inventory" then
        ExecuteWebJS(inventoryHud, js)
    elseif hud == "craft" then
        ExecuteWebJS(CraftHud, js)
    elseif hud == "vitalIndicator"then
        ExecuteWebJS(mainHud, js)
    elseif hud == "vehicle" then
        ExecuteWebJS(VehicleHud, js)
    elseif hud == "character" then
        ExecuteWebJS(characterHud, js)
    else
        ExecuteWebJS(hud, js)
    end
end
AddFunctionExport("ExecuteJs", ExecuteJs)

function SetVisibility(hud, visibility)
    if visibility == "HitInvisible" then
        SetWebVisibility(hud, WEB_HITINVISIBLE)
    elseif visibility == "Hidden" then
        QuitCloseHud(hud)
    elseif visibility == "VisibleMove" then
        SetWebVisibility(hud, WEB_VISIBLE)
        SetIgnoreLookInput(true)
        ShowMouseCursor(true)
        SetInputMode(INPUT_GAMEANDUI)
    elseif visibility == "VisibleStatic" then
        SetWebVisibility(hud, WEB_VISIBLE)
        SetIgnoreLookInput(true)
        SetIgnoreMoveInput(true)
        ShowMouseCursor(true)
        SetInputMode(INPUT_GAMEANDUI)
    end
end

function QuitCloseHud(hud)
    SetIgnoreLookInput(false)
    ShowMouseCursor(false)
    SetIgnoreMoveInput(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(hud, WEB_HIDDEN)
end