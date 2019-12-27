AddEvent("OnAdminClick", function(item, type)
    if type == "main" then
        if(item == "1") then
            ExecuteWebJS(adminHud, "buildList('cars')")
        elseif(item == "2") then
            ExecuteWebJS(adminHud, "buildList('weapons')")
        elseif(item == "3") then
            ExecuteWebJS(adminHud, "buildList('cloth')")
        elseif(item == "4") then
            QuitCloseHud(adminHud)
        end
    elseif(type == "weapons" or type == "cars") then
        SViewModel.ExecuteFromServer("OnAdminAction", type, item)
        QuitCloseHud(adminHud)
    elseif(type == "cloth")then
        SetPlayerClothingPreset(GetPlayerId(), item)
        QuitCloseHud(adminHud)
    end
end)

function SetAdminVisibility(visibility)
    if GetWebVisibility(adminHud) == WEB_VISIBLE then
        SetVisibility(adminHud, "Hidden")
    else
        SetVisibility(adminHud, "VisibleMove")
        ExecuteJs(adminHud, "buildList('main')")
    end
end
AddFunctionExport("SetAdminVisibility", SetAdminVisibility)