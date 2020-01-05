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

AddEvent("OnUseItem", function(id, count)
    AddPlayerChat("OnUseItem")
    SViewModel.ExecuteFromServer("UseItem", tonumber(id), math.floor(tonumber(count)))
end)

AddEvent("OnRemoveItem", function(id, count)
    AddPlayerChat("OnRemoveItem")
    SViewModel.ExecuteFromServer("RemoveItem", tonumber(id), math.floor(tonumber(count)))
end)

AddEvent("OnDropItem", function(id, count)
    AddPlayerChat("OnDropItem")
    SViewModel.ExecuteFromServer("DropItem", tonumber(id), math.floor(tonumber(count)))
end)