-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-05-22 06:18:03.671

CREATE DATABASE p;

USE p;

-- tables

-- Table: Osakond
CREATE TABLE Osakond (
    osakondID     INT IDENTITY(1,1) NOT NULL,
    osakond_nimi  VARCHAR(30)     NOT NULL,
    aadress       VARCHAR(30)     NOT NULL,
    CONSTRAINT Osakond_pk PRIMARY KEY (osakondID)
);

-- Table: Politseinik
CREATE TABLE Politseinik (
    politseinikID       INT IDENTITY(1,1) NOT NULL,
    eesnimi             VARCHAR(50)     NOT NULL,
    perenimi            VARCHAR(50)     NOT NULL,
    auaste              VARCHAR(20)     NOT NULL,
    Osakond_osakondID   INT             NOT NULL,
    CONSTRAINT Politseinik_pk PRIMARY KEY (politseinikID)
);

-- Table: Asja
CREATE TABLE Asja (
    AsjaID                       INT IDENTITY(1,1) NOT NULL,
    kirjeldus                    VARCHAR(30)        NOT NULL,
    Politseinik_politseinikID    INT                NOT NULL,
    CONSTRAINT Asja_pk PRIMARY KEY (AsjaID)
);

-- Table: Auhind
CREATE TABLE Auhind (
    auhindID                     INT IDENTITY(1,1) NOT NULL,
    auhinna_nimi                 VARCHAR(20)        NOT NULL,
    auhinna_kuupaev              DATE               NOT NULL,
    Politseinik_politseinikID    INT                NOT NULL,
    CONSTRAINT Auhind_pk PRIMARY KEY (auhindID)
);

-- Table: Kohustus
CREATE TABLE Kohustus (
    kohustusID                   INT IDENTITY(1,1) NOT NULL,
    kohustuse_nimi               VARCHAR(20)        NOT NULL,
    algus_kuupaev                DATE               NOT NULL,
    lopp_kuupaev                 DATE               NOT NULL,
    Politseinik_politseinikID    INT                NOT NULL,
    CONSTRAINT Kohustus_pk PRIMARY KEY (kohustusID)
);

-- Table: Töögraafik
CREATE TABLE Töögraafik (
    graafikID                    INT IDENTITY(1,1) NOT NULL,
    algus_kuupaev                DATE               NOT NULL,
    lopp_kuupaev                 DATE               NOT NULL,
    Politseinik_politseinikID    INT                NOT NULL,
    CONSTRAINT Töögraafik_pk PRIMARY KEY (graafikID)
);



-- foreign keys

-- Reference: Politseinik_Osakond (table: Politseinik)
ALTER TABLE Politseinik
  ADD CONSTRAINT Politseinik_Osakond
    FOREIGN KEY (Osakond_osakondID)
    REFERENCES Osakond(osakondID);


-- Reference: Asja_Politseinik (table: Asja)
ALTER TABLE Asja
  ADD CONSTRAINT Asja_Politseinik
    FOREIGN KEY (Politseinik_politseinikID)
    REFERENCES Politseinik(politseinikID);

-- Reference: Auhind_Politseinik (table: Auhind)
ALTER TABLE Auhind
  ADD CONSTRAINT Auhind_Politseinik
    FOREIGN KEY (Politseinik_politseinikID)
    REFERENCES Politseinik(politseinikID);

-- Reference: Kohustus_Politseinik (table: Kohustus)
ALTER TABLE Kohustus
  ADD CONSTRAINT Kohustus_Politseinik
    FOREIGN KEY (Politseinik_politseinikID)
    REFERENCES Politseinik(politseinikID);

-- Reference: Töögraafik_Politseinik (table: Töögraafik)
ALTER TABLE Töögraafik
  ADD CONSTRAINT Töögraafik_Politseinik
    FOREIGN KEY (Politseinik_politseinikID)
    REFERENCES Politseinik(politseinikID);


-- 1) Osakond
INSERT INTO Osakond (osakond_nimi, aadress) VALUES
  ('Vägivald',       'Tartu mnt 5'),
  ('Liiklus',         'Pärnu mnt 10'),
  ('Varavastused',    'Narva mnt 20'),
  ('Röövimised',      'Liivalaia 15'),
  ('Pettused',        'Viru väljak 3');

