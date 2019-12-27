SLogic = ImportPackage("SurvivalLogic")

UserData = {}
ItemData = {}

function PopulateDatas(datas, base, player) --Remplissage du cache au lancement
    if base == "comptes"then
        UserData = datas
    elseif base == "items"then
        ItemData = datas
    elseif base == "inventory"then
        UserData[player].inventoryItems = datas
    end
end
AddFunctionExport("PopulateDatas", PopulateDatas)

CreateTimer(function(GlobalSave)
	--TODO World Save
end, '1800000' , GlobalSave) -- Execution de la save toute les 30 mins