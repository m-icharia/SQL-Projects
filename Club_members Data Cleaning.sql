/*
Data Cleaning Practice
*/

--previewing the data
select *
from [Project Portfolio].dbo.club_member_info$


--remove all whitespaces from full_name
select full_name, trim(full_name) as NameNoWhiteSpace
from [Project Portfolio].dbo.club_member_info$

update [Project Portfolio].dbo.club_member_info$
set full_name = trim(full_name) 

--remove unwanted characters in full_name
select full_name, replace(full_name, '???', '') as OnlyName
from [Project Portfolio].dbo.club_member_info$

update [Project Portfolio].dbo.club_member_info$
set full_name = replace(full_name, '???', '')

--remove any rows with ages < 100 
select *
from [Project Portfolio].dbo.club_member_info$
where age > 100

delete from [Project Portfolio].dbo.club_member_info$
where age > 100

--keep the capitalized standard for all names in full_name
select full_name,
concat(upper(left(full_name, 1)),
lower(right(full_name, len(full_name) - 1)))
from [Project Portfolio].dbo.club_member_info$

update [Project Portfolio].dbo.club_member_info$
set full_name = concat(upper(left(full_name, 1)),
lower(right(full_name, len(full_name) - 1)))
--break up the full address to address, city, state
select
parsename(replace(full_address, ',', '.'), 3),
parsename(replace(full_address, ',', '.'), 2),
parsename(replace(full_address, ',', '.'), 1)
from [Project Portfolio].dbo.club_member_info$

alter table [Project Portfolio].dbo.club_member_info$
add Address nvarchar(255)

update [Project Portfolio].dbo.club_member_info$
set Address = parsename(replace(full_address, ',', '.'), 3)

alter table [Project Portfolio].dbo.club_member_info$
add City nvarchar(255)

update [Project Portfolio].dbo.club_member_info$
set City = parsename(replace(full_address, ',', '.'), 2)

alter table [Project Portfolio].dbo.club_member_info$
add State nvarchar(255)

update [Project Portfolio].dbo.club_member_info$
set State = parsename(replace(full_address, ',', '.'), 1)

--remove full_address column
alter table [Project Portfolio].dbo.club_member_info$
drop column full_address
--create new columns for the individual locations of the addresses
alter table [Project Portfolio].dbo.club_member_info$

--replace all null/missing values with N/A
select age, isnull(cast(age as varchar), 'N/A'), isnull(martial_status, 'N/A'), isnull(email, 'N/A'), isnull(phone, 'N/A'), isnull(job_title, 'N/A')
from [Project Portfolio].dbo.club_member_info$

--convert age to varchar first
alter table [Project Portfolio].dbo.club_member_info$
alter column age nvarchar(255)
update [Project Portfolio].dbo.club_member_info$
set age = isnull(age, 'N/A')

update [Project Portfolio].dbo.club_member_info$
set martial_status = isnull(martial_status, 'N/A')

update [Project Portfolio].dbo.club_member_info$
set email = isnull(email, 'N/A')

update [Project Portfolio].dbo.club_member_info$
set phone = isnull(phone, 'N/A')

update [Project Portfolio].dbo.club_member_info$
set job_title = isnull(job_title, 'N/A')


