local AdminMenu = CreateWebUI(0, 0, 0, 0, 1, 16)
SetWebAlignment(AdminMenu, 0, 0)
SetWebAnchors(AdminMenu, 0, 0, 1, 1)
LoadWebFile(AdminMenu, "http://asset/SurvivalRP/Admin/gui/admin.html")
SetWebVisibility(AdminMenu, WEB_HIDDEN)

AddEvent("OnKeyRelease", function(key)
    if key == "F4" then
        CallRemoteEvent("OpenAdminContext")
    end
end)

function AdminOpenMenu(player)
    if GetWebVisibility(AdminMenu) == WEB_VISIBLE then
        QuitAdminMenu()
    else
        SetWebVisibility(AdminMenu, WEB_VISIBLE)
        ExecuteWebJS(AdminMenu, "buildList(1,4,'main','1','2','3','4')")
        SetIgnoreLookInput(true)
        ShowMouseCursor(true)
        SetInputMode(INPUT_GAMEANDUI)
    end
end
AddRemoteEvent("AdminOpenMenu",  AdminOpenMenu)

AddEvent("OnPackageStop", function()
	DestroyWebUI(AdminMenu)
end)

AddEvent("OnAdminClick", function(item, type)
    if type == "main" then
        if(item == "1") then
            ExecuteWebJS(AdminMenu, "buildList(3,9,'cars','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25')")
        elseif(item == "2") then
            ExecuteWebJS(AdminMenu, "buildList(2,10,'weapons','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20')")
        elseif(item == "3") then
            ExecuteWebJS(AdminMenu, "buildList(3,10,'cloth','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29')")
        elseif(item == "4") then
            QuitAdminMenu()
        end
    elseif(type == "weapons" or type == "cars") then
        CallRemoteEvent("OnAdminAction", type, item)
        QuitAdminMenu()
    elseif(type == "cloth")then
        SetPlayerClothingPreset(GetPlayerId(), item)
        QuitAdminMenu()
    end
end)

function QuitAdminMenu()
    SetIgnoreLookInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(AdminMenu, WEB_HIDDEN)
end