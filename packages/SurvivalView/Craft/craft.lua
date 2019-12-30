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

--[[ AddEvent("onEquipWeapon", function(id, slot, ammo)
    SViewModel.ExecuteFromServer("equipWeapon", id, slot, ammo)
end) ]]