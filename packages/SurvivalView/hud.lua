SViewModel = ImportPackage("SurvivalViewModel")
inventoryHud = nil

AddEvent("OnPackageStart", function()
	ShowWeaponHUD(false)
    ShowHealthHUD(false)
    mainHud = InstanciateHud("http://asset/SurvivalView/VitalIndicator/health.html", "HitInvisible")
    adminHud = InstanciateHud("http://asset/SurvivalView/Admin/admin.html", "Hidden")
    inventoryHud = InstanciateHud("http://asset/SurvivalView/Inventory/inventory.html", "Hidden")
end)

AddEvent("OnPackageStop", function() 
	DestroyWebUI(mainHud)
end)

function ExecuteJs(hud, js)
    if(hud == "inventory")then
        AddPlayerChat(js)
        
        ExecuteWebJS(inventoryHud, js)
    end
    ExecuteWebJS(hud, js)
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