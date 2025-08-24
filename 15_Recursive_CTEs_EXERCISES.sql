--Exercise #01
--Use a recursive CTE to generate a list of all odd numbers between 1 and 100.
--Hint: You should be able to do this with just a couple slight tweaks to the code from our first example in the video.
with OddNumbers as(

	select 1 as n -- anchor element

	union all

	select n + 2   -- recursion
	from OddNumbers
	where n < 99  -- exit condition

)
select n
from OddNumbers;

--It also could be solved by adding n % 2 != 0 condition and within the recursion block using n + 1, but it's less efficient

--Exercise #02
--Use a recursive CTE to generate a date series of all FIRST days of the month (1/1/2021, 2/1/2021, etc.)
--from 1/1/2020 to 12/1/2029.

--Hints:
--Use the DATEADD function strategically in your recursive member.
--You may also have to modify MAXRECURSION.

with DateSeries as(

	select cast('2020-01-01' as date) as MyDate -- anchor element, here i uso ISO format (YYYY-MM-DD) to avoid SQL misinterpreations xd

	Union all

	select dateadd(month, 1, MyDate) -- recursion
	from DateSeries
	where MyDate < cast('2029-12-01' as date) -- exit condition
)
select MyDate
from DateSeries
option(maxrecursion 120);
