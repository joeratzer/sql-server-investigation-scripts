
declare @endDate datetime = getdate(), @months smallint = 9 --- last 9 months 

;with history as 
   (select b.database_name 
          ,year(b.backup_start_date) * 100 + month(b.backup_start_date) as year_month 
          ,convert(numeric(10, 1), min(BF.file_size / 1048576.0)) as minimum_size_mb 
          ,convert(numeric(10, 1), max(BF.file_size / 1048576.0)) as maximum_size_mb 
          ,convert(numeric(10, 1), avg(BF.file_size / 1048576.0)) as average_size_mb 
    from msdb.dbo.backupset b 
	inner join msdb.dbo.backupfile as BF on b.backup_set_id = BF.backup_set_id 
    where not b.database_name IN ('master', 'msdb', 'model', 'tempdb') --- we do not need these databases
	and BF.file_type = 'D' 
	and b.backup_start_date between dateadd(mm, - @months, @endDate) AND @endDate 
    group by b.database_name, year(b.backup_start_date), month(b.backup_start_date)) 
select results.database_name 
	,results.year_month 
	,results.minimum_size_mb 
	,results.maximum_size_mb 
	,results.average_size_mb 
	,results.average_size_mb  
		- (select top 1 sub.average_size_mb 
		from history AS sub 
		where sub.database_name = results.database_name 
		and sub.year_month < results.year_month
		order by sub.year_month desc) as growth_mb 
from history as results 
order by results.database_name, results.year_month