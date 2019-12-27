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
        AddPlayerChat(itemInventory.type)
        
        SView.ExecuteJs("inventory", "inventory.addItem('container', new Item('"..itemInventory.type.."','"..itemInventory.imageId.."','1'))")
    end
end
AddRemoteEvent("PopulateInventory",  PopulateInventory)