
select db_name(dbid) as database_name
	,count(dbid) as number_of_connections
	,loginame as login_name
from sys.sysprocesses
where dbid > 0 and ecid = 0
group by dbid, loginame

exec sp_who2


