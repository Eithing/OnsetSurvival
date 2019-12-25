UserData = {}
ItemData = {}

AddEvent("OnPackageStart", function()
	local SQL_HOST = "localhost"
	local SQL_PORT = 3306
	local SQL_USER = "root"
	local SQL_PASS = ""
	local SQL_DATA = "eynwa"
	local SQL_CHAR = "utf8mb4"
	local SQL_LOGL = "debug"

	mariadb_log(SQL_LOGL)

	sql = mariadb_connect(SQL_HOST .. ':' .. SQL_PORT, SQL_USER, SQL_PASS, SQL_DATA)
	if (sql ~= false) then
		print("MariaDB: Connected to " .. SQL_HOST)
		mariadb_set_charset(sql, SQL_CHAR)
	else
		print("MariaDB: Connection failed to " .. SQL_HOST .. ", see mariadb_log file")
		ServerExit()
	end

	GetAllPlayer()
	GetAllItems()
end)

function GetAllPlayer()
	local playerRequest = mariadb_prepare(sql, "SELECT * FROM comptes")
	mariadb_query(sql, playerRequest, function()
		local rows = mariadb_get_row_count()
		for i=1, rows do
			local id = mariadb_get_value_name(i, "")
			UserData[i] = {	id = mariadb_get_value_name(i, "id"),
						   	nom = mariadb_get_value_name(i, "nom"),
							prenom = mariadb_get_value_name(i, "prenom"),
							admin = mariadb_get_value_name(i, "admin"),
							steamId = mariadb_get_value_name(i, "SteamId"),
							positionX = mariadb_get_value_name(i, "positionX"),
							positionY = mariadb_get_value_name(i, "positionY"),
							positionZ = mariadb_get_value_name(i, "positionZ"),
							eat = mariadb_get_value_name(i, "eat"),
							drink = mariadb_get_value_name(i, "drink"),
							health = mariadb_get_value_name(i, "health")}
		end
	end)
end

function GetAllItems()
	local itemRequest = mariadb_prepare(sql, "SELECT * FROM items")
	mariadb_query(sql, itemRequest, function()
		local rows = mariadb_get_row_count()
		for i=1, rows do
			local id = mariadb_get_value_name(i, "")
			ItemData[i] = {	id = mariadb_get_value_name(i, "id"),
						   	nom = mariadb_get_value_name(i, "nom"),
							poids = mariadb_get_value_name(i, "poids"),
							type = mariadb_get_value_name(i, "type"),
							imageId = mariadb_get_value_name(i, "imageId")}
		end
	end)
end