 /*
 Data cleaning project
 */


 select *
 from [Project Portfolio].dbo.NashvilleHousingData$



--standardizing the date format
select SaleDate, convert(date, SaleDate)
from [Project Portfolio].dbo.NashvilleHousingData$

update [Project Portfolio].dbo.NashvilleHousingData$
set SaleDate = convert(date, SaleDate)

alter table [Project Portfolio].dbo.NashvilleHousingData$
add SaleDateConverted Date

update [Project Portfolio].dbo.NashvilleHousingData$
set SaleDateConverted = convert(date, SaleDate)

--remove saledate column
alter table [Project Portfolio].dbo.NashvilleHousingData$
drop column SaleDate


--populate property address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from [Project Portfolio].dbo.NashvilleHousingData$ as a
join [Project Portfolio].dbo.NashvilleHousingData$ as b
	on a.ParcelID = b.ParcelID
	and a.UniqueID != b.UniqueID
where a.PropertyAddress is null

--removing null values from the table
update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [Project Portfolio].dbo.NashvilleHousingData$ as a
join [Project Portfolio].dbo.NashvilleHousingData$ as b
	on a.ParcelID = b.ParcelID
	and a.UniqueID != b.UniqueID


--breaking the address into individual columns using substrings
select PropertyAddress
from [Project Portfolio].dbo.NashvilleHousingData$

--the -1 removes the comma
select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress) - 1) as Address,
substring(PropertyAddress, 1, charindex(',', PropertyAddress) + 1, len(PropertyAddress)) as Address
from [Project Portfolio].dbo.NashvilleHousingData$

---seperates the address into own column
alter table [Project Portfolio].dbo.NashvilleHousingData$
add Address Nvarchar(255)

update [Project Portfolio].dbo.NashvilleHousingData$
set Address = substring(PropertyAddress, 1, charindex(',', PropertyAddress) - 1)

---seperates the city into own column
alter table [Project Portfolio].dbo.NashvilleHousingData$
add City nvarchar(255)

update [Project Portfolio].dbo.NashvilleHousingData$
set City = substring(PropertyAddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress))



--using parsename * note it starts counting from the end
select 
parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
from [Project Portfolio].dbo.NashvilleHousingData$


alter table [Project Portfolio].dbo.NashvilleHousingData$
add PropertyState nvarchar(255)

update [Project Portfolio].dbo.NashvilleHousingData$
set PropertyState = parsename(replace(OwnerAddress, ',', '.'), 1)

select *
from [Project Portfolio].dbo.NashvilleHousingData$

--Change the 'Y' and 'N' to Yes and No in sold as vacant field
select distinct (SoldAsVacant), count(SoldAsVacant)
from [Project Portfolio].dbo.NashvilleHousingData$
group by SoldAsVacant
order by 2


select
	case 
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end
from [Project Portfolio].dbo.NashvilleHousingData$

update [Project Portfolio].dbo.NashvilleHousingData$
set SoldAsVacant = 
	case 
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end


--deleting unused columns
select *
from [Project Portfolio].dbo.NashvilleHousingData$

alter table [Project Portfolio].dbo.NashvilleHousingData$
drop column OwnerAddress, PropertyAddress, TaxDistrict

