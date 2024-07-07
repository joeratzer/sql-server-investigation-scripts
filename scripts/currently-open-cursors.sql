
--- ideally, cursors should be removed and replaced with a set-based solution 
select crs.name as cursor_name 
	,crs.creation_time
	,crs.is_open 
	,crs.reads 
	,crs.writes
	,crs.dormant_duration 
	,ses.cpu_time 
	,ses.memory_usage 
	,ses.login_name
	,substring(st.text ,(crs.statement_start_offset / 2) + 1, ((
			case CRS.statement_end_offset 
				when -1 then datalength(st.text) 
				else crs.statement_end_offset 
			end - crs.statement_start_offset) / 2) + 1) as cursor_sql 
from sys.dm_exec_cursors(0) as crs
inner join sys.dm_exec_sessions as ses on crs.session_id = ses.session_id 
cross apply sys.dm_exec_sql_text(crs.sql_handle) as st