--- shrink log file

--- change recovery model to allow shrinkage
alter database [DbName]
set recovery simple;
go

--- shrink the log file to 1 MB
dbcc shrinkfile (DbName_Log, 1);
go

alter database [DbName]
set recovery full;
go
