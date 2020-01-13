function SetMapVisibility()
    if GetWebVisibility(MapHud) == WEB_VISIBLE then
        SetVisibility(MapHud, "Hidden")
        return false
    else
        SetVisibility(MapHud, "VisibleMove")
        return true
    end
end
AddFunctionExport("SetMapVisibility", SetMapVisibility)