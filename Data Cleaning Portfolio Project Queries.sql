/*
Cleaning Data in SQL Queries
*/

-- Standardize Date Format

SELECT CONVERT(SaleDate, Date)
FROM nash_housing;

SET SQL_SAFE_UPDATES = 0;
UPDATE nash_housing 
SET SaleDate = CONVERT(SaleDate, Date);

-- If it doesn't Update properly

ALTER TABLE nash_housing 
ADD SaleDateConverted DATE; 
UPDATE  nash_housing 
SET SaleDateConverted = CONVERT(SaleDate, Date);

-- Populate Property Address data

SELECT * FROM nash_housing 
WHERE PropertyAddress IS NULL
ORDER BY uniqueid;

SELECT a.ParcelID, b.ParcelID, a. PropertyAddress,  b. PropertyAddress, IFNULL(a.PropertyAddress,b.PropertyAddress)
FROM nash_housing a
JOIN nash_housing b
ON a.ParcelID=b.ParcelID
AND a.UniqueID  <> b.UniqueID 
WHERE a.PropertyAddress IS NULL ;

UPDATE nash_housing a JOIN
       nash_housing b
       ON a.ParcelID = b.ParcelID AND
          a.UniqueID <> b.UniqueID
    SET a.PropertyAddress = b.PropertyAddress
    WHERE a.PropertyAddress IS NULL;

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT OwnerAddress
From nash_housing;

ALTER TABLE nash_housing 
ADD Address VARCHAR(255);
UPDATE nash_housing
SET Address= SUBSTRING_INDEX(OwnerAddress, ',', 1) ;

ALTER TABLE nash_housing
ADD City VARCHAR(255);
UPDATE nash_housing
SET City= SUBSTRING_INDEX(OwnerAddress, ',', 2) ;


ALTER TABLE nash_housing
ADD State VARCHAR(255);
UPDATE nash_housing
SET state= SUBSTRING_INDEX(OwnerAddress,',',-1);


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (SoldAsVacant) FROM nash_housing;

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'No' THEN 'N'
WHEN SoldAsVacant = 'Yes' THEN 'Y'
END 
from nash_housing;

UPDATE nash_housing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'N' THEN 'No'
WHEN SoldAsVacant = 'Y' THEN 'Yes'
ELSE SoldAsVacant
END ;


-- Remove Duplicates
-- Delete Unused Columns

ALTER TABLE nash_housing
DROP  OwnerAddress,
DROP TaxDistrict,
DROP PropertyAddress,
DROP SaleDate







