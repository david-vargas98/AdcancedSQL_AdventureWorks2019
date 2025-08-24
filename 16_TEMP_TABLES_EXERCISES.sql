--Exercise:
--Refactor your solution to the exercise from the section on CTEs (average sales/purchases minus top 10) using temp tables 
--in place of CTEs.
IF OBJECT_ID('tempdb..#Sales') IS NOT NULL DROP TABLE #Sales;
SELECT 
	OrderDate,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
	TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
into #Sales
FROM AdventureWorks2019.Sales.SalesOrderHeader;

SELECT 
	OrderDate,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
	TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
into #Purchases
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader;

Select 
	OrderMonth,
	TotalSales = sum(TotalDue)
into #SalesNoTop10
from #Sales
where OrderRank > 10 
group by OrderMonth;

select
	OrderMonth,
	TotalPurchases = sum(TotalDue)
into #PurchasesNoTop10
from #Purchases
where OrderRank > 10
group by OrderMonth;

select 
	OrderMonth = s.OrderMonth, -- it could be s.OrderMonth or p.OrderMonth, it doesn't matter
	TotalSales,
	TotalPurchases
from #SalesNoTop10 s
	join #PurchasesNoTop10 p
		on s.OrderMonth = p.OrderMonth
order by OrderMonth;

--drop table #Sales;
drop table #Purchases;
drop table #SalesNoTop10;
drop table #PurchasesNoTop10;

-- Instead of using drop at the end we can use i.e.: IF OBJECT_ID('tempdb..#Sales') IS NOT NULL DROP TABLE #Sales; at the very beggining

-- Original Query using CTEs:
With Sales as (
	SELECT 
		OrderDate,
		OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
		TotalDue,
		OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM AdventureWorks2019.Sales.SalesOrderHeader
),
Purchases as(
	SELECT 
		OrderDate,
		OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
		TotalDue,
		OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
),
SalesNoTop10 as(
	Select 
		OrderMonth,
		TotalSales = sum(TotalDue)
	from Sales
	where OrderRank > 10 
	group by OrderMonth
),
PurchasesNoTop10 as(
	select
		OrderMonth,
		TotalPurchases = sum(TotalDue)
	from Purchases
	where OrderRank > 10
	group by OrderMonth
)
select 
	OrderMonth = s.OrderMonth, -- it could be s.OrderMonth or p.OrderMonth, it doesn't matter
	TotalSales,
	TotalPurchases
from SalesNoTop10 s
	join PurchasesNoTop10 p
		on s.OrderMonth = p.OrderMonth
order by OrderMonth