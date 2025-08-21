--Exercise #01: Create a query with the following columns (feel free to borrow your code from Exercise 1 of the PARTITION BY exercises):
--“Name” from the Production.Product table, which can be alised as “ProductName”
--“ListPrice” from the Production.Product table
--“Name” from the Production.ProductSubcategory table, which can be alised as “ProductSubcategory”*
--“Name” from the Production.ProductCategory table, which can be alised as “ProductCategory”**

--*Join Production.ProductSubcategory to Production.Product on “ProductSubcategoryID”
--**Join Production.ProductCategory to ProductSubcategory on “ProductCategoryID”

--All the tables can be inner joined, and you do not need to apply any criteria.
select 
	p.Name as ProductName,
	p.ListPrice,
	psc.Name as ProductSubcategory,
	pc.Name as ProductCategory
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID

--Exercise #02
--Enhance your query from Exercise 1 by adding a derived column called
--"Price Rank " that ranks all records in the dataset by ListPrice, in descending order. That is to say, the product 
--with the most expensive price should have a rank of 1, and the product with the least expensive price should have a
--rank equal to the number of records in the dataset.
select 
	p.Name as ProductName,
	p.ListPrice,
	psc.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	[Price Rank] = row_number() over(order by p.ListPrice desc)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID

--Exercise #03
--Enhance your query from Exercise 2 by adding a derived column called
--"Category Price Rank" that ranks all products by ListPrice – within each category - in descending order. In other words,
--every product within a given category should be ranked relative to other products in the same category.
select 
	p.Name as ProductName,
	p.ListPrice,
	psc.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	[Price Rank] = row_number() over(order by p.ListPrice desc),
	[Category Price Rank] = row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID

--Exercise #04
--Enhance your query from Exercise 3 by adding a derived column called
--"Top 5 Price In Category" that returns the string “Yes” if a product has one of the top 5 list prices in its product 
--category, and “No” if it does not. You can try incorporating your logic from Exercise 3 into a CASE statement to make 
--this work.
select 
	p.Name as ProductName,
	p.ListPrice,
	psc.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	[Price Rank] = row_number() over(order by p.ListPrice desc),
	[Category Price Rank] = row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc),
	[Top 5 Price In Category] = 
		case
			when row_number() over(partition by pc.ProductCategoryID order by p.ListPrice) <= 5 then 'Yes'
			else 'No'
		end
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID;

--Another solution using CTE
with RankedProducts as(
	select 
		p.Name as ProductName,
		p.ListPrice,
		psc.Name as ProductSubcategory,
		pc.Name as ProductCategory,
		[Price Rank] = row_number() over(order by p.ListPrice desc),
		[Category Price Rank] = row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc),
		[Top 5 Price In Category] = row_number() over(partition by pc.ProductCategoryID order by p.ListPrice)
	from AdventureWorks2019.Production.Product p
	join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
	join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID
)
select
	ProductName,
	ListPrice,
	ProductSubcategory,
	ProductCategory,
	[Price Rank],
	[Category Price Rank],
	[Top 5 Price In Category] =
		case
			when [Top 5 Price In Category] <= 5 then 'Yes'
			else 'No'
		end
FROM RankedProducts;

--Table reference
select *
from AdventureWorks2019.Production.Product
select *
from AdventureWorks2019.Production.ProductSubcategory 
select *
from AdventureWorks2019.Production.ProductCategory