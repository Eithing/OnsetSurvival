SLogic = ImportPackage("SurvivalLogic")

-- Enregistrement des variables global serveur
PlayerData = {}
VehicleData = {}
ZombiesData = {}
ItemDB = {}
ItemPickups = {}
DeadPlayerBags = {}

AddEvent("OnPackageStart", function()
    VehicleDB = SLogic.GetAllVehicles()
    ItemDB = SLogic.GetAllItems()
end)
