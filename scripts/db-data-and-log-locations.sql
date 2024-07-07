
--- ideally, log and data files should be on different drives
declare @databaseName varchar(200) = null --- null = all

select mf.name
	,serverproperty('machinename') as server_name
	,serverproperty('instancename') as instance_name
	,mf.physical_name
	,mf.database_id
from master.sys.master_files mf
where @databaseName is null or mf.database_id = (select database_id from master.sys.master_files where name = @databaseName)
order by mf.database_id
