create database dbtest;
use dbtest;
create table #bst (n int, p int);

insert into #bst values(10, NULL)
insert into #bst values(9, 10)
insert into #bst values(8, 10)
insert into #bst values(7, 10)
insert into #bst values(6, 9)
insert into #bst values(5, 6)
insert into #bst values(4, 8)
insert into #bst values(3, 8)
insert into #bst values(2, 7)
insert into #bst values(1, 3)

/*ƒана таблица, перва€ колонка - номер ID, втора€ - Parent ID, или родительский ID
‘актически - древовидна€ структура данных.
Ќапишите запрос, возвращающий две колонки - n и информаци€ о том, €вл€етс€ ли n корневым узлом (root), конечным (leaf) или промежуточным (inner)
результат:
1 Leaf
2 Leaf
3 Inner
4 Leaf
5 Leaf
6 Inner
7 Inner
8 Inner
9 Inner
10 Root
*/
drop table bst
create table bst (n int, p int);
insert into bst(n,p)
select n,p 
from #bst

GO;
CREATE FUNCTION Define_This( @Opd1 INT)
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @Result VARCHAR(10), @ChildNumber INT, @ParentNumber INT
SET @ChildNumber = (
SELECT COUNT(parent.N) as Status
from bst as child
INNER JOIN bst as parent 
ON child.p = parent.n
Where parent.n = @Opd1
)
SET @ParentNumber = (
SELECT COUNT(parent.N) as Status
from bst as child
INNER JOIN bst as parent 
ON child.p = parent.n
Where child.n = @Opd1
)
SET @Result =
CASE 
WHEN (@ParentNumber = 0) THEN 'Root'
WHEN (@ChildNumber > 0) THEN 'Inner'
ELSE 'Leaf'
END
Return @Result
END;
GO;

GO;
SELECT n, [dbo].Define_This(n) FROM #bst

DROP TABLE #bst

--«адание номер два
create table #t(id int, sum1 decimal(10,2))
insert #t(id, sum1) values(1, 1.2)
insert #t(id, sum1) values(2, 1.5)
insert #t(id, sum1) values(3, 1.7)
insert #t(id, sum1) values(4, -0.5)

/*Ќапишите запрос, возвращающий нарастающий итог второй колонки
–езультат:
1 1.20 1.20
2 1.50 2.70
3 1.70 4.40
4 -0.50 3.90
*/

SELECT id, sum1, (SELECT SUM(t2.sum1)
FROM #t as t2 
WHERE t2.id <= t1.id) as Sum 
FROM #t as t1

drop table #t

--«адание номер три
/*
задекларируйте две переменные типа datetime @datefrom, @datetill, первой присвойте значение "год назад", второй - текущую дату.
Ќапишите запрос, возвращающий все дни за период с @datefrom по @datetill
*/

DECLARE @datefrom DATE, @datetill DATE;
SET @datetill = CURRENT_TIMESTAMP;
SET @datefrom = DATEADD(YEAR, -1, @datetill)

CREATE TABLE #dates(date1 date);

WHILE (@datefrom <= @datetill)
	BEGIN
	INSERT INTO #dates VALUES(@datefrom)
	SET @datefrom = DATEADD(DAY, 1, @datefrom)
	END

SELECT * from #dates
