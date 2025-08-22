--Exercise #01
--Create a query that displays all rows from the Production.ProductSubcategory table, and includes the following fields:

--The "Name" field from Production.ProductSubcategory, which should be aliased as "SubcategoryName"

--A derived field called "Products" which displays, for each Subcategory in Production.ProductSubcategory, a semicolon-separated list 
--of all products from Production.Product contained within the given subcategory

--Hint: Production.ProductSubcategory and Production.Product are related by the "ProductSubcategoryID" field.
select
	[Name] as SubcategoryName,
	Products = stuff(
		(
			select
				';' + P.Name
			from AdventureWorks2019.Production.Product P
			where P.ProductSubcategoryID = PSC.ProductSubcategoryID
			for xml path('')
		),
		1, 1, ''
	)
from AdventureWorks2019.Production.ProductSubcategory PSC

--Exercise #02
--Modify the query from Exercise 1 such that only products with a ListPrice value greater than $50 are listed in the "Products" field.

--Hint: Assuming you used a correlated subquery in Exercise 1, keep in mind that you can apply additional criteria to it, just as with 
--any other correlated subquery.

--NOTE: Your query should still include ALL product subcategories, but only list associated products greater than $50. But since there 
--are certain product subcategories that don't have any associated products greater than $50, some rows in your query output may have a
--NULL value in the product field.
select
	[Name] as SubcategoryName,
	Products = stuff(
		(
			select
				';' + P.Name
			from AdventureWorks2019.Production.Product P
			where P.ProductSubcategoryID = PSC.ProductSubcategoryID AND P.ListPrice > 50
			for xml path('')
		),
		1, 1, '' 
	)
from AdventureWorks2019.Production.ProductSubcategory PSC

-- using another trick to avoid special scaped characters i.e. & --> &amp:
select
	[Name] as SubcategoryName,
	Products = stuff(
		(
			select
				';' + P.Name
			from AdventureWorks2019.Production.Product P
			where P.ProductSubcategoryID = PSC.ProductSubcategoryID AND P.ListPrice > 50
			for xml path(''), type
		).value('.', 'nvarchar(max)'),
		1, 1, ''
	)
from AdventureWorks2019.Production.ProductSubcategory PSC

