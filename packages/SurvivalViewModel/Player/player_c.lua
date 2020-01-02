function DisplayCreateCharacter(clothing)
    CallRemoteEvent("UpdateWeight", SView.SetCharacterVisibility())
    Player_SetPlayerClothing(clothing)
end
AddRemoteEvent("DisplayCreateCharacter",  DisplayCreateCharacter)

function Player_SetPlayerClothing(clothing)
    SetPlayerClothingPreset(GetPlayerId(), clothing)
end
AddRemoteEvent("SetPlayerClothing",  Player_SetPlayerClothing)