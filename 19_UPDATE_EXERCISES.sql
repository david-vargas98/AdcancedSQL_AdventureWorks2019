--Exercise:
--Using the code in the "Update - Exercise Starter Code.sql" file in the resources for this section (which is the same 
--as the example presented in the video), update the values in the "OrderSubcategory" field as follows:

--The values in the field should consist of the following string values concatenated together in this order:

--The value in the "OrderCategory" field
--A space
--A hyphen
--Another space
--The value in the "OrderAmtBucket" field
CREATE TABLE #SalesOrders
(
 SalesOrderID INT,
 OrderDate DATE,
 TaxAmt MONEY,
 Freight MONEY,
 TotalDue MONEY,
 TaxFreightPercent FLOAT,
 TaxFreightBucket VARCHAR(32),
 OrderAmtBucket VARCHAR(32),
 OrderCategory VARCHAR(32),
 OrderSubcategory VARCHAR(32)
)

INSERT INTO #SalesOrders
(
 SalesOrderID,
 OrderDate,
 TaxAmt,
 Freight,
 TotalDue,
 OrderCategory
)

SELECT
 SalesOrderID,
 OrderDate,
 TaxAmt,
 Freight,
 TotalDue,
 OrderCategory = 'Non-holiday Order'

FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

WHERE YEAR(OrderDate) = 2013


UPDATE #SalesOrders
SET 
TaxFreightPercent = (TaxAmt + Freight)/TotalDue,
OrderAmtBucket = 
	CASE
		WHEN TotalDue < 100 THEN 'Small'
		WHEN TotalDue < 1000 THEN 'Medium'
		ELSE 'Large'
	END


UPDATE #SalesOrders
SET TaxFreightBucket = 
	CASE
		WHEN TaxFreightPercent < 0.1 THEN 'Small'
		WHEN TaxFreightPercent < 0.2 THEN 'Medium'
		ELSE 'Large'
	END


UPDATE #SalesOrders
SET  OrderCategory = 'Holiday'
FROM #SalesOrders
WHERE DATEPART(quarter,OrderDate) = 4

--- My code:
update #SalesOrders
set OrderSubCategory = isnull(OrderCategory, 'No order Category') + ' - ' + isnull(OrderAmtBucket, 'No Order Amt Bucket')

select * from #SalesOrders

drop table #SalesOrders
-- To avoid the concatenation operator to fail we could add isnull to set a value by defaualt if a field is not set