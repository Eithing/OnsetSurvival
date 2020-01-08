function DisplayCreateCharacter()
    SView.SetCharacterVisibility()
end
AddRemoteEvent("DisplayCreateCharacter",  DisplayCreateCharacter)

local LastSoundPlayed = 0

function PlayAudioFile(file, x, y, z, radius, volume)
	DestroySound(LastSoundPlayed)

	LastSoundPlayed = CreateSound3D("Ressources/sounds/"..file, x, y, z, radius)
    SetSoundVolume(LastSoundPlayed, volume)
    
    Delay(math.Seconds(2), function()
        DestroySound(LastSoundPlayed)
    end)
end
AddRemoteEvent("PlayAudioFile", PlayAudioFile)

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
function AddNotification(msg, type, delay)
    local id = Random(1,99999)
    if msg == nil or msg == "" then
        return
    end
    if type == nil or type == "" then
        type = "default"
    end
    if delay == nil or delay == 0 then
        delay = p_delayNotif
    end
    delay = math.Seconds(delay)
    SView.ExecuteJs("vitalIndicator", 'AddNotification("'..id..'","'..msg..'","'..type..'","'..delay..'")')
    return id
end
AddRemoteEvent("ClientAddNotification",  AddNotification)

-- All Notif
local notifid = {}

local function InitNotif(index, zone, msg, callremote, incar)
    notifid[index] = {}
    notifid[index].id = 0 -- id du champs
    notifid[index].notif = false -- pour savoir si la notif a deja été envoyer
    notifid[index].zone = zone -- la zone (Table avec tous les points)
    notifid[index].msg = msg -- Message
    notifid[index].CallRemonte = callremote -- Script Server
    notifid[index].incar = incar -- true est dans la voiture
end

InitNotif("garage", g_Points, "Appuyer sur E pour ouvrir le garage", "OnOpenGarage", false)
InitNotif("garagestore", gstore_Points, "Appuyer sur E pour stocker votre véhicule", "StoreVehicleToGarage", true)
InitNotif("recolte", r_Points, "Appuyer sur E pour recolter", "Harvesting", false)

function OnKeyPress(key)
    if key == "E" then
        local x, y, z = GetPlayerLocation()
        for k, v in pairs(notifid) do
            if v.CallRemonte == "" then
                break
            end
            if PlayerIsInVehicle() == v.incar then
                local zone, dist = GetNearestZone(v.zone, x, y, z)
                if zone ~= 0 then
                    CallRemoteEvent(v.CallRemonte)
                    break
                end
            end
        end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

local lastZone = nil
local lastZoneDist = nil
CreateTimer(function()
    local x, y, z = GetPlayerLocation()
    for k, v in pairs(notifid) do
        local found, dist = GetNearestZone(v.zone, x, y, z)
        if found ~= 0 then
            if v.notif == false then
                if PlayerIsInVehicle() == v.incar then
                    v.id = AddNotification(v.msg, "default", 999)
                    v.notif = true
                    lastZone = k
                    lastZoneDist = found
                end
            end
        end
    end

    if lastZone ~= nil then
        local x2, y2, z2 = lastZoneDist.x, lastZoneDist.y, lastZoneDist.z
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if (tonumber(dist) > tonumber(lastZoneDist.radius) and notifid[lastZone].notif == true) or PlayerIsInVehicle() ~= notifid[lastZone].incar then
            SView.ExecuteJs("vitalIndicator", 'RemoveNotification("'..notifid[lastZone].id..'")')
            notifid[lastZone].id = 0
            notifid[lastZone].notif = false
            lastZone = nil
            lastZoneDist = nil
        end
    end
end, 500)

function PlayerIsInVehicle()
    return IsPlayerInVehicle() or false
end


-- DEV NE PAS LAISSER EN PRODUCTION --
function OnScriptError(message)
    AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..message..'</>')
end
AddEvent("OnScriptError", OnScriptError)