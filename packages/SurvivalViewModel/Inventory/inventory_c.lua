local isInventoryLoaded

AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        if(isInventoryLoaded == false)then
            CallRemoteEvent("RequestPopulateInventory")
            isInventoryLoaded = true
        end
        SView.SetInventoryVisibility()
    end
end)

AddEvent("OnPackageStart", function()
    isInventoryLoaded = false
end)

function PopulateInventory(inventory)
    for i, itemInventory in ipairs(inventory) do
        AddPlayerChat(itemInventory.imageId)
        
        SView.ExecuteJs("inventory", "inventory.addItem('"..itemInventory.idUnique.."', 'container', new Item('"..itemInventory.type.."','"..itemInventory.imageId.."','"..itemInventory.itemCount.."','"..itemInventory.nom.."'))")
    end
end
AddRemoteEvent("PopulateInventory",  PopulateInventory)

function ReloadInventory(inventory)
    SView.ExecuteJs("inventory", "inventory.removeAllItems()")
    for i, itemInventory in ipairs(inventory) do
        SView.ExecuteJs("inventory", "inventory.addItem('"..itemInventory.idUnique.."', 'container', new Item('"..itemInventory.type.."','"..itemInventory.imageId.."','"..itemInventory.itemCount.."','"..itemInventory.nom.."'))")
    end
end
AddRemoteEvent("ReloadInventory",  ReloadInventory)