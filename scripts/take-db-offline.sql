
--- set db offline
alter database [DATABASE_NAME] set offline with rollback immediate --- if any incomplete transactions rollback immediately

--- or
alter database [DATABASE_NAME] set offline with no_wait --- cannot complete immediately without waiting for transactions to commit or roll back on their own

--- set db online
alter database [DATABASE_NAME] set online 
