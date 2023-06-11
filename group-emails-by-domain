select substring(email, charindex('@', email)+1, len(email)-charindex('@', email)), count(1) 
from dbo.customer
where email is not null
group by substring(email, charindex('@', email)+1, len(email)-charindex('@', email))
order by count(1) desc
