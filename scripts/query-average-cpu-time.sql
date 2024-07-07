
declare @MinimumNumberOfExecutions int = 10
 
select db.name as database_name
	,eqs.total_worker_time as total_worker_time 
	,eqs.total_logical_reads + EQS.total_logical_writes as total_logical_io
	,eqs.execution_count
	,eqs.last_execution_time as last_run 
	,eqs.total_worker_time / EQS.execution_count as average_cpu_time_milliseconds
	,(eqs.total_logical_reads + EQS.total_logical_writes) / eqs.execution_count as avgerage_logica_io
	,substring(est.text, 1 + eqs.statement_start_offset / 2, (
		case when eqs.statement_end_offset = -1 then len(convert(nvarchar(max), est.text)) * 2  
		else EQS.statement_end_offset end - eqs.statement_start_offset) / 2) as sql_statement 
from sys.dm_exec_query_stats as eqs
cross apply sys.dm_exec_sql_text(eqs.sql_handle) as est 
cross apply sys.dm_exec_query_plan(eqs.plan_handle) as eqp 
left join sys.databases as db on est.dbid = db.database_id      
where eqs.execution_count > @MinimumNumberOfExecutions
and eqs.last_execution_time > datediff(month, -1, getdate()) 
order by average_cpu_time_milliseconds desc