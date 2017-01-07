select key_column.table_name 
	,key_column.column_name
	,usage.table_name as referencing_table_name
	,usage.column_name as referencing_column_name
	,constraints.constraint_name as foreign_key_name
from information_schema.referential_constraints constraints
inner join information_schema.constraint_column_usage as usage on usage.constraint_name = constraints.constraint_name 
inner join information_schema.key_column_usage as key_column on key_column.constraint_name = constraints.unique_constraint_name
--where key_column.table_name = '[TABLE_NAME]'
