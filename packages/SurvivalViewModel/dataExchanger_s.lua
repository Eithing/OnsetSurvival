SLogic = ImportPackage("SurvivalLogic")

UserData = {} -- données du joueur
ItemData = {} -- liste des items
RecoltData = {} -- liste des point de récoltes
VehicleData = {}
ItemPickups = {}
DeadPlayerBags = {} -- liste des inventaires de joueurs mort (sacs au sol)

AddEvent("OnPackageStart", function()
    ItemData = SLogic.GetAllItems()
    RecoltData = SLogic.GetAllRecolts()
end)

CreateTimer(function(GlobalSave)
	--TODO World Save
end, '1800000' , GlobalSave) -- Execution de la save toute les 30 mins