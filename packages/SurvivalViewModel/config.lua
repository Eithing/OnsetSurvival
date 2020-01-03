-- Server Config --
s_SaveAll = 2 -- Sauvegarde de toutes les entités (en minutes)

-- Player Config --
p_defaulthealth = 100 -- Vie par défaut
p_defaultargent = 0 -- Argent par défaut lors de la premier connexion
p_defaulthunger = 100 -- Faim par défaut lors de la premier connexion
p_defaultthirst = 100 -- Soif par défaut lors de la premier connexion
p_defaultclothing = 7 -- Vétement par défaut lors de la premier connexion
p_spawn = {x=125773.000000, y=80246.000000, z=1755.000000} -- Position du spawn
p_delayvitalnotif = 30 -- Envoie une notif pour la faim et la soif (en secondes)

-- INVENTORY CONFIG --
i_maxWeight = 10000

-- VEHICLE CONFIG --
v_health = 1500 -- Vie max d'un véhicule
v_delayconsume = 1000 -- delai de la cosomation d'essence
v_consomevalue = 1 -- Nombre d'essence retirer a chaque verification
v_defaultFuel = 100 -- Essence par défaut d'un véhicule

-- GARAGE CONFIG --
g_Points = {}
table.insert(g_Points, {id = 1, nom = "Spawn", x = 126176, y = 80357, radius = 150})

-- Fonction Global --

function math.clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max    
	end
	
	return num
end

function GetNearestGarageDealer(x, y, z)
	for k,v in pairs(g_Points) do
        local x2, y2, z2 = v.x, v.y, z
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if dist < 150.0 then
            return v
		end
	end

	return 0
end

function math.Seconds(num) -- Secondes en Ms
	return num * 1000
end

function math.Minutes(num) -- Minutes en MS
	return num * 60000
end

function math.Hours(num) -- Heures en Ms
	return num * 3,6e+6
end
