function SetCraftVisibility()
    if GetWebVisibility(CraftHud) == WEB_VISIBLE then
        SetVisibility(CraftHud, "Hidden")
        return false
    else
        SetVisibility(CraftHud, "VisibleStatic")
        return true
    end
end
AddFunctionExport("SetCraftVisibility", SetCraftVisibility)

AddEvent("onCraft", function(id, count)
    SetCraftVisibility()
    SViewModel.ExecuteFromServer("Craft", id, count)
end)