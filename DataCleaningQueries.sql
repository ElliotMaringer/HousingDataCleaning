/*
Cleaning Data in SQL queries
*/
--------------------------------------------------------------------

--Standardize Date Format

select *
from PortfolioProject..NashHousing

--Update NashHousing
--Set SaleDate = CONVERT(Date,SaleDate)

ALTER Table NashHousing
ADD SaleDateConverted Date;

Update NashHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

------------------------------------------------------------------------

-- Populate Property Address data

select *
from PortfolioProject..NashHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashHousing a
JOIN PortfolioProject..NashHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashHousing a
JOIN PortfolioProject..NashHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Addres, City, State

select *
from PortfolioProject..NashHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address2
from PortfolioProject..NashHousing

ALTER Table NashHousing
ADD PropertySplitAddress varchar(255);

Update NashHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER Table NashHousing
ADD PropertySplitCity varchar(255);

Update NashHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *
from PortfolioProject..NashHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject..NashHousing

ALTER Table NashHousing
ADD OwnerSplitAddress varchar(255);

Update NashHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER Table NashHousing
ADD OwnerSplitCity varchar(255);

Update NashHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER Table NashHousing
ADD OwnerSplitState varchar(255);

Update NashHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashHousing
Group by SoldAsVacant

Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END
From PortfolioProject..NashHousing

Update NashHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END

----------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID, 
	PropertyAddress, 
	SalePrice, 
	SaleDate, 
	LegalReference
	ORDER BY UniqueID) row_num
From PortfolioProject..NashHousing
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

-------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject..NashHousing

Alter Table PortfolioProject..NashHousing
Drop Column OwnerAddress, PropertyAddress

Alter Table PortfolioProject..NashHousing
Drop Column SaleDate




