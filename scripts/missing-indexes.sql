
select db_name(mid.database_id) as database_name
	,object_name(mid.[object_id]) as [object_name]
	,migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) as improvement_measure
	,'create index [missing_index_' + convert (varchar, mig.index_group_handle) + '_' + convert (varchar, mid.index_handle) 
		+ '_' + left (parsename(mid.statement, 1), 32) + ']' 
		+ ' on ' + mid.statement + ' (' + isnull (mid.equality_columns,'')
		+ case when mid.equality_columns is not null and mid.inequality_columns is not null then ',' else '' end + isnull (mid.inequality_columns, '')
		+ ')' + isnull (' include (' + mid.included_columns + ')', '') as create_index_statement
	,migs.user_scans
	,migs.last_user_scan
	,migs.user_seeks
	,migs.last_user_seek
	,migs.avg_user_impact
from sys.dm_db_missing_index_groups mig
inner join sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
inner join sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
where migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
order by migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) desc