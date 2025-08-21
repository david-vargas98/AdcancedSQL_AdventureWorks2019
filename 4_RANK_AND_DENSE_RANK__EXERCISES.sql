--Exercise #1: Using your solution query to Exercise 4 from the ROW_NUMBER exercises as a staring point, add a derived column called 
--“Category Price Rank With Rank” that uses the RANK function to rank all products by ListPrice – within each category - in descending
--order. Observe the differences between the “Category Price Rank” and “Category Price Rank With Rank” fields.
select 
	p.Name as ProductName,
	p.ListPrice,
	psc.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	[Price Rank] = row_number() over(order by p.ListPrice desc),
	[Category Price Rank] = row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc),
	[Top 5 Price In Category] = 
		case
			when row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc) <= 5 then 'Yes'
			else 'No'
		end,
	[Category Price Rank With Rank] = rank() over(partition by pc.ProductCategoryID order by p.ListPrice desc)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID;

--Exercise #2: Modify your query from Exercise 1 by adding a derived column called "Category Price Rank With Dense Rank" that that uses 
--the DENSE_RANK function to rank all products by ListPrice – within each category - in descending order. Observe the differences among 
--the “Category Price Rank”, “Category Price Rank With Rank”, and “Category Price Rank With Dense Rank” fields.
select 
	p.Name as ProductName,
	p.ListPrice,
	psc.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	[Price Rank] = row_number() over(order by p.ListPrice desc),
	[Category Price Rank] = row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc),
	[Top 5 Price In Category] = 
		case
			when row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc) <= 5 then 'Yes'
			else 'No'
		end,
	[Category Price Rank With Rank] = rank() over(partition by pc.ProductCategoryID order by p.ListPrice desc),
	[Category Price Rank With Dense Rank] = dense_rank() over(partition by pc.ProductCategoryID order by p.ListPrice desc)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID;


--Exercise #3: Examine the code you wrote to define the “Top 5 Price In Category” field back in the ROW_NUMBER exercises. Now that you 
--understand the differences among ROW_NUMBER, RANK, and DENSE_RANK, consider which of these functions would be most appropriate to return
--a true top 5 products by price, assuming we want to see the top 5 distinct prices AND we want “ties” (by price) to all share the same 
--rank.
select 
	p.Name as ProductName,
	p.ListPrice,
	psc.Name as ProductSubcategory,
	pc.Name as ProductCategory,
	[Price Rank] = row_number() over(order by p.ListPrice desc),
	[Category Price Rank] = row_number() over(partition by pc.ProductCategoryID order by p.ListPrice desc),
	[Top 5 Price In Category] = 
		case
			when dense_rank() over(partition by pc.ProductCategoryID order by p.ListPrice desc) <= 5 then 'Yes'
			else 'No'
		end,
	[Category Price Rank With Rank] = rank() over(partition by pc.ProductCategoryID order by p.ListPrice desc),
	[Category Price Rank With Dense Rank] = dense_rank() over(partition by pc.ProductCategoryID order by p.ListPrice desc)
from AdventureWorks2019.Production.Product p
join AdventureWorks2019.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID;