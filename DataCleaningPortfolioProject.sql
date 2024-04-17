---cleaning data in sql 

select *
from PortfolioProject..NashvellHousing

--- standardize date format 

select saleDate , convert (Date,SaleDate)
from PortfolioProject..NashvellHousing

update NashvellHousing
set SaleDate= convert(date,SaleDate)

--another method 
select saledateconverted , SaleDate
from PortfolioProject..NashvellHousing


Alter table NashvellHousing
add saledateconverted Date ;

update NashvellHousing
set saledateconverted = convert(date,SaleDate)

-------------------------

--populate property adress data 

select *
from PortfolioProject..NashvellHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvellHousing a
join PortfolioProject..NashvellHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvellHousing a
join PortfolioProject..NashvellHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------

--- breaking out adress into individual columns (Adress , city , state )


select PropertyAddress
from PortfolioProject..NashvellHousing 

select 
SUBSTRING (PropertyAddress , 1,CHARINDEX(',' , PropertyAddress) -1 ) as Adress , 
SUBSTRING (PropertyAddress , CHARINDEX(',' , PropertyAddress)+1 , LEN(PropertyAddress)) as city
from PortfolioProject..NashvellHousing


alter table NashvellHousing
Add PropertySplitAdress Nvarchar(255);

update NashvellHousing
set PropertySplitAdress = SUBSTRING (PropertyAddress , 1,CHARINDEX(',' , PropertyAddress) -1 ) 

alter table NashvellHousing
Add PropertySplitCity Nvarchar(255);

update NashvellHousing
set PropertySplitCity = SUBSTRING (PropertyAddress , CHARINDEX(',' , PropertyAddress)+1 , LEN(PropertyAddress)) 

select *
from PortfolioProject..NashvellHousing



select OwnerAddress 
from PortfolioProject..NashvellHousing

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) adress 
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) city
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) state
from PortfolioProject..NashvellHousing

alter table  NashvellHousing
add ownersplitadress Nvarchar(255) ;

update NashvellHousing
set ownersplitadress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

alter table  NashvellHousing
add ownersplitcity Nvarchar(255) ;

update NashvellHousing
set ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table  NashvellHousing
add ownersplitstate Nvarchar(255) ;

update NashvellHousing
set ownersplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select *
from PortfolioProject..NashvellHousing

--------------------------------

--- change Y and N to yes and no in "sold as vacant " field 

select distinct(SoldAsVacant) , count(SoldAsVacant)
from PortfolioProject..NashvellHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then  'No'
	   else SoldAsVacant
	   end
from PortfolioProject..NashvellHousing

update NashvellHousing
set SoldAsVacant= case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then  'No'
	   else SoldAsVacant
	   end

------------------------------------------

---- remove duplicates 


select * 
from PortfolioProject..NashvellHousing


with rowNUmCTE as (
select * , 
row_number() over (
partition by ParcelID , PropertyAddress , SalePrice , SaleDate, LegalReference Order by UniqueID ) row_num
from PortfolioProject..NashvellHousing
--order by ParcelID
)
select * -- do delete for delliting duplicates 
from RowNumCTE
where row_num > 1 

-------------------------

----------- delete unused columns 

select * 
from PortfolioProject..NashvellHousing

Alter table NashvellHousing
drop column OwnerAddress , TaxDistrict , PropertyAddress 












