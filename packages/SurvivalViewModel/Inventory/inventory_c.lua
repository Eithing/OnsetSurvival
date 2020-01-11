local isInventoryLoaded = false
AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        RemoveAllHud("inventory")
        local visibility = SView.SetInventoryVisibility()
        CallRemoteEvent("UpdateWeight", visibility)
        if isInventoryLoaded == false then
            Delay(800, function()
                CallRemoteEvent("RequestPopulateInventory")
                isInventoryLoaded = true
            end)
        end
        CallRemoteEvent("SearchProximityInventory", visibility)
    end
    if key == "E" then
        local x, y, z = GetPlayerLocation()
        for k, v in pairs(GetStreamedObjects()) do
            local x2, y2, z2 = GetObjectLocation(v)
            if GetObjectPropertyValue(v, "IsItemInventory") ~= nil and GetDistance3D(x, y, z, x2, y2, z2) < 150 then
                CallRemoteEvent("ItemPickup", v)
            elseif GetObjectPropertyValue(v, "IsMoney") ~= nil and GetDistance3D(x, y, z, x2, y2, z2) < 150 then
                CallRemoteEvent("MoneyPickup", v)
            end
        end
    end
end)

local itemnotifobject = nil
local itemnotif = false
local itemnotifid = 0
CreateTimer(function()
    local x, y, z = GetPlayerLocation()
    for k, v in pairs(GetStreamedObjects()) do
        local x2, y2, z2 = GetObjectLocation(v)
        if (GetObjectPropertyValue(v, "IsItemInventory") ~= nil or GetObjectPropertyValue(v, "IsMoney") ~= nil) and GetDistance3D(x, y, z, x2, y2, z2) < 150 then
            if itemnotif == false and PlayerIsInVehicle() == false then
                itemnotifid = AddNotification("Appuyer sur E pour ramasser", "default", 999)
                itemnotif = true
                itemnotifobject = v
            end
        end
    end
    
    if itemnotifobject ~= nil then
        if IsValidObject(itemnotifobject) then
            local x2, y2, z2 = GetObjectLocation(itemnotifobject)
            if GetDistance3D(x, y, z, x2, y2, z2) > 150 and itemnotif == true then
                SView.ExecuteJs("vitalIndicator", 'RemoveNotification("'..itemnotifid..'")')
                itemnotif = false
                itemnotifid = 0
                itemnotifobject = nil
            end
        else
            SView.ExecuteJs("vitalIndicator", 'RemoveNotification("'..itemnotifid..'")')
            itemnotif = false
            itemnotifid = 0
            itemnotifobject = nil
        end
    end
end, 800)

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

function UpdateMoneyInventory(money)
    SView.ExecuteJs("inventory", "inventory.updateMoney('"..money.."')")
end
AddRemoteEvent("UpdateMoneyInventory",  UpdateMoneyInventory)

function IsGettingMaxWeight(Weight, MaxWeight, Money)
    UpdateMaxWeightInventory(Weight, MaxWeight)
    UpdateMoneyInventory(Money)
    SetIgnoreMoveInput(true)
end
AddRemoteEvent("IsGettingMaxWeight",  IsGettingMaxWeight)

function IsGettingCorrectWeight(Weight, MaxWeight, Money)
    UpdateMaxWeightInventory(Weight, MaxWeight)
    UpdateMoneyInventory(Money)
    SetIgnoreMoveInput(false)
end
AddRemoteEvent("IsGettingCorrectWeight",  IsGettingCorrectWeight)

AddEvent("OnObjectStreamIn", function(object)
	if GetObjectPropertyValue(object, "DontCollison") ~= nil then
		local ObjectActor = GetObjectActor(object)
		-- Alos disable its collision
        ObjectActor:SetActorEnableCollision(false)

        -- Pas touchez
        --local basic = GetObjectStaticMeshComponent(object)
        --basic:SetCollisionEnabled(ECollisionEnabled.QueryAndPhysics)
        --basic:SetMobility(EComponentMobility.Movable)
        --basic:SetEnableGravity(true)
        --AddPlayerChat(tostring(basic:IsSimulatingPhysics()))
	end
end)