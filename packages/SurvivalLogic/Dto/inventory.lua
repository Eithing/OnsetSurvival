local InventoryItems = {}
AddEvent("OnPlayerJoin", function(player)
    GetUserInventory(player)
end)

function GetUserInventory(player)
	local inventoryRequest = mariadb_prepare(Sql, "SELECT * FROM items INNER JOIN compte_item ON items.id = compte_item.itemid WHERE compte_item.compteId = '?';", UserData[player].id)
	mariadb_query(Sql, inventoryRequest, function()
		local rows = mariadb_get_row_count()
		for i=1, rows do
			local id = mariadb_get_value_name(i, "")
			InventoryItems[i] = {id = mariadb_get_value_name(i, "id"),
								nom = mariadb_get_value_name(i, "nom"),
								poids = mariadb_get_value_name(i, "poids"),
								type = mariadb_get_value_name(i, "type"),
								imageId = mariadb_get_value_name(i, "imageId"),
								itemCount = mariadb_get_value_name(i, "itemCount"),
								compteId = mariadb_get_value_name(i, "compteId"),
								itemId = mariadb_get_value_name(i, "itemId")}
		end

		ViewModel.PopulateDatas(InventoryItems, "inventory", player)
	end)
end