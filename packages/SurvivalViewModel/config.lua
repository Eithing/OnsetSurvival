-- Server Config --
s_SaveAll = 2 -- Sauvegarde de toutes les entités (en minutes)

-- Player Config --
p_defaulthealth = 100 -- Vie par défaut
p_defaultargent = 0 -- Argent par défaut lors de la premier connexion
p_defaulthunger = 100 -- Faim par défaut lors de la premier connexion
p_defaultthirst = 100 -- Soif par défaut lors de la premier connexion
p_defaultclothing = 7 -- Vétement par défaut lors de la premier connexion
p_spawn = {x=125773.000000, y=80246.000000, z=1567.000000} -- Position du spawn
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
table.insert(g_Points, {id = 1, nom = "Spawn", x = 126034, y = 80416, radius = 150.0})

-- RECOLTE CONFIG --
r_Points = {}
table.insert(r_Points, {id = 1, nom = "Mine dawp", itemId = 26, count = 1, x = 132512, y = 77888, radius = 150.0})

-- Fonction Global --

function math.clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max    
	end
	
	return num
end

function GetNearestZone(zone, x, y, z)
	local found = 0
	for k, v in pairs(zone) do
        local x2, y2 = v.x, v.y
		local dist = GetDistance3D(x, y, z, x2, y2, z)
		if dist < tonumber(v.radius) then
			found = v
			break
		end
	end

	return found
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
