-- Cleaning Data in SQL Queries

Select *
From PortfolioProject.dbo.NashvilleHolding

-- Standardize Date Format

Select SaleDate, CONVERT(date,SaleDate) 
From PortfolioProject.dbo.NashvilleHolding


Alter TABLE PortfolioProject.dbo.NashvilleHolding
Add SaleDateConverted date;


Update PortfolioProject.dbo.NashvilleHolding
SET SaleDateConverted = CONVERT(date,SaleDate)

Select SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHolding


--Populate Property Address data

Select *
FROM PortfolioProject.dbo.NashvilleHolding
Where PropertyAddress is null 

 Select *
FROM PortfolioProject.dbo.NashvilleHolding
order by ParcelID 


 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHolding a
JOIN PortfolioProject.dbo.NashvilleHolding b
on a.ParcelID = b.ParcelID
and a.UniqueID != b.UniqueID
 Where a.PropertyAddress is null 

 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM PortfolioProject.dbo.NashvilleHolding a
JOIN PortfolioProject.dbo.NashvilleHolding b
on a.ParcelID = b.ParcelID
and a.UniqueID != b.UniqueID
 Where a.PropertyAddress is null 

 --Breaking Out Address into Individual columns (Address,city,state)

  Select PropertyAddress
FROM PortfolioProject.dbo.NashvilleHolding

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHolding

Alter TABLE PortfolioProject.dbo.NashvilleHolding
Add PropertySplitAddress nvarchar(255);


Update PortfolioProject.dbo.NashvilleHolding
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter TABLE PortfolioProject.dbo.NashvilleHolding
Add PropertySplitCity nvarchar(255);


Update PortfolioProject.dbo.NashvilleHolding
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select *
FROM PortfolioProject.dbo.NashvilleHolding


Select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHolding

SELECT 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHolding

Alter TABLE PortfolioProject.dbo.NashvilleHolding
Add OwnerSplitAddress nvarchar(255);


Update PortfolioProject.dbo.NashvilleHolding
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter TABLE PortfolioProject.dbo.NashvilleHolding
Add OwnerSplitCity nvarchar(255);


Update PortfolioProject.dbo.NashvilleHolding
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter TABLE PortfolioProject.dbo.NashvilleHolding
Add OwnerSplitState nvarchar(255);


Update PortfolioProject.dbo.NashvilleHolding
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
FROM PortfolioProject.dbo.NashvilleHolding


--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHolding
GROUP BY SoldAsVacant
order by 2

Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject.dbo.NashvilleHolding

Update PortfolioProject.dbo.NashvilleHolding
SET SoldAsVacant=
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END


--Remove Duplicates

WITH RowNumCTE As(
Select *, 
ROW_NUMBER()OVER(
PARTITION BY ParcelID,PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num
FROM PortfolioProject.dbo.NashvilleHolding
)

DELETE
FROM RowNumCTE
WHERE row_num > 1

-- Delete Unused Columns

Select *
FROM PortfolioProject.dbo.NashvilleHolding

ALTER TABLE  PortfolioProject.dbo.NashvilleHolding
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE  PortfolioProject.dbo.NashvilleHolding
DROP COLUMN SaleDate