AddEvent("OnAdminClick", function(item, type)
    if type == "main" then
        if(item == "1") then
            ExecuteWebJS(adminHud, "buildList('weapons')")
        elseif(item == "2") then
            QuitCloseHud(adminHud)
        end
    else
        SViewModel.ExecuteFromServer("OnAdminAction", type, item)
        QuitCloseHud(adminHud)
    end
end)

function SetAdminVisibility(visibility)
    if GetWebVisibility(adminHud) == WEB_VISIBLE then
        SetVisibility(adminHud, "Hidden")
        return false
    else
        SetVisibility(adminHud, "VisibleMove")
        ExecuteJs(adminHud, "buildList('main')")
        return true
    end
end
AddFunctionExport("SetAdminVisibility", SetAdminVisibility)