
-- return the number of rows in all user tables
select t.name as table_name, s.row_count 
from sys.tables t
inner join sys.dm_db_partition_stats s on t.object_id = s.object_id 
and t.name not like '%dss%'
and t.type_desc = 'USER_TABLE'
and s.index_id IN (0,1)
order by t.name