
select sysobjects.name as trigger_name 
    ,s.name as table_schema 
    ,object_name(parent_obj) as table_name
from sysobjects 
inner join sys.tables t on sysobjects.parent_obj = t.object_id 
inner join sys.schemas s on t.schema_id = s.schema_id 
where sysobjects.type = 'TR' 