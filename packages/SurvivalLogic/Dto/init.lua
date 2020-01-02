sql = false

local SQL_HOST = "91.121.178.28"
local SQL_PORT = 3306
local SQL_USER = "Eynwa"
local SQL_PASS = "eynwa5"
local SQL_DATA = "eynwa"
local SQL_CHAR = "utf8mb4"
local SQL_LOGL = "debug"

-- Setup a MariaDB connection when the package/server starts
local function OnPackageStart()
	mariadb_log(SQL_LOGL)

	sql = mariadb_connect(SQL_HOST .. ':' .. SQL_PORT, SQL_USER, SQL_PASS, SQL_DATA)

	if (sql ~= false) then
		print("MariaDB: Connected to " .. SQL_HOST)
		mariadb_set_charset(sql, SQL_CHAR)
	else
		print("MariaDB: Connection failed to " .. SQL_HOST .. ", see mariadb_log file")

		-- Immediately stop the server if we cannot connect
		ServerExit()
	end

	CallEvent("database:connected")
end
AddEvent("OnPackageStart", OnPackageStart)

-- Cleanup the MariaDB connection when the package/server stops
local function OnPackageStop()
	mariadb_close(sql)
end
AddEvent("OnPackageStop", OnPackageStop)