create database kool

use kool


create table opetaja (
    opetajaid int identity(1,1) primary key,
    opetajanimi varchar(30) not null,
    aine varchar(30)
);

create table klass (
    klassid int identity(1,1) primary key,
    klassnimi varchar(30) not null,
    opetajaid int not null,
    opilastearv varchar(10)
);

alter table klass
add constraint fk_klass_opetaja
foreign key (opetajaid) references opetaja(opetajaid);

create table opilane (
    opilaneid int identity(1,1) primary key,
    opilasenimi varchar(30) not null,
    klassid int not null
);

alter table opilane
add constraint fk_opilane_klass
foreign key (klassid) references klass(klassid);


insert into opetaja (opetajanimi, aine) values 
('Irina Merkulova', 'veebirakendus'),
('Marina Oleinik', 'programmeerimine'),
('Mari Speek', 'ajalugu'),
('Nadezda Voronova', 'matemaatika'),
('Ruslan Morits', 'inglise keel');

insert into klass (klassnimi, opetajaid, opilastearv) values 
('TARpv24', 1, '18'),
('TARpv23', 2, '19'),
('TARgv24', 3, '20'),
('TARpe24', 4, '21'),
('TARgv25', 5, '22');

insert into opilane (opilasenimi, klassid) values 
('Roman', 1),
('Nikita', 2),
('Artjom', 3),
('Oleg', 4),
('Ignat', 5);

grant select, insert on klass to opilaneRoman;
grant select, insert on opetaja to opilaneRoman;
grant select, insert on opilane to opilaneRoman;

create table logi (
id int identity(1,1) primary key,
kasutaja varchar(50) not null,
kuupaev datetime not null,
tegevus varchar(50) not null,
andmed varchar(100) not null
);

create trigger kustutamineKlass
on klass
after delete
as
begin
insert into logi (kasutaja, kuupaev, tegevus, andmed)
select 
system_user,
getdate(),
'kustutamine',
concat('klassid: ', deleted.klassid, 
        ', klassnimi: ', deleted.klassnimi, 
        ', opetajaid: ', deleted.opetajaid, 
        ', opilastearv: ', deleted.opilastearv)
from deleted;
end;


insert into klass (klassnimi, opetajaid, opilastearv) 
values ('test', 1, '10');
select * from klass;

delete from klass where klassnimi = 'test';
select * from logi;



create trigger lisamineKlass
on klass
after insert
as
begin
insert into logi (kasutaja, kuupaev, tegevus, andmed)
select 
system_user,
getdate(),
'lisamine',
concat('klassid: ', inserted.klassid, 
        ', klassnimi: ', inserted.klassnimi, 
        ', opetajaid: ', inserted.opetajaid, 
        ', opilastearv: ', inserted.opilastearv)
from inserted;
end;


insert into klass (klassnimi, opetajaid, opilastearv) 
values ('testinsert', 1, '12');
select * from logi;


create procedure kuvaKlassid
@opetajanimi varchar(30)
as
begin
select 
k.klassnimi,
k.opilastearv
from klass k
join opetaja p on k.opetajaid = p.opetajaid
where p.opetajanimi = @opetajanimi
end;

exec kuvaKlassid 'Irina Merkulova';
exec kuvaKlassid 'Marina Oleinik';


begin transaction;
insert into opilane (opilasenimi, klassid) values ('Test1', 1);
insert into opilane (opilasenimi, klassid) values ('Test2', 1);

save transaction savepoint;

insert into opilane (opilasenimi, klassid) values ('Test3', 1);

rollback transaction savepoint;

commit transaction;

select * from opilane


create view opilased_opetaja as
select 
    o.opilasenimi,
    k.klassnimi,
    p.opetajanimi
from opilane o
join klass k on o.klassid = k.klassid
join opetaja p on k.opetajaid = p.opetajaid;

select * from opilased_opetaja
