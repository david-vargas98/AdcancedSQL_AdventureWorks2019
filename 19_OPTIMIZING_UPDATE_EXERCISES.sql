--Exercise:
--Making use of temp tables and UPDATE statements, re-write an optimized version of the query in the 
--"Optimizing With UPDATE - Exercise Starter Code.sql" file, which you'll find in the resources for this section.
-- Original code:

SELECT 
	   A.BusinessEntityID
      ,A.Title
      ,A.FirstName
      ,A.MiddleName
      ,A.LastName
	  ,B.PhoneNumber
	  ,PhoneNumberType = C.Name
	  ,D.EmailAddress

FROM AdventureWorks2019.Person.Person A
	LEFT JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID
	LEFT JOIN AdventureWorks2019.Person.PhoneNumberType C
		ON B.PhoneNumberTypeID = C.PhoneNumberTypeID
	LEFT JOIN AdventureWorks2019.Person.EmailAddress D
		ON A.BusinessEntityID = D.BusinessEntityID

-- My solution:
if object_id('tempdb..#Employees') is not null drop table #Employees;
create table #Employees(
	BusinessEntityID int,
    Title varchar(70),
    FirstName varchar(30),
    MiddleName varchar(30),
    LastName varchar(30),
	PhoneNumber varchar(30),
	PhoneNumberType varchar(20),
	EmailAddress varchar(80)
);

insert into #Employees(
	BusinessEntityID,
	Title,
	FirstName,
	MiddleName,
	LastName
)
select
	BusinessEntityID,
	Title,
	FirstName,
	MiddleName,
	LastName
from AdventureWorks2019.Person.Person;

update #Employees
set
	PhoneNumber = PP.PhoneNumber,
	PhoneNumberType = PNT.Name
from #Employees E
	join AdventureWorks2019.Person.PersonPhone PP
		on E.BusinessEntityID = PP.BusinessEntityID
	join AdventureWorks2019.Person.PhoneNumberType PNT
		on PP.PhoneNumberTypeID = PNT.PhoneNumberTypeID;

update #Employees
set EmailAddress = EA.EmailAddress
from #Employees E
	join AdventureWorks2019.Person.EmailAddress EA
		on E.BusinessEntityID = EA.BusinessEntityID;
	
select * from #Employees order by BusinessEntityID