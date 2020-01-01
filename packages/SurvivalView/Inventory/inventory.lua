function SetInventoryVisibility()
    if GetWebVisibility(inventoryHud) == WEB_VISIBLE then
        SetVisibility(inventoryHud, "Hidden")
        return false
    else
        SetVisibility(inventoryHud, "VisibleStatic")
        return true
    end
end
AddFunctionExport("SetInventoryVisibility", SetInventoryVisibility)

AddEvent("onEquipWeapon", function(id, slot, ammo)
    SViewModel.ExecuteFromServer("equipWeapon", id, slot, ammo)
end)

AddEvent("OnUseItem", function(idUnique)
    SViewModel.ExecuteFromServer("UseItem", idUnique)
end)

AddEvent("OnRemoveItem", function(idUnique)
    SViewModel.ExecuteFromServer("RemoveItem", idUnique)
end)

AddEvent("OnDropItem", function(idUnique)
    SViewModel.ExecuteFromServer("DropItem", idUnique)
end)