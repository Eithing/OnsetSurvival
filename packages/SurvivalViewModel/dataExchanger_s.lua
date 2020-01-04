SLogic = ImportPackage("SurvivalLogic")

PlayerData = {}
VehicleData = {}
ItemData = {}
ItemPickups = {}

AddEvent("OnPackageStart", function()
	ItemData = SLogic.GetAllItems()
end)

CreateTimer(function(GlobalSave)
	--TODO World Save
end, '1800000' , GlobalSave) -- Execution de la save toute les 30 mins