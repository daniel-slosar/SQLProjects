--Creation of Database--
CREATE database db_hardware
GO

USE db_hardware
GO

--Creation of scheme--
CREATE schema sch
GO

--Store Table--

CREATE TABLE	sch.store
(	id_store		INT				IDENTITY(1,1)
,	store_name			VARCHAR(20)		NOT NULL
,	store_address			VARCHAR(100)	NOT NULL
,	phone_num			NUMERIC(10,0)	NOT NULL
,	email			VARCHAR(20)		NOT NULL
,	CONSTRAINT	store_pk		PRIMARY KEY	(id_store)
,	CONSTRAINT	store_name_u1	UNIQUE	(store_name)
,	CONSTRAINT	phone_num_u2	UNIQUE	(phone_num)
,	CONSTRAINT	email_u3	UNIQUE	(email)
);

--Product Categories Table--

CREATE TABLE sch.categoryproduct
(	id_categories	INT		IDENTITY(1,1)
,	category		VARCHAR(15)	NOT NULL
,	CONSTRAINT		category_pk	PRIMARY KEY	(id_categories)
,	CONSTRAINT	category_u1	UNIQUE	(category)	
);

--Products Table--

CREATE TABLE sch.product
(	id_hardware		INT				IDENTITY(1,1)
,	id_categories	INT				NOT NULL
,	product_name	VARCHAR(20)		NOT NULL
,	price_4h		DECIMAL(10,2)	NOT NULL
,	price_1d		DECIMAL(10,2)	NOT NULL
,	price_weekend	DECIMAL(10,2)	NOT NULL
,	price_week		DECIMAL(10,2)	NOT NULL
,	deposit			DECIMAL(10,2)	NOT NULL
,	prod_description		VARCHAR(500)	NULL
,	CONSTRAINT	hardware_pk	PRIMARY KEY	(id_hardware)
,	CONSTRAINT	categories_fk	FOREIGN KEY	(id_categories)	references sch.categoryproduct
,	CONSTRAINT	product_name_u1	UNIQUE	(product_name)
);

--Customer Table--

CREATE TABLE sch.customer
(	id_customer	INT		IDENTITY(1,1)
,	customer_name	VARCHAR(10)		NOT NULL
,	customer_surname	VARCHAR(15)	NOT NULL
,	customer_address	VARCHAR(20)		NOT NULL
,	customer_address_line	INT			NOT NULL
,	town	VARCHAR(20)		NOT NULL
,	email	VARCHAR(30)		NOT NULL
,	phone_num	NUMERIC(10,0)	NOT NULL
,	CONSTRAINT	customer_pk	PRIMARY KEY	(id_customer)
,	CONSTRAINT	phone_num_u1	UNIQUE	(phone_num)
,	CONSTRAINT	email_u1	UNIQUE	(email)
);

--Reservation Table--

CREATE TABLE sch.reservation
(	id_reservation	INT		IDENTITY(1,1)
,	id_product		INT		NOT NULL
,	id_customer		INT		NOT NULL
,	reserv_date_from	DATETIME	NOT NULL
,	reserv_date_to	DATETIME	NOT NULL
,	note	VARCHAR(200)		NULL
,	CONSTRAINT	reservation_pk	PRIMARY KEY	(id_reservation)
,	CONSTRAINT	product_fk	FOREIGN KEY	(id_product)	REFERENCES	sch.product
,	CONSTRAINT	customer_fk	FOREIGN KEY	(id_customer)	REFERENCES	sch.customer
,	CONSTRAINT date_from_u1	UNIQUE	(reserv_date_from)
,	CONSTRAINT date_to_u2	UNIQUE	(reserv_date_to)
);



--SELECTS--

select * from sch.store
select * from sch.categoryproduct
select * from sch.product
select * from sch.customer
select * from sch.reservation

--PROCEDURES--
GO
CREATE PROCEDURE Customers_Town @Town VARCHAR(15)
AS
SELECT * FROM sch.customer WHERE town=@Town

EXEC  Customers_Town @Town = 'Bratislava';

