select t.name table_name
  ,c.name catalog_name
  ,i.name index_name
  ,cl.name column_name
from sys.tables t 
inner join sys.fulltext_indexes fi on t.[object_id] = fi.[object_id] 
inner join sys.fulltext_index_columns ic on ic.[object_id] = t.[object_id]
inner join sys.columns cl on ic.[column_id] = cl.[column_id] and ic.[object_id] = cl.[object_id]
inner join sys.fulltext_catalogs c on fi.[fulltext_catalog_id] = c.[fulltext_catalog_id]
inner join sys.indexes i on fi.[unique_index_id] = i.[index_id] and fi.[object_id] = i.[object_id]
