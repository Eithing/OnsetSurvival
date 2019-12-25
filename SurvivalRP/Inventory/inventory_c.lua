local isInventoryLoaded
local inventoryMenu = CreateWebUI(0, 0, 0, 0, 2, 16)
SetWebAlignment(inventoryMenu, 0, 0)
SetWebAnchors(inventoryMenu, 0, 0, 1, 1)
LoadWebFile(inventoryMenu, "http://asset/SurvivalRP/Inventory/gui/inventory.html")
SetWebVisibility(inventoryMenu, WEB_HIDDEN)

AddEvent("OnPackageStart", function()
    isInventoryLoaded = false
end)




AddEvent("OnKeyRelease", function(key)
    if key == "F1" then
        if GetWebVisibility(inventoryMenu) == WEB_VISIBLE then
            QuitInventoryMenu()
        else
            if(isInventoryLoaded == false)then
                CallRemoteEvent("RequestPopulateInventory")
                isInventoryLoaded = true
            end
            SetWebVisibility(inventoryMenu, WEB_VISIBLE)
            SetIgnoreLookInput(true)
            SetIgnoreMoveInput(true)
            ShowMouseCursor(true)
            SetInputMode(INPUT_GAMEANDUI)
        end
    end
end)

function QuitInventoryMenu()
    SetIgnoreLookInput(false)
    ShowMouseCursor(false)
    SetIgnoreMoveInput(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(inventoryMenu, WEB_HIDDEN)
end

function PopulateInventory(inventory)
    for i, itemInventory in ipairs(inventory) do
        ExecuteWebJS(inventoryMenu, "inventory.addItem('container', new Item('"..itemInventory.type.."','"..itemInventory.imageId.."'))")
	end
end
AddRemoteEvent("PopulateInventory",  PopulateInventory)