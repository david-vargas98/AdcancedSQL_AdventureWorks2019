--Exercise #01
--Create a query with the following columns:
--“OrderMonth”, a derived column (you’ll have to create this one yourself) featuring the month number corresponding with the Order Date 
--in a given row.
--“OrderYear”, a derived column featuring the year corresponding with the Order Date in a given row.
--“SubTotal” from the Purchasing.PurchaseOrderHeader table.

--Your query should be an aggregate query – specifically, it should sum “SubTotal”, and group by the remaining fields.
select
	OrderMonth = Month(OrderDate),
	OrderYear = Year(OrderDate),
	SubTotal = sum(SubTotal)
from AdventureWorks2019.Purchasing.PurchaseOrderHeader
group by Year(OrderDate), Month(OrderDate)
order by OrderYear, OrderMonth;

--Exercise #02
--Modify your query from Exercise 1 by adding a derived column called "Rolling3MonthTotal", that displays  - for a given row - a running
--total of “SubTotal” for the prior three months (including the current row).

--HINT: You will need to include multiple fields in your ORDER BY to get this to work!
select
	OrderMonth,
	OrderYear,
	SubTotal,
	Rolling3MonthTotal = sum(SubTotal) over(order by OrderYear, OrderMonth rows between 2 preceding and current row)
from (
select
	OrderMonth = Month(OrderDate),
	OrderYear = Year(OrderDate),
	SubTotal = sum(SubTotal)
from AdventureWorks2019.Purchasing.PurchaseOrderHeader
group by Year(OrderDate), Month(OrderDate)
) as Aggregated

--Exercise #03
--Modify your query from Exercise 3 by adding another derived column called "MovingAvg6Month", that calculates a rolling average of 
--“SubTotal” for the previous 6 months, relative to the month in the “current” row. Note that this average should NOT include the 
--current row.
select
	OrderMonth,
	OrderYear,
	SubTotal,
	Rolling3MonthTotal = sum(SubTotal) over(order by OrderYear, OrderMonth rows between 2 preceding and current row),
	MovingAvg6Month = avg(SubTotal) over(order by OrderYear, OrderMonth rows between 6 preceding and 1 preceding)
from (
select
	OrderMonth = Month(OrderDate),
	OrderYear = Year(OrderDate),
	SubTotal = sum(SubTotal)
from AdventureWorks2019.Purchasing.PurchaseOrderHeader
group by Year(OrderDate), Month(OrderDate)
) as Aggregated

--Exercise #04
--Modify your query from Exercise 3 by adding (yet) another derived column called “MovingAvgNext2Months” , that calculates a rolling 
--average of “SubTotal” for the month in the current row and the next two months after that. This moving average will provide a kind of 
--"forecast" for Subtotal by month.
select
	OrderMonth,
	OrderYear,
	SubTotal,
	Rolling3MonthTotal = sum(SubTotal) over(order by OrderYear, OrderMonth rows between 2 preceding and current row),
	MovingAvg6Month = avg(SubTotal) over(order by OrderYear, OrderMonth rows between 6 preceding and 1 preceding),
	MovingAvgNext2Months = avg(SubTotal) over(order by OrderYear, OrderMonth rows between current row and 2 following)
from (
select
	OrderMonth = Month(OrderDate),
	OrderYear = Year(OrderDate),
	SubTotal = sum(SubTotal)
from AdventureWorks2019.Purchasing.PurchaseOrderHeader
group by Year(OrderDate), Month(OrderDate)
) as Aggregated