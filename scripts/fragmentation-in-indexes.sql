
--- investigate large tables where fragmentation is greater than 30% - https://msdn.microsoft.com/en-us/library/ms189858.aspx
declare @fragPercentTheshold int = 30

select object_name(indexes.object_id) as table_name
	,indexes.name as index_name
	,index_stats.index_type_desc as index_type
	,index_stats.avg_fragmentation_in_percent as average_fragmentation
from sys.dm_db_index_physical_stats(db_id(), null, null, null, null) index_stats 
inner join sys.indexes on indexes.object_id = index_stats.object_id and indexes.index_id = index_stats.index_id 
where index_stats.avg_fragmentation_in_percent >= @fragPercentTheshold
order by index_stats.avg_fragmentation_in_percent desc

--- background
--- Fragmentation affects disk I/O. Therefore, focus on the larger indexes because their pages are less 
--- likely to be cached by SQL Server. Generally, you should not be concerned with fragmentation levels 
--- of indexes with less than 1,000 pages. In the tests, indexes containing more than 10,000 pages realized 
--- performance gains, with the biggest gains on indexes with significantly more pages 
--- (greater than 50,000 pages) - https://www.microsoft.com/en-us/download/details.aspx?id=51958

--- Use the above results with the following:

select object_name(partition_stats.object_id) table_name
	,sum(partition_stats.used_page_count) used_pages
	,sum(partition_stats.reserved_page_count) reserved_pages
from sys.dm_db_partition_stats partition_stats
inner join sys.tables t on partition_stats.object_id = t.object_id
group by partition_stats.object_id
having sum(partition_stats.used_page_count) > 999
order by used_pages desc