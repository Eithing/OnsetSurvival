SLogic = ImportPackage("SurvivalLogic")

PlayerData = {}
VehicleData = {}

AddEvent("OnPackageStart", function()
end)

CreateTimer(function(GlobalSave)
	--TODO World Save
end, '1800000' , GlobalSave) -- Execution de la save toute les 30 mins