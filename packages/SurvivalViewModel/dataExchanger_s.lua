SLogic = ImportPackage("SurvivalLogic")

-- Enregistrement des variables global serveur
PlayerData = {}
VehicleData = {}
ItemDB = {}
ItemPickups = {}
DeadPlayerBags = {}

AddEvent("OnPackageStart", function()
    VehicleDB = SLogic.GetAllVehicles()
    ItemDB = SLogic.GetAllItems()
end)
