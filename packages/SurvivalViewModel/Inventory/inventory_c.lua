AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        CallRemoteEvent("RequestPopulateInventory")
        SView.SetInventoryVisibility()
    end
end)

AddEvent("OnPackageStart", function()
    isInventoryLoaded = false
end)

function PopulateInventory(inventory)
    ReloadInventory(inventory)
end
AddRemoteEvent("PopulateInventory",  PopulateInventory)

function ReloadInventory(inventory)
    SView.ExecuteJs("inventory", "inventory.removeAllItems()")
    for i, itemInventory in ipairs(inventory) do
        SView.ExecuteJs("inventory", "inventory.addItem('"..itemInventory.idUnique.."', 'container', new Item('"..itemInventory.type.."','"..itemInventory.imageId.."','"..itemInventory.itemCount.."','"..itemInventory.itemId.."'))")
    end
end
AddRemoteEvent("ReloadInventory",  ReloadInventory)