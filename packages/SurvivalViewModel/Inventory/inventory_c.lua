local isInventoryLoaded
AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        if isInventoryLoaded == false then
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
    ReloadInventory(inventory)
end
AddRemoteEvent("PopulateInventory",  PopulateInventory)

function ReloadInventory(inventory)
    SView.ExecuteJs("inventory", "inventory.removeAllItems()")
    for i, itemInventory in ipairs(inventory) do
        AddPlayerChat(itemInventory.nom)
        AddPlayerChat(itemInventory.itemCount)
        AddPlayerChat(itemInventory.imageId)
        AddPlayerChat(itemInventory.type)
        AddPlayerChat(itemInventory.idUnique)

        
        SView.ExecuteJs("inventory", "inventory.addItem('"..itemInventory.idUnique.."', 'container', new Item('"..itemInventory.type.."','"..itemInventory.imageId.."','"..itemInventory.itemCount.."','"..itemInventory.nom.."'))")
    end
end
AddRemoteEvent("ReloadInventory",  ReloadInventory)

function AddItemInventory(item)
        SView.ExecuteJs("inventory", "inventory.addItem('"..item.idUnique.."', 'container', new Item('"..item.type.."','"..item.imageId.."','"..item.itemCount.."','"..item.nom.."'))")
end
AddRemoteEvent("AddItemInventory",  AddItemInventory)