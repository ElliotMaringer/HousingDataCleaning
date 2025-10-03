# HousingDataCleaning — Nashville Housing Data (SQL Server)

This project showcases a full SQL-based cleaning workflow for the Nashville Housing dataset. It standardizes dates, backfills and splits addresses, normalizes categorical fields, removes duplicates using window functions, and prunes unused columns—preparing the data for analysis or visualization.

## Files

- **DataCleaningQueries.sql**  
  End-to-end SQL Server script that performs:
  - Date standardization (`SaleDateConverted`)
  - Address backfilling via self-join on `ParcelID`
  - Address parsing into atomic columns (`PropertySplitAddress`, `PropertySplitCity`, `OwnerSplitAddress`, `OwnerSplitCity`, `OwnerSplitState`)
  - Normalization of `SoldAsVacant` (Y/N → Yes/No)
  - De-duplication with `ROW_NUMBER()` in a CTE
  - Column cleanup (drops original wide/legacy fields)

- **Nashville Housing Data.xlsx**  
  Source Excel file used for data cleaning and validation. Import this into SQL Server before running the script.

## Getting Started

1. **Import the data**
   - Load `Nashville Housing Data.xlsx` into SQL Server (e.g., table `PortfolioProject..NashHousing`).

2. **Run the cleaning script**
   - Open `DataCleaningQueries.sql` in SQL Server Management Studio (SSMS).
   - Execute in order. The script:
     - Adds and populates `SaleDateConverted`
     - Fills missing `PropertyAddress` using a self-join on `ParcelID`
     - Splits `PropertyAddress` and `OwnerAddress` into separate columns
     - Converts `SoldAsVacant` values to `Yes/No`
     - Removes duplicate rows via a CTE with `ROW_NUMBER()`
     - Drops original `OwnerAddress`, `PropertyAddress`, and `SaleDate` once migrated

3. **Verify results**
   - Spot-check record counts and a few rows after each major step.
   - Confirm the duplicate key definition fits your data (see Notes).


