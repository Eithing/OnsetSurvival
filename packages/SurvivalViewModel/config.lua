-- Player Config --
p_defaulthealth = 100 -- Vie par défaut
p_defaultargent = 0 -- Argent par défaut lors de la premier connexion
p_defaulthunger = 100 -- Faim par défaut lors de la premier connexion
p_defaultthirst = 100 -- Soif par défaut lors de la premier connexion
p_defaultclothing = 7 -- Vétement par défaut lors de la premier connexion
p_spawn = {x=125773.000000, y=80246.000000, z=1755.000000+200} -- Position du spawn
p_bagDisappearTime = 60000 -- Temps de depop des sacs quand un joueur meurt

-- INVENTORY CONFIG --
i_maxWeight = 10000

-- VEHICLE CONFIG --
v_delayconsume = 1000 -- delai de la cosomation d'essence
v_consomevalue = 1 -- Nombre d'essence retirer a chaque verification
v_defaultFuel = 100 -- Essence par défaut d'un véhicule

-- Fonction Global --

function math.clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max    
	end
	
	return num
end