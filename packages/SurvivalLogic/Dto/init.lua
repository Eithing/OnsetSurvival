Sql = nil

AddEvent("OnPackageStart", function()
	local SQL_HOST = "91.121.178.28"
	local SQL_PORT = 3306
	local SQL_USER = "kinj14"
	local SQL_PASS = "kinj14"
	local SQL_DATA = "eynwa"
	local SQL_CHAR = "utf8mb4"
	local SQL_LOGL = "debug"

	mariadb_log(SQL_LOGL)

	Sql = mariadb_connect(SQL_HOST .. ':' .. SQL_PORT, SQL_USER, SQL_PASS, SQL_DATA)
	if (Sql ~= false) then
		print("MariaDB: Connected to " .. SQL_HOST)
		mariadb_set_charset(Sql, SQL_CHAR)
	else
		print("MariaDB: Connection failed to " .. SQL_HOST .. ", see mariadb_log file")
		ServerExit()
	end
end)

AddEvent("OnPackageStop", function()
	mariadb_close(Sql)
end)