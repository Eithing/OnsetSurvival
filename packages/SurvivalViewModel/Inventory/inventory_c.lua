local isInventoryLoaded = false
AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        CallRemoteEvent("UpdateWeight", SView.SetInventoryVisibility())
        if isInventoryLoaded == false then
            Delay(800, function()
                CallRemoteEvent("RequestPopulateInventory")
                isInventoryLoaded = true
            end)
        end
    end
end)

function PopulateInventory(inventory)
    ReloadInventory(inventory)
end
AddRemoteEvent("PopulateInventory",  PopulateInventory)

function ReloadInventory(inventory)
    SView.ExecuteJs("inventory", "inventory.removeAllItems()")
    for i, itemInventory in pairs(inventory) do
        AddItemInventory(itemInventory)
    end
end
AddRemoteEvent("ReloadInventory",  ReloadInventory)

function AddItemInventory(item)
   SView.ExecuteJs("inventory", "inventory.addItem('"..item.id.."', 'container', new Item('"..item.itemId.."','"..item.type.."','"..item.imageId.."','"..math.floor(item.itemCount).."','"..item.nom.."'))")
end
AddRemoteEvent("AddItemInventory",  AddItemInventory)

function UpdateItemInventory(item)
    SView.ExecuteJs("inventory", "inventory.updateitem('"..item.id.."', '"..math.floor(item.itemCount).."')")
end
AddRemoteEvent("UpdateItemInventory",  UpdateItemInventory)

function RemoveItemInventory(item)
    SView.ExecuteJs("inventory", "inventory.deleteitem('"..item.id.."')")
end
AddRemoteEvent("RemoveItemInventory",  RemoveItemInventory)

function UpdateMaxWeightInventory(Weight, MaxWeight)
    SView.ExecuteJs("inventory", "inventory.updateMaxWeight('"..Weight.."', '"..MaxWeight.."')")
end
AddRemoteEvent("UpdateMaxWeightInventory",  UpdateMaxWeightInventory)

function IsGettingMaxWeight(Weight, MaxWeight)
    UpdateMaxWeightInventory(Weight, MaxWeight)
    SetIgnoreMoveInput(true)
end
AddRemoteEvent("IsGettingMaxWeight",  IsGettingMaxWeight)

function IsGettingCorrectWeight(Weight, MaxWeight)
    UpdateMaxWeightInventory(Weight, MaxWeight)
    SetIgnoreMoveInput(false)
end
AddRemoteEvent("IsGettingCorrectWeight",  IsGettingCorrectWeight)