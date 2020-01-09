AddEvent("OnKeyRelease", function(key)
    if key == "F3" then
        RemoveAllHud("craft")
        CallRemoteEvent("UpdateWeight", SView.SetCraftVisibility())
    end
end)

function PopulateCraft(inventory, receipts)
    ReloadCraft(inventory, receipts)
end
AddRemoteEvent("PopulateCraft",  PopulateCraft)

function ReloadCraft(inventory, receipts)
    SView.ExecuteJs("craft", "craftInventory.removeAllItems()")
    for i, itemInventory in pairs(inventory) do
        AddItemCraft(itemInventory)
    end
    SView.ExecuteJs("craft", "craftInventory.removeAllReceipt()")
    for i, receipt in pairs(receipts) do
        AddReceiptCraft(receipt)
    end
end
AddRemoteEvent("ReloadInventory",  ReloadInventory)

function AddItemCraft(item)
   SView.ExecuteJs("craft", "craftInventory.addItem('"..item.id.."', new Item('"..item.itemId.."','"..item.type.."','"..item.imageId.."','"..math.floor(item.itemCount).."','"..item.nom.."'))")
end
AddRemoteEvent("AddItemCraft",  AddItemCraft)

function RemoveItemCraft(item)
    SView.ExecuteJs("craft", "craftInventory.removeItem('"..item.id.."')")
end
AddRemoteEvent("RemoveItemCraft",  RemoveItemCraft)

function AddReceiptCraft(receipt)
   SView.ExecuteJs("craft", "craftInventory.addReceipt('"..receipt.id.."', new Receipt('"..receipt.id.."','"..receipt.itemId.."','"..receipt.itemType.."','"..receipt.imageId.."','"..receipt.nom.."',"..receipt.need.."))")
end
AddRemoteEvent("AddReceiptCraft",  AddReceiptCraft)