function DisplayCreateCharacter()
    SView.SetCharacterVisibility()
end
AddRemoteEvent("DisplayCreateCharacter",  DisplayCreateCharacter)

AddEvent("OnPlayerStreamIn", function( player, otherplayer )
    CallRemoteEvent("ServerChangeOtherPlayerClothes", player, otherplayer)
end)

AddRemoteEvent("ClientChangeClothing", function(player, part, piece, r, g, b, a)
    local SkeletalMeshComponent
    local pieceName
    if part == 0 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing0")
        pieceName = piece
    end
    if part == 1 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
        pieceName = piece
    end
    if part == 4 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
        pieceName = piece
    end
    if part == 5 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing5")
        pieceName = piece
    end
    SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
    local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
    if part == 0 then
        DynamicMaterialInstance:SetColorParameter("Hair Color", FLinearColor(r, g, b, a))
    end
end)

-- Notification --
function AddNotification(msg, type)
    if msg == "" then
        return
    end
    if type == "" then
        type = "default"
    end
    SView.ExecuteJs("vitalIndicator", 'AddNotification("'..msg..'","'..type..'")')
end
AddRemoteEvent("ClientAddNotification",  AddNotification)


local notif = false
CreateTimer(function()
    local x, y, z = GetPlayerLocation()
    local NearestGarageDealer = GetNearestGarageDealer(x, y, z)
    if NearestGarageDealer ~= 0 then 
        if notif == false then
            AddPlayerChat("OnGameTick")
            AddNotification("Appuyer sur E pour ouvrir le garage", "default")
            notif = true
            Delay(math.Seconds(20), function()
                notif = false
            end)
        end
    end
end, math.Seconds(10))