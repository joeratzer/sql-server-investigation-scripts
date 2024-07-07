select t.name as object_name, 
    c.name as catalog_name,
    cl.name as column_name,
    i.name as unique_index_name
from sys.objects t 
inner join sys.fulltext_indexes fi on t.[object_id] = fi.[object_id] 
inner join sys.fulltext_index_columns fic on fic.[object_id] = t.[object_id]
inner join sys.columns cl on fic.column_id = cl.column_id and fic.[object_id] = cl.[object_id]
inner join sys.indexes i on fi.unique_index_id = i.index_id and fi.[object_id] = i.[object_id]
inner join sys.fulltext_catalogs c on fi.fulltext_catalog_id = c.fulltext_catalog_id