-- 2) Politseinik
INSERT INTO Politseinik (eesnimi, perenimi, auaste, Osakond_osakondID) VALUES
  ('Mati',    'Tamm',    'seersant', 1),
  ('Liis',    'Kask',    'kapral',   2),
  ('Jüri',    'Laane',   'konstaabel',3),
  ('Anna',    'Rebane',  'kapten',   4),
  ('Peeter',  'Saar',    'konstaabel',5);

-- 3) Asja (juhtumid)
INSERT INTO Asja (kirjeldus, Politseinik_politseinikID) VALUES
  ('Liiklusohtlik juht',         2),
  ('Korteri vargus',             3),
  ('Röövimine poes',             4),
  ('Petuskeem internetis',       5),
  ('Vägivallajuhtum pubis',      1);

-- 4) Auhind
INSERT INTO Auhind (auhinna_nimi, auhinna_kuupaev, Politseinik_politseinikID) VALUES
  ('Aasta patrull',      '2025-01-15', 2),
  ('Parim koostöö',      '2025-02-20', 3),
  ('Tublim vahtkond',    '2025-03-10', 1),
  ('Kiituskiri märkamise', '2025-04-05',4),
  ('Oskuste arendus',     '2025-05-01', 5);

-- 5) Kohustus
INSERT INTO Kohustus (kohustuse_nimi, algus_kuupaev, lopp_kuupaev, Politseinik_politseinikID) VALUES
  ('Ööpatrull',        '2025-05-01', '2025-05-02', 1),
  ('Kiirabi toetus',   '2025-04-20', '2025-04-20', 2),
  ('Ürituse valve',     '2025-03-15', '2025-03-15', 3),
  ('Andmepõhine uurimine','2025-02-10','2025-02-12', 4),
  ('Koostöö kooliga',   '2025-01-05', '2025-01-05', 5);

-- 6) Töögraafik
INSERT INTO Töögraafik (algus_kuupaev, lopp_kuupaev, Politseinik_politseinikID) VALUES
  ('2025-05-01', '2025-05-07', 1),
  ('2025-05-08', '2025-05-14', 2),
  ('2025-05-15', '2025-05-21', 3),
  ('2025-05-22', '2025-05-28', 4),
  ('2025-05-29', '2025-06-04', 5);



SELECT * FROM Osakond;
SELECT * FROM Politseinik;
SELECT * FROM Asja;
SELECT * FROM Auhind;
SELECT * FROM Kohustus;
SELECT * FROM Töögraafik;


-- 1) Uue politseiniku lisamine
CREATE PROCEDURE LisaPolitseinik
    @eesnimi VARCHAR(50),
    @perenimi VARCHAR(50),
    @auaste VARCHAR(20),
    @osakondID INT
AS
BEGIN
    INSERT INTO Politseinik (eesnimi, perenimi, auaste, Osakond_osakondID)
    VALUES (@eesnimi, @perenimi, @auaste, @osakondID);
END;



-- 2) Politseiniku auastme uuendamine
CREATE PROCEDURE UuendaAuaste
    @politseinikID INT,
    @uusAuaste VARCHAR(20)
AS
BEGIN
    UPDATE Politseinik
    SET auaste = @uusAuaste
    WHERE politseinikID = @politseinikID;
END;


-- 3) Politseinike kuvamine osakonna järgi
CREATE PROCEDURE KuvastaPolitseinikudOsakonnas
    @osakondID INT
AS
BEGIN
    SELECT politseinikID, eesnimi, perenimi, auaste
    FROM Politseinik
    WHERE Osakond_osakondID = @osakondID;
END;


-- 4) Uue juhtumi lisamine
CREATE PROCEDURE LisaJuhtum
    @kirjeldus VARCHAR(200),
    @politseinikID INT
AS
BEGIN
    INSERT INTO Asja (kirjeldus, Politseinik_politseinikID)
    VALUES (@kirjeldus, @politseinikID);
END;


-- 5) Töögraafiku lisamine
CREATE PROCEDURE LisaToograafik
    @algus DATE,
    @lopp DATE,
    @politseinikID INT
AS
BEGIN
    INSERT INTO Töögraafik (algus_kuupaev, lopp_kuupaev, Politseinik_politseinikID)
    VALUES (@algus, @lopp, @politseinikID);
END;


SELECT 
  Politseinik_politseinikID, 
  COUNT(*) AS juhtumite_arv
