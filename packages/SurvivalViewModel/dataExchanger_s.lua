SLogic = ImportPackage("SurvivalLogic")

UserData = {}
ItemData = {}
RecoltData = {}

AddEvent("OnPackageStart", function()
    ItemData = SLogic.GetAllItems()
    RecoltData = SLogic.GetAllRecolts()
end)

CreateTimer(function(GlobalSave)
	--TODO World Save
end, '1800000' , GlobalSave) -- Execution de la save toute les 30 mins