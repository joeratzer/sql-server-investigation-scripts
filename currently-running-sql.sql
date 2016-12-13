
select db_name(r.database_id) as database_name
	,r.start_time 
	,r.total_elapsed_time	
	,r.command
	,sql_text.[text] as sql_command
	,r.session_id
	,r.[status]
	,r.cpu_time
from sys.dm_exec_requests r
cross apply sys.dm_exec_sql_text(sql_handle) as sql_text

--- if query stuck or running too long
--- kill [session_id]