FROM Asja
GROUP BY Politseinik_politseinikID;

SELECT 
  Politseinik_politseinikID, 
  COUNT(*) AS auhindade_arv
FROM Auhind
GROUP BY Politseinik_politseinikID;

SELECT 
  Politseinik_politseinikID, 
  COUNT(*) AS kohustuste_arv
FROM Kohustus
GROUP BY Politseinik_politseinikID;

BEGIN TRANSACTION;
UPDATE Politseinik
SET auaste = 'kapten'
WHERE politseinikID = 1;
INSERT INTO Auhind (auhinna_nimi, auhinna_kuupaev, Politseinik_politseinikID)
VALUES ('Hea töö eest', GETDATE(), 1);
COMMIT TRANSACTION;

SELECT * FROM politseinik

BEGIN TRANSACTION;
UPDATE Asja
SET Politseinik_politseinikID = 2
WHERE AsjaID = 3;
UPDATE Asja
SET kirjeldus = 'Kontrollitud juhtum'
WHERE AsjaID = 3;












create table logi (
id int identity(1,1) primary key,
aeg datetime,
toiming varchar(100),
andmed text
);

create trigger politseiniklisamine
on politseinik
for insert
as
insert into logi (aeg, toiming, andmed)
select
getdate(),
'politseinik lisamine',
'lisati: ' + i.eesnimi + ' ' + i.perenimi + ', auaste: ' + i.auaste + ', osakond: ' + o.osakond_nimi
from
inserted i
inner join osakond o on i.osakond_osakondid = o.osakondid;


create trigger politseinikuuendamine
on politseinik
for update
as
insert into logi (aeg, toiming, andmed)
select
getdate(),
'politseinik uuendamine',
'vana: (' + d.eesnimi + ' ' + d.perenimi + ', ' + d.auaste + ')' +
' uus: (' + i.eesnimi + ' ' + i.perenimi + ', ' + i.auaste + ')'
from
inserted i
inner join deleted d on i.politseinikid = d.politseinikid;


create trigger politseinikkustutamine
on politseinik
for delete
as
insert into logi (aeg, toiming, andmed)
select
getdate(),
'politseinik kustutamine',
'kustutati: ' + d.eesnimi + ' ' + d.perenimi + ', auaste: ' + d.auaste + ', osakond: ' + o.osakond_nimi
from
deleted d
inner join osakond o on d.osakond_osakondid = o.osakondid;


create trigger osakondlisamine
on osakond
for insert
as
insert into logi (aeg, toiming, andmed)
select
getdate(),
'osakond lisamine',
'lisati osakond: ' + i.osakond_nimi + ', aadress: ' + i.aadress
from
inserted i;

create trigger osakonduuendamine
on osakond
for update
as
insert into logi (aeg, toiming, andmed)
select
getdate(),
'osakond uuendamine',
'vana: (' + d.osakond_nimi + ', ' + d.aadress + ')' +
' uus: (' + i.osakond_nimi + ', ' + i.aadress + ')'
from
inserted i
inner join deleted d on i.osakondid = d.osakondid;

create trigger osakondkustutamine
on osakond
for delete
as
insert into logi (aeg, toiming, andmed)
select
getdate(),
'osakond kustutamine',
'kustutati osakond: ' + d.osakond_nimi + ', aadress: ' + d.aadress
from
deleted d;


insert into osakond (osakond_nimi, aadress) values ('küber', 'mäepealse 3');

update osakond set aadress = 'mustamäe tee 5' where osakond_nimi = 'küber';

insert into politseinik (eesnimi, perenimi, auaste, osakond_osakondid) values ('mari', 'maasikas', 'inspektor', 6);

update politseinik set auaste = 'vaneminspektor' where eesnimi = 'mari';

delete from asja where politseinik_politseinikid = (select politseinikid from politseinik where eesnimi = 'mari');
delete from auhind where politseinik_politseinikid = (select politseinikid from politseinik where eesnimi = 'mari');
delete from kohustus where politseinik_politseinikid = (select politseinikid from politseinik where eesnimi = 'mari');
delete from töögraafik where politseinik_politseinikid = (select politseinikid from politseinik where eesnimi = 'mari');

delete from politseinik where eesnimi = 'mari';

delete from osakond where osakond_nimi = 'küber';

select * from logi;

