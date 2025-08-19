--Exercise #01: Create a query with the following columns:

--FirstName and LastName, from the Person.Person table**
--JobTitle, from the HumanResources.Employee table**
--Rate, from the HumanResources.EmployeePayHistory table**
--A derived column called "AverageRate" that returns the average of all values in the "Rate" column, in each row
select 
	P.FirstName, P.LastName,
	E.JobTitle,
	H.Rate,
	AverageRate = avg(H.Rate) over()
from [AdventureWorks2019].[Person].[Person] as P
join [AdventureWorks2019].[HumanResources].[Employee] as E on P.BusinessEntityID = E.BusinessEntityID
join [AdventureWorks2019].[HumanResources].[EmployeePayHistory] H on H.BusinessEntityID = E.BusinessEntityID

--Exercise #02: Enhance your query from Exercise 1 by adding a derived column called
--"MaximumRate" that returns the largest of all values in the "Rate" column, in each row. 
select 
	P.FirstName, P.LastName,
	E.JobTitle,
	H.Rate,
	AverageRate = avg(H.Rate) over(),
	MaximumRate = max(H.Rate) over()
from [AdventureWorks2019].[Person].[Person] as P
join [AdventureWorks2019].[HumanResources].[Employee] as E on P.BusinessEntityID = E.BusinessEntityID
join [AdventureWorks2019].[HumanResources].[EmployeePayHistory] H on H.BusinessEntityID = E.BusinessEntityID

--Exercise #03: Enhance your query from Exercise 2 by adding a derived column called
--"DiffFromAvgRate" that returns the result of the following calculation:
--An employees's pay rate, MINUS the average of all values in the "Rate" column.
select 
	P.FirstName, P.LastName,
	E.JobTitle,
	H.Rate,
	AverageRate = avg(H.Rate) over(),
	MaximumRate = max(H.Rate) over(),
	DiffFromAvgRate = H.Rate - avg(H.Rate) over()
from [AdventureWorks2019].[Person].[Person] as P
join [AdventureWorks2019].[HumanResources].[Employee] as E on P.BusinessEntityID = E.BusinessEntityID
join [AdventureWorks2019].[HumanResources].[EmployeePayHistory] H on H.BusinessEntityID = E.BusinessEntityID

--Exercise #04: Enhance your query from Exercise 3 by adding a derived column called
--"PercentofMaxRate" that returns the result of the following calculation:
--An employees's pay rate, DIVIDED BY the maximum of all values in the "Rate" column, times 100.
select 
	P.FirstName, P.LastName,
	E.JobTitle,
	H.Rate,
	AverageRate = avg(H.Rate) over(),
	MaximumRate = max(H.Rate) over(),
	DiffFromAvgRate = H.Rate - avg(H.Rate) over(),
	PercentofMaxRate = H.Rate * 100 / max(H.Rate) over()
from [AdventureWorks2019].[Person].[Person] as P
join [AdventureWorks2019].[HumanResources].[Employee] as E on P.BusinessEntityID = E.BusinessEntityID
join [AdventureWorks2019].[HumanResources].[EmployeePayHistory] H on H.BusinessEntityID = E.BusinessEntityID

--Reference tables:
select *
from [AdventureWorks2019].[Person].[Person]

select *
from [AdventureWorks2019].[HumanResources].[Employee]

select *
from [AdventureWorks2019].[HumanResources].[EmployeePayHistory]