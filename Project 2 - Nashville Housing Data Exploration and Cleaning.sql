-- Cleaning Data in SQL Queries
/*
SELECT * 
FROM nashvillehousing;
*/	
-- Standardize Date Format
/*
SELECT SaleDateConverted, CONVERT(SaleDate, Date)
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(SaleDate, Date);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(SaleDate, Date);
*/

-- SELECT SaleDate
-- FROM NashvilleHousing;

-- Populate Property Address Data	
 
SELECT *
FROM nashvillehousing
-- WHERE PropertyAddress is null
order by ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.PercelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null;

UPDATE
SET PropertyAddress = ISNUSS(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAdress is null;

-- Breaking out Address into Indiviudal Columns (Address, City, State) 

SELECT PropertyAddress 
FROM nashvillehousing;
-- WHERE propertyaddress is null
-- ORDER BY ParcelID

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))as Address
FROM nashvillehousing;

ALTER TABLE nashvillehousing
ADD PropertySplitAddress VARCHAR(255);

UPDATE nashvillehousing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE nashvillehousing
ADD PropertySplitCity VARCHAR(255);

UPDATE nashvillehousing
SET PropertySplitCity = SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1);

SELECT *
FROM nashvillehousing;

SELECT owneraddress
FROM nashvillehousing;

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM nashvillehousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress VARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity VARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState VARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashvillehousing 
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT DISTINCT(SoldAsVacant)
, CASE WHEN SoldAsVacant = "Y" THEN "YES"
	   WHEN SoldAsVacant = "N" THEN "NO"
       ELSE SoldAsVacant
       END
FROM nashvillehousing;

UPDATE nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = "Y" THEN "YES"
		WHEN SoldAsVacant = "N" THEN "NO"
        ELSE SoldAsVacant
        END;

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT * , 
	row_number() OVER(
    PARTITION BY ParcelID,
				 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 ORDER BY
					UniqueID
                    ) row_num
    
FROM nashvillehousing
-- ORDER BY ParcelID
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1;
-- ORDER BY PropertyAddress

-- Delete Unused Columns

SELECT *
FROM nashvillehousing;

ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

ALTER TABLE nashvillehousing
DROP COLUMN SaleDate



