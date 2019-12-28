SViewModel = ImportPackage("SurvivalViewModel")

AddEvent("OnPackageStart", function()
	ShowWeaponHUD(false)
    ShowHealthHUD(false)
    mainHud = InstanciateHud("http://asset/SurvivalView/VitalIndicator/health.html", "HitInvisible")
    adminHud = InstanciateHud("http://asset/SurvivalView/Admin/admin.html", "Hidden")
    inventoryHud = InstanciateHud("http://asset/SurvivalView/Inventory/inventory.html", "Hidden")
    CraftHud = InstanciateHud("http://asset/SurvivalView/Craft/craft.html", "Hidden")
end)

AddEvent("OnPackageStop", function() 
    DestroyWebUI(mainHud)
	DestroyWebUI(adminHud)
	DestroyWebUI(inventoryHud)
	DestroyWebUI(CraftHud)
end)

function ExecuteJs(hud, js)
    if hud == "inventory" then
        ExecuteWebJS(inventoryHud, js)
    elseif hud == "craft" then
        ExecuteWebJS(CraftHud, js)
    elseif hud == "vitalIndicator"then
        ExecuteWebJS(mainHud, js)
    else
        ExecuteWebJS(hud, js)
    end
end
AddFunctionExport("ExecuteJs", ExecuteJs)

function InstanciateHud(url, visibility)
    local hud = CreateWebUI(0, 0, 0, 0, 1, 16)
    SetWebAlignment(hud, 0, 0)
    SetWebAnchors(hud, 0, 0, 1, 1)
    LoadWebFile(hud, url)
    SetVisibility(hud, visibility)
    return hud
end

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