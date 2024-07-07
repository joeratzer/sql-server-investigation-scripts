
--- figures and sql based on MS recommendations - https://msdn.microsoft.com/en-us/library/ms189858.aspx
declare @IndexAnalysis table
(
	AnalysisID int identity(1, 1) not null primary key,
	TableName nvarchar(500),
	SQLText nvarchar(max),
	IndexDepth int,
	AvgFragmentationInPercent float,
	FragmentCount bigint,
	AvgFragmentSizeInPages float,
	PageCount bigint
)

insert into @IndexAnalysis
select [objects].name
	,'alter index [' + [indexes].name + '] on [' + [schemas].name + '].[' + [objects].name + '] ' + 
	(case when ([dm_db_index_physical_stats].avg_fragmentation_in_percent >= 10 and [dm_db_index_physical_stats].avg_fragmentation_in_percent < 30) then 'reorganize'
	when [dm_db_index_physical_stats].avg_fragmentation_in_percent > = 30 then 'rebuild'
    end) as zSQL
	,[dm_db_index_physical_stats].index_depth
	,[dm_db_index_physical_stats].avg_fragmentation_in_percent
	,[dm_db_index_physical_stats].fragment_count
	,[dm_db_index_physical_stats].avg_fragment_size_in_pages
	,[dm_db_index_physical_stats].page_count
from [sys].[dm_db_index_physical_stats](db_id(), null, null, null, 'LIMITED') as [dm_db_index_physical_stats]
inner join [sys].[objects] as [objects] on ([dm_db_index_physical_stats].[object_id] = [objects].[object_id])
inner join [sys].[schemas] as [schemas] on 
	([objects].[schema_id] = [schemas].[schema_id]) inner join [sys].[indexes] as [indexes] on ([dm_db_index_physical_stats].[object_id] = [indexes].[object_id]
	and [dm_db_index_physical_stats].index_id = [indexes].index_id)
where index_type_desc <> 'HEAP'
and [dm_db_index_physical_stats].avg_fragmentation_in_percent > 10

declare @TableName nvarchar(500)
declare @SQLIndex nvarchar(max)
declare @RowCount int
declare @Counter int

select @RowCount = count(AnalysisID)
from @IndexAnalysis

set @Counter = 1
while @Counter <= @RowCount 
begin
	select @SQLIndex = SQLText
	from @IndexAnalysis
	where AnalysisID = @Counter
	execute sp_executesql @SQLIndex
	set @Counter = @Counter + 1
end