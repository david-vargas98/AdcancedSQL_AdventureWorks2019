--Exercises #01: Create a query with the following columns:
--“Name” from the Production.Product table, which can be alised as “ProductName”
--“ListPrice” from the Production.Product table
--“Name” from the Production. ProductSubcategory table, which can be alised as “ProductSubcategory”*
--“Name” from the Production.ProductCategory table, which can be alised as “ProductCategory”**

--**Join Production.ProductSubcategory to Production.Product on “ProductSubcategoryID
--**Join Production.ProductCategory to ProductSubcategory on “ProductCategoryID”

-- All the tables can be inner joined, and you do not need to apply any criteria.
select 
	p.Name as ProductName,
	p.ListPrice,
	ps.Name as ProductSubcategory,
	pc.Name as ProductCategory
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory ps on ps.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = ps.ProductCategoryID

--Exercise #02: Enhance your query from Exercise 1 by adding a derived column called
--"AvgPriceByCategory " that returns the average ListPrice for the product category in each given row.
select 
	p.Name as ProductName,
	p.ListPrice,
	ps.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	AvgPriceByCategory = avg(p.ListPrice) over(partition by pc.ProductCategoryID)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory ps on ps.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = ps.ProductCategoryID

--Exercise #03: Enhance your query from Exercise 2 by adding a derived column called
--"AvgPriceByCategoryAndSubcategory" that returns the average ListPrice for the product category AND subcategory in each given row.
select 
	p.Name as ProductName,
	p.ListPrice,
	ps.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	AvgPriceByCategory = avg(p.ListPrice) over(partition by pc.ProductCategoryID),
	AvgPriceByCategoryAndSubcategory = avg(p.ListPrice) over (partition by pc.ProductCategoryID, ps.ProductSubcategoryID)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory ps on ps.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = ps.ProductCategoryID

--Exercise #04: Enhance your query from Exercise 3 by adding a derived column called
--"ProductVsCategoryDelta" that returns the result of the following calculation:
--A product's list price, MINUS the average ListPrice for that product’s category.
select 
	p.Name as ProductName,
	p.ListPrice,
	ps.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	AvgPriceByCategory = avg(p.ListPrice) over(partition by pc.ProductCategoryID),
	AvgPriceByCategoryAndSubcategory = avg(p.ListPrice) over (partition by pc.ProductCategoryID, ps.ProductSubcategoryID),
	ProductVsCategoryDelta = p.ListPrice - avg(p.ListPrice) over(partition by pc.ProductCategoryID)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory ps on ps.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = ps.ProductCategoryID