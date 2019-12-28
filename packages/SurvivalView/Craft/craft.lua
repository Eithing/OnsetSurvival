function SetCraftVisibility()
    if GetWebVisibility(CraftHud) == WEB_VISIBLE then
        SetVisibility(CraftHud, "Hidden")
    else
        SetVisibility(CraftHud, "VisibleStatic")
    end
end
AddFunctionExport("SetCraftVisibility", SetCraftVisibility)

--[[ AddEvent("onEquipWeapon", function(id, slot, ammo)
    SViewModel.ExecuteFromServer("equipWeapon", id, slot, ammo)
end) ]]