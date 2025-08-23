--Exercise #01
--Using PIVOT, write a query against the HumanResources.Employee table that summarizes the average amount of vacation time 
--for Sales Representatives, Buyers, and Janitors.
select
	*
from
	(
	select
		JobTitle,
		VacationHours
	from AdventureWorks2019.HumanResources.Employee 
	) as src
pivot(
	avg(VacationHours)
	for JobTitle in ([Sales Representative], [Buyer], [Janitor])
) as pvt

--Exercise #02
--Modify your query from Exercise 1 such that the results are broken out by Gender. Alias the Gender field as "Employee Gender" 
--in your output.
select
	[Sales Representative],
	Buyer,
	Janitor,
	Gender as [Employee Gender]
from
	(
	select
		JobTitle,
		VacationHours,
		Gender
	from AdventureWorks2019.HumanResources.Employee 
	) as src
pivot(
	avg(VacationHours)
	for JobTitle in ([Sales Representative], [Buyer], [Janitor])
) as pvt