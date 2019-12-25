local Dialog = ImportPackage("dialogui")



function DisplayCreateCharacter(player)
    local test = Dialog.create("Nouveau personage", "Choisisez les options ", "Créer", "Annuler")
    Dialog.addTextInput(test, 1, "Nom:")
    Dialog.addTextInput(test, 1, "Prénom:")
    Dialog.addSelect(test, 1, "Genre:", 1, "Homme", "Femme")

    Dialog.show(test)

    AddEvent("OnDialogSubmit", function(dialog, button, firstName, lastName, gender)
    if dialog ~= test then
        return
    end
    if button == 1 then
        CallRemoteEvent("InsertPlayer", firstName, lastName)
        AddPlayerChat("Gender = "..gender)
    else
        --todo on cancel
    end
    end)
end
AddRemoteEvent("DisplayCreateCharacter",  DisplayCreateCharacter)