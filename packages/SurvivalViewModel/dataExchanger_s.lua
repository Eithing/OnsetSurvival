SLogic = ImportPackage("SurvivalLogic")

UserData = {}
ItemData = {}
RecoltData = {}

AddEvent("OnPackageStart", function()
    UserData = SLogic.GetAllUsers()
    ItemData = SLogic.GetAllItems()
    RecoltData = SLogic.GetAllRecolts()
end)

AddEvent("OnPlayerSteamAuth", function(player)
    UserData[tostring(GetPlayerSteamId(player))].inventoryItems = SLogic.GetUserInventory(player, UserData[tostring(GetPlayerSteamId(player))].id)
end)

CreateTimer(function(GlobalSave)
	--TODO World Save
end, '1800000' , GlobalSave) -- Execution de la save toute les 30 mins