--Exercise:
--Re-write the query in the "An Improved EXISTS With UPDATE - Exercise Starter Code.sql" file (you can find the file in
--the Resources for this section), using temp tables and UPDATE statements instead of EXISTS.

--In addition to the three columns in the original query, you should also include a fourth column called "RejectedQty",
--which has one value for rejected quantity from the Purchasing.PurchaseOrderDetail table.
SELECT
       A.PurchaseOrderID,
	   A.OrderDate,
	   A.TotalDue

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
	WHERE A.PurchaseOrderID = B.PurchaseOrderID
		AND B.RejectedQty > 5
)

ORDER BY 1

--My solution:
if object_id('tempdb..#Purchases') is not null drop table #Purchases;
create table #Purchases(
	PurchaseOrderID int,
	OrderDate date,
	TotalDue int,
	RejectedQty int
);

insert into #Purchases(
	PurchaseOrderID,
	OrderDate,
	TotalDue
)
select
	PurchaseOrderID,
	OrderDate,
	TotalDue
from AdventureWorks2019.Purchasing.PurchaseOrderHeader;

update #Purchases
set RejectedQty = POD.RejectedQty
from #Purchases P
	join AdventureWorks2019.Purchasing.PurchaseOrderDetail POD
		on P.PurchaseOrderID = POD.PurchaseOrderID
where POD.RejectedQty > 5;

select 
	* 
from #Purchases
where RejectedQty is not null;

DROP TABLE #Purchases;