--Exercise #01
--Select all records from the Purchasing.PurchaseOrderHeader table such that there is at least one item in the order with an order
--quantity greater than 500. The individual items tied to an order can be found in the Purchasing.PurchaseOrderDetail table.

--Select the following columns:

--PurchaseOrderID
--OrderDate
--SubTotal
--TaxAmt
--Sort by purchase order ID.

select 
	PurchaseOrderID,
	OrderDate,
	SubTotal,
	TaxAmt
from AdventureWorks2019.Purchasing.PurchaseOrderHeader POH
where exists (
	select
		1
	from AdventureWorks2019.Purchasing.PurchaseOrderDetail POD
	where POD.PurchaseOrderID = POH.PurchaseOrderID AND POD.OrderQty > 500
)
order by PurchaseOrderID

--Exercise #02
--Modify your query from Exercise 1 as follows:

--Select all records from the Purchasing.PurchaseOrderHeader table such that there is at least one item in the order with an order 
--quantity greater than 500, AND a unit price greater than $50.00.

--Select ALL columns from the Purchasing.PurchaseOrderHeader table for display in your output.

--Even if you have aliased this table to enable the use of a JOIN or EXISTS, you can still use the SELECT * shortcut to do this. 
--Assuming you have aliased your table "A", simply use "SELECT A.*" to select all columns from that table.
select 
	POH.*
from AdventureWorks2019.Purchasing.PurchaseOrderHeader POH
where exists (
	select
		1
	from AdventureWorks2019.Purchasing.PurchaseOrderDetail POD
	where POD.PurchaseOrderID = POH.PurchaseOrderID AND POD.OrderQty > 500 AND POD.UnitPrice > 50.0
)
order by PurchaseOrderID

--Exercise #03
--Select all records from the Purchasing.PurchaseOrderHeader table such that NONE of the items within the order have a rejected quantity 
--greater than 0.

--Select ALL columns from the Purchasing.PurchaseOrderHeader table using the "SELECT *" shortcut.
select 
	POH.*
from AdventureWorks2019.Purchasing.PurchaseOrderHeader POH
where not exists (
	select
		1
	from AdventureWorks2019.Purchasing.PurchaseOrderDetail POD
	where POD.PurchaseOrderID = POH.PurchaseOrderID AND POD.RejectedQty > 0
)
order by PurchaseOrderID