GO 
CREATE PROCEDURE Product_Deposit @Deposit DECIMAL(10,2)
AS
SELECT product_name,deposit,prod_description FROM sch.product WHERE deposit=@Deposit

EXEC Product_Deposit @Deposit = 300.00 

--ALTERS--

ALTER TABLE sch.product
    ADD id_store INT
    CONSTRAINT store_fk 
        FOREIGN KEY (id_store) 
        REFERENCES sch.store(id_store)
;

ALTER TABLE sch.categoryproduct
ALTER COLUMN category VARCHAR(50);

ALTER TABLE sch.product
ALTER COLUMN product_name VARCHAR(50);

ALTER TABLE sch.reservation
ADD registration_time DATE NULL;

ALTER TABLE sch.product
ADD count_price_week DECIMAL(10,2) NULL;

--SELECTS--

SELECT id_hardware,id_categories,product_name,deposit
	FROM sch.product
	WHERE ABS(deposit) >= 100
	ORDER BY deposit ASC

SELECT customer_name,customer_surname,town
	FROM sch.customer
	WHERE town = 'Bratislava'
	GROUP BY customer_name,customer_surname,town
	ORDER BY customer_name,customer_surname,town

SELECT product_name,price_4h
	FROM sch.product
	GROUP BY product_name,price_4h

SELECT *from sch.product where price_1d IN('2','4','6','8')  

SELECT *from sch.customer where customer_name LIKE'D%' ORDER BY customer_name prod_description

--JOINS--

SELECT sch.product.id_categories,sch.categoryproduct.category, sch.product.product_name
FROM sch.product
INNER JOIN sch.categoryproduct ON sch.product.id_categories=sch.categoryproduct.id_categories;

SELECT sch.reservation.id_reservation,sch.product.product_name,sch.customer.customer_name,sch.customer.customer_surname,sch.reservation.reserv_date_from,sch.reservation.reserv_date_to
FROM sch.reservation
INNER JOIN sch.product ON sch.reservation.id_product=sch.product.id_hardware
INNER JOIN sch.customer ON sch.reservation.id_customer=sch.customer.id_customer

SELECT sch.customer.customer_name, sch.reservation.id_reservation
FROM sch.customer
LEFT JOIN sch.reservation ON sch.customer.id_customer = sch.reservation.id_customer
ORDER BY sch.customer.customer_name;


--TRIGGERS--

CREATE TRIGGER TimeRegistration
ON sch.reservation
	AFTER INSERT, UPDATE
    AS
    BEGIN
        UPDATE sch.reservation
            SET registration_time = CONVERT(DATE, GETDATE());
END


CREATE TRIGGER PriceWeekDeposit
ON sch.product
	AFTER INSERT, UPDATE
    AS
    BEGIN
        UPDATE sch.product
            SET count_price_week = price_week+deposit;
END



--INSERTS--

INSERT INTO sch.store(store_name,store_address,phone_num,email)
	VALUES('Pozicovna Vajanskeho','Vajanskeho 17 Presov',0908142536,'pozicovna@gmail.com')

--Categories--

INSERT INTO sch.categoryproduct(category)
	VALUES('Stavebne stroje a nastroje')

INSERT INTO sch.categoryproduct(category)
	VALUES('Elektricke stroje a nastroje')

INSERT INTO sch.categoryproduct(category)
	VALUES('Zahradna technika a naradie')

INSERT INTO sch.categoryproduct(category)
	VALUES('Cistiacie stroje')

INSERT INTO sch.categoryproduct(category)
	VALUES('Rucne naradie')

INSERT INTO sch.categoryproduct(category)
	VALUES('Rebriky,preprava a prislusenstvo')

--Products--

