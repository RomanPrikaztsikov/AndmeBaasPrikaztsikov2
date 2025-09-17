create database toodePrikaztsikov;
use toodePrikaztsikov;

-- 1. Kõik tooted koos kategooriate nimedega
select t.toodenimetus, t.hind, tk.nimetus
from toode t
join toodekategooria tk on t.toodekategooriaId = tk.toodekategooriaId;

-- 2. Kõige kallim hind igas kategoorias
select tk.nimetus, max(t.hind) as maks_hind
from toode t
join toodekategooria tk on t.toodekategooriaId = tk.toodekategooriaId
group by tk.nimetus;

-- 3. Kõik kategooriad ja nende toodete arv
select tk.nimetus, count(t.toodeId) as toodete_arv
from toodekategooria tk
left join toode t on t.toodekategooriaId = tk.toodekategooriaId
group by tk.nimetus;

-- 4. Toodete keskmine hind kategooria kaupa
select tk.nimetus, avg(cast(t.hind as float)) as keskmine_hind
from toodekategooria tk
left join toode t on t.toodekategooriaId = tk.toodekategooriaId
group by tk.nimetus;

-- 5. Kategooriad, kus pole ühtegi toodet
select tk.nimetus
from toodekategooria tk
left join toode t on t.toodekategooriaId = tk.toodekategooriaId
where t.toodeId is null;

-- 6. Kõik tooted, mille hind on suurem kui tabeli keskmine hind
select *
from toode
where hind > (select avg(cast(hind as float)) from toode);





create table toodekategooria(
toodekategooriaId int primary key identity(1,1),
nimetus varchar(100) unique,
kirjeldus text
);

create table toode(
toodeId int primary key identity(1,1),
toodenimetus varchar(100) unique,
hind decimal(5,2),
toodekategooriaId int,
foreign key (toodekategooriaId) references toodekategooria(toodekategooriaId)
);

insert into toodekategooria(nimetus) values
('joogid'), ('meelelahutus'), ('tühi kategooria');

insert into toode(toodenimetus, hind, toodekategooriaId) values
('fanta', 3.50, 1);

insert into toode(toodenimetus, hind, toodekategooriaId) values
('cola', 5.00, 2),
('sprite', 120.0, 2);

drop table toode

insert into toodekategooria(nimetus) values
('elektroonika');

insert into toodekategooria(nimetus) values
('riided');

--1. vaade mis näitab kõik tooded ja nende hinnad
create view toode_nimi_ja_hind as
select toodenimetus, hind from toode;

--kuuvame vaade
select * from toode_nimi_ja_hind;

-- 3. loo vaade, mis kuvab ainult aktiivseid (nt saadaval olevaid) tooteid

--tabeli sktruktuuri muutmine, uue veergu lisamine
alter table toode add aktiivne bit; 
update toode set aktiivne = 1;
update toode set aktiivne = 0 where toodeId = 2;
select * from toode;

create view saadav_toode as 
select * from toode where aktiivne = 1;

select * from saadav_toode;

--4. loo vaade mis koondab info: kategooria nimi, toodete arv, minimaalne ja maksimaalne hind.
create view kategooriaInfo as
select tk.nimetus, count(*) as 'toodete arv', min(t.hind) as 'min hind', max(t.hind) as 'max hind' 
from toodekategooria tk
inner join toode t on t.toodekategooriaId = tk.toodekategooriaId 
group by tk.nimetus;

select * from kategooriaInfo;

--loo vaade mis  arvutab toode kaibemaksu (24%) ja iga toode hind kaibemaksuga
create view toode_kaibemaksuga as
select 
    toodenimetus, hind,
    cast(hind * 0.24 as decimal(5,2)) as kaibemaks,
    cast(hind * 1.24 as decimal(5,2)) as hind_kaibemaksuga
from toode;

select * from toode_kaibemaksuga

--Loo protseduur, mis lisab uue toote (sisendparameetrid: tootenimi, hind, kategooriaID).
create procedure todesse_panna
  @toodenimetus varchar(200),
  @hind int,
  @toodeKategooriaID int,
  @aktiivne bit
as
begin
  insert into toode (toodenimetus, hind, toodeKategooriaID, aktiivne)
  values (@toodeNimetus, @hind, @toodeKategooriaID, @aktiivne);

  select * from toode;
end;

drop procedure todesse_panna

exec todesse_panna 'protseduur', 10, 2, 1;

--2. Loo protseduur, mis uuendab toote hinda vastavalt tooteID-le.
create procedure uuenda_toote_hind
@toodeId int,
@uusHind decimal(5,2)
as
begin
    update toode
    set hind = @uusHind
    where toodeId = @toodeId;

    select * from toode where toodeId = @toodeId;
end

exec uuenda_toote_hind

select * from toode
 
drop procedure uuenda_toote_hind


--3. Loo protseduur, mis kustutab toote ID järgi.
create procedure kustuta_toode
@toodeId int
as
begin
    delete from toode where toodeId = 3;
    select * from toode;
end

exec kustuta_toode 3

drop procedure kustuta_toode

--4. Loo protseduur, mis tagastab kõik tooted valitud kategooriaID järgi.
create procedure leia_tooted
@toodeKategooriaID int
as
begin
    select * from toode
    where toodekategooriaId = @toodeKategooriaID;
end

exec leia_tooted 5

drop procedure leia_tooted

--5. Loo protseduur, mis tõstab kõigi toodete hindu kindlas kategoorias kindla protsendi võrra.
create procedure toote_hind_tous
@toodeKategooriaID int
as
begin
    update toode
    set hind = hind * 2
    where toodekategooriaId = 1;

    select * from toode where toodekategooriaId = 1;
end


exec toote_hind_tous 1

drop procedure toote_hind_tous


--6. Loo protseduur, mis kuvab kõige kallima toote kogu andmebaasis.
create procedure kuva_kallim
as
begin
    select * from toode
    where hind = (select max(hind) from toode);
end

exec kuva_kallim

drop procedure kuva_kallim

grant insert, update, delete on toode to tootehaldur;

grant select, insert, update on toodekategooria to kataloogihaldur;


grant select on toodekategooria to vaataja;
grant select on toode to vaataja;


SELECT 
  CONCAT(table_schema, '.', table_name) AS scope, 
  grantee, 
  privilege_type 
FROM information_schema.table_privileges;


--Tabeli loomine
create table transaktioonid (
    id int primary key,
    kirjeldus varchar(100),
    summa decimal(10, 2),
    kuupaev date
);

--Lisa andmed
insert into transaktioonid (id, kirjeldus, summa, kuupaev) values
(1, 'kohv', 3.50, '2025-09-15'),
(2, 'raamat', 15.00, '2025-09-16');

--Transaktsioon, lisan bussipilet
begin transaction
insert into transaktioonid (id, kirjeldus, summa, kuupaev) values
(3, 'bussipilet', 2.50, '2025-09-17');
update transaktioonid
set summa = 16.00
where id = 2;
commit transaction

--kui soovite muudatusi tagasi võtta
rollback transaction

select * from transaktioonid



