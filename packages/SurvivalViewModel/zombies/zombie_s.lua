local ZombiesZone = {}
local ZombieDamage = 20

AddEvent("OnPackageStart", function()
    print("Zombies ServerSide Loaded.")
    ZombiesZone['stationservice'] = {x=125773.000000, y=80246.000000, z=1567.000000, zombiemax = 1}
    CreateZombie()
end)

function CreateZombie()
    for k, v in pairs(ZombiesZone) do
        for i=1, v.zombiemax do
            local x, y = GetSpawnAleatoire(v.x, v.y, 500)
            local zombie = CreateNPC(x, y, v.z, 90)
            SetNPCAnimation(zombie, "WAVE", true)
            -- SetNPCRespawnTime(zombie, 10000)
            ZombiesData[zombie] = {}
            ZombiesData[zombie].zombie = zombie
            ZombiesData[zombie].eat = false
            ZombiesData[zombie].target = nil
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

CreateTimer(function()
    for k, zombie in pairs(ZombiesData) do
        local npc = zombie.zombie
        if IsValidNPC(npc) and ZombiesData[npc] ~= nil then
            local x, y, z = GetNPCLocation(npc)

            -- Punch Player
            local player, dist = GetNearestPlayer(x, y, z, 100)
            if player ~= 0 and not IsPlayerDead(player) then
                SetPlayerHealth(player, GetPlayerHealth(player) - ZombieDamage)
                SetNPCAnimation(npc, "SLAP01", false)
            end

            -- Find Player
            local player, dist = GetNearestPlayer(x, y, z, 400)
            if (player ~= 0 and not IsPlayerDead(player) and ZombiesData[npc].target == nil) then
                ZombiesData[npc].target = player
                print("Target Locked")
            else
                if ZombiesData[npc].target ~= nil then
                    local x2, y2, z2 = GetPlayerLocation(ZombiesData[npc].target)
                    local targetdist = GetDistance3D(x, y, z, x2, y2, z2)
                    if (targetdist > 400) or IsPlayerDead(ZombiesData[npc].target) then
                        ZombiesData[npc].target = nil
                        print("Target UnLocked")
                    end
                end
            end

            -- Follow Player
            if ZombiesData[npc].target ~= nil then
                local x2, y2, z2 = GetPlayerLocation(ZombiesData[npc].target)
                SetNPCTargetLocation(npc, x2, y2, z2, 200)
                print("Follow Target")
            end

        end
    end
end, 400)


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

function EatPlayer(zombie, player)
    if player ~= 0 and ZombiesData[zombie] ~= nil and ZombiesData[zombie].eat ~= true then
        ZombiesData[zombie].eat = true
        SetNPCAnimation(zombie, "PICKUP_LOWER", false)
        Delay(math.Seconds(1), function()
            ZombiesData[zombie].eat = false
        end)
    end
end

function GetSpawnAleatoire(x, y, radius)
    local sradius = math.random(20, radius)
    local ditX = math.random(-1000, 1000) / 1000
    local ditY = math.random(-1000, 1000) / 1000

    local positionX = x + (ditX * sradius)
    local positionY = y + (ditY * sradius)
    return positionX, positionY
end