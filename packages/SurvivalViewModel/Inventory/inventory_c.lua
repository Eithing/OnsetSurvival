local isInventoryLoaded
AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        if isInventoryLoaded == false then
            CallRemoteEvent("RequestPopulateInventory")
            isInventoryLoaded = true
        end
        SView.SetInventoryVisibility()
        --CallRemoteEvent("UpdateWeight", SView.SetInventoryVisibility())
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
        AddItemInventory(itemInventory)
    end
end
AddRemoteEvent("ReloadInventory",  ReloadInventory)

function AddItemInventory(item)
   SView.ExecuteJs("inventory", "inventory.addItem('"..item.id.."', 'container', new Item('"..item.itemId.."','"..item.type.."','"..item.imageId.."','"..item.itemCount.."','"..item.nom.."'))")
end
AddRemoteEvent("AddItemInventory",  AddItemInventory)

function UpdateItemInventory(item)
    SView.ExecuteJs("inventory", "inventory.updateitem('"..item.id.."', '"..item.itemCount.."')")
end
AddRemoteEvent("UpdateItemInventory",  UpdateItemInventory)

function IsGettingMaxWeight(IsAlreadyHeavy)
    SetIgnoreMoveInput(true)
    if IsAlreadyHeavy == false then
        AddPlayerChat('<span color="#ff0000">Vous êtes trop lourd vous ne pouvez plus bouger !</>')
    end
end
AddRemoteEvent("IsGettingMaxWeight",  IsGettingMaxWeight)

function IsGettingCorrectWeight()
    SetIgnoreMoveInput(false)
end
AddRemoteEvent("IsGettingCorrectWeight",  IsGettingCorrectWeight)