--pr1--
INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(7,'Drazkova freza',35.20,44.00,66.00,110.00,250.00,'Drážkovacia píla je vhodná na jednoduché pílenie priamych drážok v tvrdých druhoch kameňa. Nakoniec odstráňte z drážky kamene či betón pomocou drážkovacieho dláta. Pripojením odsávača prachu/vody zabránite vzniku prašnosti. Ceny sú uvedené vrátane bežného opotrebenia príslušných nožov.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(7,'Buracie kladivo',19.20,24.00,36.00,60.00,275.00,'Zbíjacie kladivo 11 kg s úchytom SDS-max má nastaviteľnú a otočnú rukoväť. Je vhodné na búranie kamenných múrov a rozbíjanie dláždených podláh. Rôzne dláta sa prenajímajú ako osobitné položky.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(7,'Diamantova vrtacka',30.40,38.00,57.00,95.00,300.00,'Pomocou diamantovej vŕtačky môžete vŕtať presné otvory do podláh a múrov z prostého betónu a kameňa. Ideálna na inštaláciu o. i. vzduchových potrubí. Používa sa výlučne v kombinácii s našim odsávačom prachu/vody. Rôzne diamantové vrtáky, centrovací kľúč a odsávač prachu/vody sa prenajímajú osobitne.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(7,'Mixer na maltu',10.40,13.00,19.50,32.50,150.00,'Miešač na maltu je ideálny na miešanie malty, farby a štukovej malty. Prídavný chránič sa dá po použití jednoducho očistiť vodou.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(7,'Freza na murivo',48.00,60.00,90.00,150.00,250.00,'Táto stenová píla je vhodná na rýchle a presné pílenie rovných otvorov v múroch či betónových stenách. Použitím chladenia vodou predídete vzniku prašnosti. Pripojením odsávača prachu/vody odčerpáte prebytočnú vodu. Ceny sú uvedené vrátane bežného opotrebenia príslušného noža.')

--pr2--
INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(8,'Hoblik',9.60,12.00,18.00,30.00,125.00,'Hobľovačka s prípojkou na odsávanie prachu/vody na ohobľovanie trámov a dverí na mieru. Je vhodná aj na hobľovanie drážok a zrezávanie hrán. Zariadenie je vybavené kombinovaným pokosovým a pozdĺžnym pravítkom.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(8,'Ponorne cerpadlo',12.80,16.00,24.00,40.00,100.00,'Ponorné čerpadlo 4 m³ sa dá použiť v prípade zaplavenia pivníc alebo prielezov. Zároveň sa hodí aj na odčerpanie vody z bazénov či plochých striech. Dodáva sa s 10 m hadicou.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(8,'Príklepová vŕtačka',12.80,16.00,24.00,40.00,150.00,'Príklepová vŕtačka s nastaviteľnou rukoväťou bez námahy vŕta do dreva, kovu a mäkkého kameňa. Vďaka príklepu, nastaviteľným otáčkam a ľavému aj pravému prevedeniu je vhodná na rôzne práce.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(8,'Doskova pila',28.00,35.00,52.50,87.50,300.00,'Táto elektrická fréza na dlaždice s vodným chladením je vhodná na bezprašné rezanie veľkých nástenných a podlahových dlaždíc. Zároveň sa hodí aj na uhlopriečne a pokosové rezanie dlaždíc. Dá sa s ňou vyrezať aj roh alebo dokonca vrub. Skladací podvozok pre jednoduchú prepravu. Ceny sú uvedené vrátane bežného opotrebovania príslušného noža.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(8,'Brúska na parkety',30.40,38.00,57.00,95.00,300.00,'Brúska na parkety je vhodná na renováciu starých doskových, parketových a drevených podláh. Pomocou tohto stroja môžete odstrániť aj nerovnosti a staré nátery. Prachové vrecia dostanete vo vašom obchode so stavebninami.')

--pr3--
INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(9,'Vertikutátor',25.60,32.00,48.00,80.00,200.00,'Benzínový vertikutátor odreže prebytočné korene z trávnika a zároveň odstráni mach a suchú trávu. Zabezpečí prevzdušnenie trávnika a podporí rast zdravej trávy.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(9,'Zemná vŕtačka',19.20,24.00,36.00,60.00,200.00,'Benzínovú zemnú vŕtačku môže pri jednoduchom vŕtaní do (tvrdej) zeme obsluhovať jedna osoba. Príslušné vrtáky s priemerom 80-100 a 150 mm sa prenajímajú samostatne.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(9,'Motorová kosa',13.60,17.00,25.50,42.50,225.00,'Benzínová motorová kosa má rezaciu hlavu, vďaka čomu je veľmi vhodná na kosenie buriny, vysokej trávy a slabšieho podrastu. Zariadenie disponuje redukciou vibrácií a dodáva sa s komfortným popruhom na zavesenie.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(9,'Pôdna fréza 800mm',39.20,49.00,73.50,122.50,250.00,'Táto benzínová záhradná fréza je vhodná na ľahké frézovanie a veľmi jednoducho sa používa. Zariadenie sa nachádza na poháňaných frézach, vďaka čomu sa pohybuje samostatne.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(9,'Reťazová píla 510mm',16.80,21.00,31.50,52.50,225.00,'Benzínová reťazová píla je vybavená zachytávačom reťaze, reťazovou brzdou, ochranou rúk a automatickým mazaním reťaze a je vhodná na pílenie palivového dreva. Je to ideálne zariadenie na pílenie stromov.')

--pr4--
INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(10,'Čistič kobercov',13.60,17.00,25.00,42.50,150.00,'Čistič kobercov na dôkladné čistenie kobercov a poťahov. Na čistenie nábytku a poťahov použite čistič kobercov v kombinácii so špeciálnym nadstavcom na nábytok. Špeciálne čistiace prostriedky dostanete vo vašom obchode so stavebninami.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(10,'Preťahovacie pero 15m',15.20,19.00,28.50,47.50,75.00,'Špirála na čistenie kanalizácií je vhodná na uvoľnenie kanalizačných a odpadových rúr s priemerom od 40 mm do maximálne 125 mm.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(10,'Vysokotlaká hadica',7.60,9.50,14.20,23.70,50.00,'Vysokotlaková hadica na uvoľnenie a vyčistenie kanalizačných a odpadových potrubí s priemerom od 40 do 100 mm. Používa sa výlučne v kombinácii s našim vysokotlakovým čističom.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(10,'Zariadenia na spriechodnenie odpadu',4.00,5.00,7.50,12.50,20.00,'Špirála na čistenie výleviek je vhodná na uvoľnenie odpadových rúr s priemerom od 32 mm do maximálne 50 mm.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(10,'Súprava na čistenie čalúnenia',8.00,10.00,15.00,25.00,40.00,'Filter na nábytok je v kombinácii s čističom čalúnenia ideálny na dôkladné čistenie nábytku alebo autosedačiek. Špeciálne čistiace prostriedky dostanete vo vašom obchode so stavebninami.')

--pr5--
INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(5,'Rezačka obkladov 900 mm',12.80,16.00,24.00,40.00,150.00,'Ideálna na rýchle, presné a bezprašné rezanie veľkých dlaždíc do 90 cm.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(5,'Rezačka na laminát 330 mm',9.60,12.00,18.00,30.00,125.00,'Pomocou rezačky na laminát môžete bezprašne, rýchlo a efektívne odrezať laminát a MDF dosky na požadovanú dĺžku.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(5,'Dierovač otvorov 35mm',4.60,6.00,9.00,15.00,20.00,'Tento dierovač otvorov pod batérie je vhodný na jednoduché vyrážanie otvorov so správnym priemerom do antikorového plechu.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit)
	VALUES(5,'Kladivo',4.40,5.50,8.25,13.75,30.00)

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit)
	VALUES(5,'Malé kladivo 5 kg',4.40,5.50,8.25,13.70,30.00)

--pr6--
INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(12,'Ochranné nohavice',4.80,6.00,9.00,15.00,30.00,'Ochranný oblek poskytuje vynikajúcu ochranu pri pílení a prerezávaní stromov.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(12,'Schodiskový rebrík',10.40,13.00,19.50,32.50,150.00,'Všetky nohy tohto schodiskového rebríka sa dajú nastaviť osobitne. Vďaka tomu je rebrík mimoriadne vhodný na bezpečnú prácu v situáciách s výškovým rozdielom, napríklad na schodiskách.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(12,'Ochranná prilba',4.80,6.00,9.00,15.00,30.00,'Táto kompletná bezpečnostná prilba je optimálnou ochranou vašej hlavy, tváre a uší. Túto prilbu odporúčame aj pri použití reťazových píl.')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(12,'Ručný vozík 6-kolesový',12.40,15.50,23.25,38.75,100.00,'Je určený na prepravu boxov, prepraviek a iných predmetov do maximálnej hmotnosti 200 kg. Ručný vozík so šiestimi masívnymi kolesami je riešením pre prepravu po rovných schodoch, obrubníkoch a prahoch')

INSERT INTO sch.product(id_categories,product_name,price_4h,price_1d,price_week,price_weekend,deposit,prod_description)
	VALUES(12,'Predlžovací kábel 230 V',4.00,6.00,9.00,15.00,30.00,'Náš predlžovací kábel 2,5 mm² zabraňuje strate napätia a zaistí bezpečné pracovné prostredie. Profesionálne stroje sú zvyčajne vybavené extrémne silnými motormi, ktoré vyžadujú veľa napätia, ktorému nevyhovuje bežný predlžovací kábel 1,5 mm².')



--CUSTOMERS--

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES('Samuel','Bujnak','Lipany','489','Lipany','samuelb@gmail.com',0908113377)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES('Daniel','Slosar','Majakovskeho','17','Kosice','daniels@gmail.com',0944897733)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Michaela','Hruzkova','Smotanova', '18', 'Bratislava','mich@arpy.com',0957903278)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Jozef','Slama','Bartakova','1622','Bratislava','josef@joure.com',0972240677)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Bozena','Novosadova','Pivovarska',' 601','Bratislava','bozena@tel.us',0960732459)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Denis','Hlavicka','Kosicka','20','Bratislava','denis@gmail.com',0944732478)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Dobromir','Novotny','Parska','18','Bratislava','dobro@gmail.com',0981732851)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Oliver','Smith','Janska','1','Kosice','olismith@gmail.com',0912755418)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Jakub','Lepny','Odranska','177','Petrovany','jakuble@gmail.com',0977755468)

INSERT INTO	sch.customer(customer_name,customer_surname,customer_address,customer_address_line,town,email,phone_num)
	VALUES	('Robert','Kosic','Tomasova','77','Presov','robert@gmail.com',0962755478)

--RESERVATIONS--

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(1,2,convert(DATETIME, '2022-02-10 10:00:00', 120),convert(DATETIME, '2022-02-10 18:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(2,1,convert(DATETIME, '2022-02-11 09:00:00', 120),convert(DATETIME, '2022-02-15 09:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(3,2,convert(DATETIME, '2022-02-20 11:00:00', 120),convert(DATETIME, '2022-02-25 11:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(6,3,convert(DATETIME, '2022-02-26 15:00:00', 120),convert(DATETIME, '2022-03-01 18:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(9,5,convert(DATETIME, '2022-03-09 10:00:00', 120),convert(DATETIME, '2022-03-09 12:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(18,5,convert(DATETIME, '2022-03-11 09:00:00', 120),convert(DATETIME, '2022-03-14 15:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(22,4,convert(DATETIME, '2022-03-15 15:00:00', 120),convert(DATETIME, '2022-03-16 11:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(31,3,convert(DATETIME, '2022-03-19 10:00:00', 120),convert(DATETIME, '2022-03-20 11:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(15,1,convert(DATETIME, '2022-03-20 16:00:00', 120),convert(DATETIME, '2022-03-22 19:00:00', 120))

INSERT INTO sch.reservation(id_product,id_customer,reserv_date_from,reserv_date_to)
	VALUES(29,1,convert(DATETIME, '2022-03-20 10:00:00', 120),convert(DATETIME, '2022-03-27 10:00:00', 120))