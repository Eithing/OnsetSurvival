SViewModel = ImportPackage("SurvivalViewModel")

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

    VehicleHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(VehicleHud, 1.0, 0.0)
    SetWebAnchors(VehicleHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(VehicleHud, "http://asset/SurvivalView/Vehicle/vehicle.html")
    SetWebVisibility(VehicleHud, WEB_HIDDEN)

    garageHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(garageHud, 1.0, 0.0)
    SetWebAnchors(garageHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(garageHud, "http://asset/SurvivalView/Garage/garage.html")
    SetWebVisibility(garageHud, WEB_HIDDEN)

    inventoryHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(inventoryHud, 1.0, 0.0)
    SetWebAnchors(inventoryHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(inventoryHud, "http://asset/SurvivalView/Inventory/inventory.html")
    SetWebVisibility(inventoryHud, WEB_HIDDEN)
end)

function ExecuteJs(hud, js)
    if hud == "inventory" then
        AddPlayerChat(js)
        ExecuteWebJS(inventoryHud, js)
   --[[  elseif hud == "craft" then
        ExecuteWebJS(CraftHud, js) ]]
    elseif hud == "vitalIndicator"then
        ExecuteWebJS(PlayerHud, js)
    elseif hud == "vehicle" then
        ExecuteWebJS(VehicleHud, js)
    elseif hud == "character" then
        ExecuteWebJS(characterHud, js)
    elseif hud == "garage" then
        ExecuteWebJS(garageHud, js)
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

AddEvent("OnWebLoadComplete", function(web)
    if web == PlayerHud then
        SViewModel.ExecuteFromServer("OnPlayerHudLoadComplete")
    end
end)
