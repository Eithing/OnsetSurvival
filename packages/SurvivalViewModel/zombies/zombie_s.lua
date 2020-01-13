local ZombiesZone = {}
local ZombieDamage = 20

AddEvent("OnPackageStart", function()
    print("Zombies ServerSide Loaded.")
    ZombiesZone['stationservice'] = {x=125773.000000, y=80246.000000, z=1567.000000, zombiemax = 10}
    CreateZombie()
end)

function CreateZombie()
    for k, v in pairs(ZombiesZone) do
        for i=1, v.zombiemax do
            local x, y = GetSpawnAleatoire(v.x, v.y, 500)
            local zombie = CreateNPC(x, y, v.z, 90)
            SetNPCAnimation(zombie, "WAVE", true)
            -- SetNPCRespawnTime(zombie, 10000)
            ZombiesData[zombie] = zombie
            print("Zombie "..zombie .. " spawned !")
        end
    end
end

function DestroyZombie(zombie)
    SetNPCRagdoll(zombie, true)
    Delay(math.Seconds(5), function()
        DestroyNPC(zombie)
        ZombiesData[zombie] = nil
        print("Zombie("..zombie..") destroyed.")
    end)
end

AddEvent("OnNPCReachTarget", function(npc)
    local x, y, z = GetNPCLocation(npc)
    local player, dist = GetNearestPlayer(x, y, z, 100)
    if player ~= 0 and IsValidPlayer(player) then
        SetPlayerHealth(player, GetPlayerHealth(player) - ZombieDamage)
        SetNPCAnimation(npc, "CROSSARMS2", false)
    end
end)

AddEvent("OnPlayerWeaponShot", function(player, weapon, hitType, hitId, hitX, hitY, hitZ, startX, startY, normalX, normalY, normalZ)
    if hitType == 4 then
        if ZombiesData[hitId] ~= nil then
            addMoney(player, math.floor(z_rewards/4))
            return
        end
    end
end)

AddEvent("OnNPCDeath", function(npc, player)
    if playerId ~= 0 and ZombiesData[npc] ~= nil then
        DestroyZombie(npc)
        addMoney(player, z_rewards)
    end
end)

function GetSpawnAleatoire(x, y, radius)
    local sradius = math.random(20, radius)
    local ditX = math.random(-1000, 1000) / 1000
    local ditY = math.random(-1000, 1000) / 1000

    local positionX = x + (ditX * sradius)
    local positionY = y + (ditY * sradius)
    return positionX, positionY
end