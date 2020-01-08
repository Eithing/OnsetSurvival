SLogic = ImportPackage("SurvivalLogic")

-- Enregistrement des variables global serveur
PlayerData = {}
VehicleData = {}
ItemDB = {}
ItemPickups = {}
DeadPlayerBags = {}

AddEvent("OnPackageStart", function()
    ItemDB = SLogic.GetAllItems()
end)
