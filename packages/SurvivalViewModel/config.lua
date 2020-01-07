-- Server Config --
s_SaveAll = 2 -- Sauvegarde de toutes les entités (en minutes)

-- Player Config --
p_defaulthealth = 100 -- Vie par défaut
p_defaultargent = 0 -- Argent par défaut lors de la premier connexion
p_defaulthunger = 100 -- Faim par défaut lors de la premier connexion
p_defaultthirst = 100 -- Soif par défaut lors de la premier connexion
p_defaultclothing = 7 -- Vétement par défaut lors de la premier connexion
p_spawn = {x=125773.000000, y=80246.000000, z=1567.000000} -- Position du spawn
p_delayNotif = 20 -- Delay de base pour une notif (en secondes)
p_delayvitalnotif = 30 -- Envoie une notif pour la faim et la soif (en secondes)
p_maxMoney = 999999999 -- Argent max

-- INVENTORY CONFIG --
i_maxWeight = 80 -- Valeur par défault
i_maxStack = 99 -- Stack max d'un item

-- VEHICLE CONFIG --
v_health = 1500 -- Vie max d'un véhicule
v_delayconsume = 1000 -- delai de la cosomation d'essence
v_consomevalue = 1 -- Nombre d'essence retirer a chaque verification
v_defaultFuel = 100 -- Essence par défaut d'un véhicule
v_radios = {
    { label = "Metal", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://5.135.154.69:11590/listen.pls?sid=1&t=.pls" },
    { label = "Reggae", url = "http://hd.lagrosseradio.info/lagrosseradio-reggae-192.mp3" },
    { label = "Dance", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://pulseedm.cdnstream1.com:8124/1373_128.m3u&t=.pls" },
    { label = "Rap", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://192.211.51.158:8010/listen.pls?sid=1&t=.pls" },
    { label = "NRJ", url = "http://185.52.127.168/fr/30001/mp3_128.mp3?origine=playernrj" },
    { label = "Skyrock", url = "http://www.skyrock.fm/stream.php/yourplayer_128mp3.pls" }
}

-- GARAGE CONFIG --
g_Points = {}
table.insert(g_Points, {id = 1, nom = "Spawn", x = 127564, y = 75447, z = 1566, radius = 150.0,
	spawnPoints = {
		[1] = {x = 128002, y = 75453, z = 1566, rotationz = 90},
		[2] = {x = 126399, y = 74585, z = 1566, rotationz = 90},
		[3] = {x = 125523, y = 75202, z = 1566, rotationz = 90}
	}
})
table.insert(g_Points, {id = 2, nom = "Spawn", x = 126031, y = 80424, z = 1566, radius = 150.0,
	spawnPoints = {
		[1] = {x = 124694, y = 80626, z = 1581, rotationz = 90}
	}
})

--Store Vehicle
gstore_Points = {}
table.insert(gstore_Points, {id = 1, x = 128817, y = 76898,  z = 1566, radius = 200.0})
table.insert(gstore_Points, {id = 2, x = 128115, y = 77886,  z = 1568, radius = 200.0})

-- RECOLTE CONFIG --
r_Points = {}
table.insert(r_Points, {id = 1, nom = "Mine dawp", itemId = 26, count = 1, x = 132512, y = 77888,  z = 1568, radius = 150.0})

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
        local x2, y2, z2 = v.x, v.y, v.z
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
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