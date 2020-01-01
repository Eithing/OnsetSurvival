function SetCharacterVisibility()
    if GetWebVisibility(characterHud) == WEB_VISIBLE then
        SetVisibility(characterHud, "Hidden")
        return false
    else
        SetVisibility(characterHud, "VisibleStatic")
        return true
    end
end
AddFunctionExport("SetCharacterVisibility", SetCharacterVisibility)

AddEvent("OnInsertPlayer", function(firstname, lastname, clothing)
    SViewModel.ExecuteFromServer("InsertPlayer", firstname, lastname, clothing)
    CallRemoteEvent("UpdateWeight", SetCharacterVisibility())
end)