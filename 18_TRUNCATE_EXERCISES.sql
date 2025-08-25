--Exercise:
--Leverage TRUNCATE to re-use temp tables in your solution to "CREATE and INSERT" exercise.
--Hints:
--1.)
--Instead of joining two tables in your final SELECT (#AvgSalesMinusTop10 and #AvgPurchasesMinusTop10), you will most 
--likely need to join a single consolidated query to itself.

--The join will work much like before, but you will need to add a new wrinkle that filters each copy of the table based 
--on whether it contains purchase or sales data.

--For whatever copy of the table you put after the FROM, include the filtering criteria in the WHERE clause.

--For the other copy of the table, apply the filtering criteria directly in the join.

--These different "cuts" of the same table will accomplish the same thing as two distinct tables did previously.

--2.)
--In the SELECT clause of your final query, you will probably need to apply aliases to a couple of field names

--to distinguish total sales from total purchases. Make sure you apply the appropriate alias to the field

--from the appropriate copy of the table.
if object_id('tempdb..#Orders') is not null drop table #Orders;
create table #Orders(
	OrderDate Date,
	OrderMonth Date,
	TotalDue Money,
	OrderRank int
);

insert into #Orders(
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

if object_id('tempdb..#OrdersNoTop10') is not null drop table #OrdersNoTop10;
create table #OrdersNoTop10(
	OrderMonth Date,
	TypeOrder varchar(40),
	NoTop10Total Money
);

insert into #OrdersNoTop10(
	OrderMonth,
	TypeOrder,
	NoTop10Total
)
Select 
	OrderMonth,
	'Sales',
	sum(TotalDue)
from #Orders
where OrderRank > 10 
group by OrderMonth;

truncate table #Orders

insert into #Orders(
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

insert into #OrdersNoTop10(
	OrderMonth,
	TypeOrder,
	NoTop10Total
)
select
	OrderMonth,
	'Purchases',
	sum(TotalDue)
from #Orders
where OrderRank > 10
group by OrderMonth;

select 
	o.OrderMonth,
	SalesNoTop10Total = o.NoTop10Total,
	PurchasesNoTop10Total = o2.NoTop10Total
from #OrdersNoTop10 o
	join #OrdersNoTop10 o2
		on o.OrderMonth = o2.OrderMonth
where o.TypeOrder = 'Sales' AND o2.TypeOrder = 'Purchases'
order by o.OrderMonth

drop table #Orders;
drop table #OrdersNoTop10;

-- old query:

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
