create database indexLoomine;
use indexLoomine;

--loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame tabelisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutame union all, näitab kõiki ridu
--näitab kõik ridu, kui veerunimed on samad
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

-- korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--- kuidas tulemust sorteerida nime järgi ja kasutada union all-i
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--- stored procedure
create procedure spGetCustomers
as begin
	select Name, Email from UKCustomers
end
drop procedure spgetCustomers

-- nüüd saab kasutada selle nimelist sp-d
spGetCustomers
exec spGetCustomers
execute spGetCustomers

--loome tabeli employees
create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(10),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (2, 'Pam', 'Female', 3000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (3, 'John', 'Male', 3500, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (4, 'Sam', 'Male', 4500, 2)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (5, 'Todd', 'Male', 2800, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (6, 'Ben', 'Male', 7000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (7, 'Sara', 'Female', 4800, 3)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (8, 'Valarie', 'Female', 5500, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (9, 'James', 'Male', 6500, NULL)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (10, 'Russell', 'Male', 8800, NULL)

create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

insert into Department (Id, DepartmentName, Location, DepartmentHead)
values (1, 'IT', 'London', 'Rick')
insert into Department (Id, DepartmentName, Location, DepartmentHead)
values (2, 'Payroll', 'Delhi', 'Ron')
insert into Department (Id, DepartmentName, Location, DepartmentHead)
values (3, 'HR', 'New York', 'Christie')
insert into Department (Id, DepartmentName, Location, DepartmentHead)
values (4, 'Other Deparment', 'Sydney', 'Cindrella')

select * from Employees
select * from Department

--näitab tabelisisu, kui kasutaja sisestab gender(sugu) ja departmentId
create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
as begin
	select Name, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--see käsklus nõuab, et antakse Gender parameeter
spGetEmployeesByGenderAndDepartment
-- õige variant
spGetEmployeesByGenderAndDepartment 'Male', 1

--- niimoodi saab j'rjekorda muuta päringul, kui ise paned muutuja paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

-- soov vaadata sp sisu
sp_helptext spGetEmployeesByGenderAndDepartment


--- kuidas muuta sp-d ja pane krüpteeringu peale, et keegi teine peale teid ei saaks muuta
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --krüpteerimine
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

sp_helptext spGetEmployeesByGenderAndDepartment

-- sp tegemine
--loeb inimeste arv vastavalt sisestatud gender
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end
exec spGetEmployeeCountByGender 'Male'


-- annab tulemuse, kus loendab ära nõuetele vastavad read
-- prindib tulemuse konsooli
--käivitame spGetEmployeeCountByGender 'Male'
declare @TotalCount int
execute spGetEmployeeCountByGender 'Male', @TotalCount out
if(@TotalCount = 0)
	print 'TotalCount is null'
else
	print '@Total is not null'
print @TotalCount

-- näitab ära, et mitu ridu vastab nõuetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

-- sp sisu vaatamine
sp_help spGetEmployeeCountByGender
-- tabeli info
sp_help Employees
-- kui soovid sp tektsi näha
sp_helptext spGetEmployeeCountByGender

-- vaatame , millest see sp sõltub
sp_depends spGetEmployeeCountByGender
-- vaatame tabelit
sp_depends Employees


--proceduur mis ei tööta korrektselt, tulemuses annab üks ja sama nimi
--peame lisama where...
create proc spGetnameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = Name from Employees
end

select * from Employees
declare @FirstName nvarchar(50)
execute spGetnameById 2, @FirstName output
print 'Name of the employee = ' + @FirstName

--näitab nimi sisestatud id järgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
	select @FirstName = Name from Employees where Id = @Id
end
--proc kutse
declare @FirstName nvarchar(50)
execute spGetNameById1 4, @FirstName output
print 'Name of the employee = ' + @FirstName

sp_help spGetNameById1

---
create proc spGetNameById2
@Id int
as begin
	return (select Name from Employees where Id = @Id)
end

-- tuleb veateade kuna kutsusime välja int-i, aga Tom on string
declare @FirstName nvarchar(50)
execute @FirstName = spGetNameById2 1
print 'Name of the employee = ' + @FirstName
--

--- sisseehitatud string funktsioonid
-- see konverteerib ASCII tähe väärtuse numbriks
select ascii('a')
-- kuvab A-tähe
select char (97)

--prindime kogu tähestiku välja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
	select char (@Start)
	set @Start = @Start + 1
end

-- eemaldame tühjad kohad sulgudes
select ltrim('        Hello')

-- tühikute eemaldamine veerust
select ltrim(Name) as FirstName from Employees

select * from Employees

--paremalt poolt tühjad stringid lõikab ära
select rtrim('      Hello          ')

--keerab kooloni sees olevad andmed vastupidiseks
-- vastavalt upper ja lower-ga saan muuta märkide suurust
-- reverse funktsioon pöörab kõik ümber
select REVERSE(UPPER(ltrim(Name))) as FirstName, lower(Gender) as Gender,
rtrim(ltrim(Name)) + ' ' + Gender as FullInfo
from Employees

--näeb, mitu tähte on sõnal ja loeb tühikud sisse
select Name, len(Name) as [Total Characters] from Employees

--- näeb, mitu tähte on sõnal ja ei loe tyhikuid sisse
select Name, len(ltrim(Name)) as [Total Characters] from Employees

-- left, right ja substring
--- vasakult poolt neli esimest tähte
select left('ABCDEF', 4)
-- paremalt poolt kolm tähte
select right('ABCDEF', 3)

--kuvab @-tähemärgi asetust e mitmes on @ märk
select charindex('@', 'sara@aaa.com')

--- esimene nr peale komakohta näitab, et mitmendast alustab ja siis mitu nr peale
-- seda kuvada
select SUBSTRING('pam@btbb.com', 5, 2)

--- @-märgist kuvab kolm tähemärki. Viimase numriga saab määrata pikkust
select substring('pam@bb.com', charindex('@', 'pam@bb.com') + 1, 3)

--- peale @-märki reguleerin tähemärkide pikkuse näitamist
select substring('pam@bb.com', charindex('@', 'pam@bb.com') + 1, 
len('pam@bb.com') - CHARINDEX('@', 'pam@bb.com'))

select * from Employees

-- vaja teha uus veerg nimega Email, nvarchar (20)
alter table Employees
add Email nvarchar(20)

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

select * from Employees

--- lisame *-märgi alates teatud kohast
select Name,
	substring(Email, 1, 2) + REPLICATE('*', 5) + --peale teist tähemärki paneb viis tärni
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - charindex('@', Email)+1) as Email
from Employees

--- kolm korda näitab stringis olevat väärtust
--dubleerib nimi kolm korda
select replicate(Name, 3)
from Employees

select replicate('asd', 3)

-- kuidas sisestada tyhikut kahe nime vahele
select space(5)

--Employees tabelist teed päringu kahe nime osas (FirstName ja LastName)
--kahe nime vahel on 25 tühikut
select FirstName + space(25) + LastName as FullName
from Employees
