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

AddEvent("OnUseItem", function(id)
    SViewModel.ExecuteFromServer("UseItem", id)
end)

AddEvent("OnRemoveItem", function(id)
    SViewModel.ExecuteFromServer("RemoveItem", id)
end)

AddEvent("OnDropItem", function(id)
    SViewModel.ExecuteFromServer("DropItem", id)
end)