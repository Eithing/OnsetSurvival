function SetInventoryVisibility()
    if GetWebVisibility(inventoryHud) == WEB_VISIBLE then
        SetVisibility(inventoryHud, "Hidden")
    else
        SetVisibility(inventoryHud, "VisibleStatic")
    end
end
AddFunctionExport("SetInventoryVisibility", SetInventoryVisibility)

AddEvent("onEquipWeapon", function(id, slot, ammo)
    SViewModel.ExecuteFromServer("equipWeapon", id, slot, ammo)
end)