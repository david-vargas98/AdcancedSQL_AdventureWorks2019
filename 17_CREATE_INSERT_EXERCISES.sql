--Exercise:
--Rewrite your solution from last video's exercise using CREATE and INSERT instead of SELECT INTO.
if object_id('tempdb..#Sales') is not null drop table #Sales;
create table #Sales(
	OrderDate Date,
	OrderMonth Date,
	TotalDue Money,
	OrderRank int
);

insert into #Sales(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank
)
SELECT 
	OrderDate,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
	TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader;


if object_id('tempdb..#Purchases') is not null drop table #Purchases;
create table #Purchases(
	OrderDate Date,
	OrderMonth Date,
	TotalDue Money,
	OrderRank int
);

insert into #Purchases(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank
)
SELECT 
	OrderDate,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
	TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader;


if object_id('tempdb..#SalesNoTop10') is not null drop table #SalesNoTop10;
create table #SalesNoTop10(
	OrderMonth Date,
	TotalSales Money
);

insert into #SalesNoTop10(
	OrderMonth,
	TotalSales
)
Select 
	OrderMonth,
	TotalSales = sum(TotalDue)
from #Sales
where OrderRank > 10 
group by OrderMonth;


if object_id('tempdb..#PurchasesNoTop10') is not null drop table #PurchasesNoTop10;
create table #PurchasesNoTop10(
	OrderMonth Date,
	TotalPurchases Money
);

insert into #PurchasesNoTop10(
	OrderMonth,
	TotalPurchases
)
select
	OrderMonth,
	TotalPurchases = sum(TotalDue)
from #Purchases
where OrderRank > 10
group by OrderMonth;


select 
	OrderMonth = s.OrderMonth,
	TotalSales,
	TotalPurchases
from #SalesNoTop10 s
	join #PurchasesNoTop10 p
		on s.OrderMonth = p.OrderMonth
order by OrderMonth;

drop table #Sales;
drop table #Purchases;
drop table #SalesNoTop10;
drop table #PurchasesNoTop10;



-- last video's exercise:
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