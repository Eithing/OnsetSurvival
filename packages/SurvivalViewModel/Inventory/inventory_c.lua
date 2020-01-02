local isInventoryLoaded

AddEvent("OnPackageStart", function()
    isInventoryLoaded = false
end)

AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        if(GetPlayerPropertyValue(GetPlayerId(), "PlayerIsCharged") == true)then
            if isInventoryLoaded == false then
                CallRemoteEvent("RequestPopulateInventory")
                isInventoryLoaded = true
            end
            local visibility = SView.SetInventoryVisibility()
            CallRemoteEvent("UpdateWeight", visibility)
            CallRemoteEvent("SearchProximityInventory", visibility)
        end
    end
end)

AddRemoteEvent("ReloadInventory", function(inventory)
    SView.ExecuteJs("inventory", "inventory.removeAllItems()")
    for i, itemInventory in pairs(inventory) do 
        AddItemInventory(itemInventory)
    end
end)

function AddItemInventory(item)
    SView.ExecuteJs("inventory", "inventory.addItem('"..item.idUnique.."', 'container', new Item('"..item.itemId.."','"..item.type.."','"..item.imageId.."','"..item.itemCount.."','"..item.nom.."'))")
end
AddRemoteEvent("AddItemInventory",  AddItemInventory)

function UpdateItemInventory(item)
    SView.ExecuteJs("inventory", "inventory.updateitem('"..item.idUnique.."', '"..item.itemCount.."')")
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