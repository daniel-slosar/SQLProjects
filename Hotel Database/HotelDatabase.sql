--Creation of Database--
CREATE database db_hotel
GO

USE db_hotel
GO

--Creation of scheme--
CREATE schema sch
GO

--Hotel Table--

CREATE TABLE	sch.hotel
(	id_hotel		INT				IDENTITY(1,1)
,	hotel_name			VARCHAR(20)		NOT NULL
,	hotel_address	VARCHAR(100)	NOT NULL
,	phone_number			NUMERIC(10,0)	NOT NULL
,	email			VARCHAR(20)		NOT NULL
,	hotel_desc	VARCHAR(200)	NOT NULL
,	CONSTRAINT	hotel_pk	PRIMARY KEY	(id_hotel)
,	CONSTRAINT	address_u1	UNIQUE	(hotel_address)
,	CONSTRAINT	phone_number_u2	UNIQUE	(phone_number)
,	CONSTRAINT	email_u3	UNIQUE	(email)
);

--Employees Table--

CREATE TABLE	sch.employees
(	id_employee	INT				IDENTITY(1,1)
,	id_hotel		INT				NOT NULL
,	employee_name			VARCHAR(20)		NOT NULL
,	employee_surname		VARCHAR(20)		NOT NULL
,	employee_address		VARCHAR(50)		NOT NULL
,	employee_position			VARCHAR(15)		NOT NULL
,	phone_number			NUMERIC(10,0)	NOT NULL
,	email			VARCHAR(20)		NOT NULL
,	OP				VARCHAR(7)		NOT NULL
,	gender		VARCHAR(1)		NOT NULL
,	personal_id		NUMERIC(10,0)	NOT NULL
,	CONSTRAINT	employee_pk	PRIMARY KEY	(id_employee)
,	CONSTRAINT	employeehotel_fk	FOREIGN KEY (id_hotel)	REFERENCES sch.hotel
,	CONSTRAINT	phone_numberemployee_u1	UNIQUE	(phone_number)
,	CONSTRAINT	emailemployee_u2	UNIQUE	(email)
,	CONSTRAINT	OPemployee_u3	UNIQUE	(OP)
,	CONSTRAINT	personalid_u4	UNIQUE	(personal_id)
)

--Customers Table--

CREATE TABLE	sch.customers
(	id_customer	INT				IDENTITY(1,1)
,	id_hotel	INT				NOT NULL
,	customer_name		VARCHAR(20)		NOT NULL
,	customers_surname	VARCHAR(20)		NOT NULL
,	customer_address		VARCHAR(50)		NULL
,	country		VARCHAR(30)		NULL
,	phone_number		NUMERIC(10,0)	NOT NULL
,	email		VARCHAR(20)		NOT NULL
,	OP			VARCHAR(7)		NOT NULL
,	card_number	NUMERIC(16,0)	NULL
,	food		VARCHAR(15)		NULL
,	note	VARCHAR(300)	NULL
,	CONSTRAINT	customer_pk	PRIMARY KEY	(id_customer)
,	CONSTRAINT	customerhotel_fk	FOREIGN KEY (id_hotel)	REFERENCES sch.hotel
,	CONSTRAINT	phone_numbercustomer_u1	UNIQUE	(phone_number)
,	CONSTRAINT	emailcustomer_u2	UNIQUE	(email)
,	CONSTRAINT	OPcustomer_u3	UNIQUE	(OP)
)

--tabulka izieb--

CREATE TABLE	sch.rooms
(	id_room			INT				IDENTITY(1,1)
,	id_hotel		INT				NOT NULL
,	room_type		VARCHAR(10)		NOT NULL
,	bed			NUMERIC(4,0)	NOT NULL
,	room_number		INT				NOT NULL
,	floor_number		NUMERIC(10,0)	NOT NULL
,	room_phone_number	NUMERIC(5,0)	NOT NULL
,	price			SmallMoney		NOT NULL
,	reviews		NUMERIC(5,0)	NOT NULL
,	room_state			BIT				NOT NULL
,	room_description			VARCHAR(100)	NULL
,	CONSTRAINT	room_pk	PRIMARY KEY	(id_room)
,	CONSTRAINT	roomshotel_fk	FOREIGN KEY (id_hotel)	REFERENCES sch.hotel
,	CONSTRAINT	room_number_u1	UNIQUE	(room_number)
,	CONSTRAINT	phone_numberrooms_u2	UNIQUE	(room_phone_number)
)

--tabulka rezervacii--

CREATE TABLE	sch.reservation
(	id_reservation	INT				IDENTITY(1,1)
,	id_hotel		INT				NOT NULL
,	id_room			INT				NOT NULL
,	id_employee	INT				NOT NULL
,	id_customer		INT				NOT NULL
,	room_state		BIT				NOT NULL
,	adult			NUMERIC(4,0)	NOT NULL
,	children			NUMERIC(4,0)	NOT NULL
,	reservation_date			DATETIME		NOT NULL
,	check_in		DATETIME		NOT NULL
,	check_out		DATETIME		NOT NULL
,	days_count		INT				NOT NULL
,	CONSTRAINT	reservation_pk	PRIMARY KEY	(id_reservation)
,	CONSTRAINT	reservationhotel_fk	FOREIGN KEY (id_hotel)	REFERENCES sch.hotel
,	CONSTRAINT	reservationroom_fk	FOREIGN KEY	(id_room)	REFERENCES sch.rooms
,	CONSTRAINT	reservationemployee_fk	FOREIGN KEY	(id_employee) REFERENCES sch.employees
,	CONSTRAINT	reservationcustomer_fk	FOREIGN KEY	(id_customer) REFERENCES sch.customers
,	CONSTRAINT	reservationdate_u1	UNIQUE	(reservation_date)
,	CONSTRAINT	roomstate_ch		CHECK	(room_state=1)
)

--tabulka platieb--

CREATE TABLE	sch.payment
(	id_payment		INT			IDENTITY(1,1)
,	id_room			INT			NOT NULL
,	id_customer		INT			NOT NULL
,	id_employee	INT			NOT NULL
,	payment_method	VARCHAR(20)	NOT NULL
,	payment_date	DATETIME	NOT NULL
,	final_price	SmallMoney	NOT NULL
,	CONSTRAINT	payment_pk	PRIMARY KEY	(id_payment)
,	CONSTRAINT	roompayment_fk	FOREIGN KEY	(id_room)	REFERENCES sch.rooms
,	CONSTRAINT	customerpayment_fk	FOREIGN KEY	(id_customer) REFERENCES sch.customers
,	CONSTRAINT	employeepayment_fk	FOREIGN KEY	(id_employee) REFERENCES sch.employees
)

--tabulka sluzieb--

CREATE TABLE	sch.services
(	id_sluzba	INT				IDENTITY(1,1)
,	id_hotel	INT				NOT NULL
,	id_customer	INT				NOT NULL
,	service_type			VARCHAR(15)		NOT NULL
,	date_time	DATETIME		NOT NULL
,	service_price	SmallMoney		NOT NULL
,	service_description		VARCHAR(100)	NULL
,	CONSTRAINT	services_pk	PRIMARY KEY	(id_sluzba)
,	CONSTRAINT	servicesotel_fk	FOREIGN KEY (id_hotel)	REFERENCES sch.hotel
,	CONSTRAINT	dateservices_u1	UNIQUE	(date_time)
)

--tabulka hodnoteni--

CREATE TABLE	sch.reviews
(	id_review	INT				IDENTITY(1,1)
,	id_hotel		INT				NOT NULL
,	id_customer		INT				NOT NULL
,	reviews		NUMERIC(10,0)	NULL
,	note		VARCHAR(50)		NULL
,	CONSTRAINT	reviews_pk	PRIMARY KEY	(id_review)
,	CONSTRAINT	reviewhotel_fk	FOREIGN KEY (id_hotel)	REFERENCES sch.hotel
,	CONSTRAINT	cusomerreview_fk		FOREIGN KEY	(id_customer)	REFERENCES sch.customers
)

--ALTER TABLE--

ALTER TABLE sch.employees ADD salary SmallMoney NOT NULL
ALTER TABLE sch.reservation	ADD price	SmallMoney	NOT NULL
ALTER TABLE sch.reviews	ALTER COLUMN	note	VARCHAR(100)	NULL

ALTER TABLE sch.reviews
    ADD id_customer INT
    CONSTRAINT customerservices_fk 
        FOREIGN KEY (id_customer) 
        REFERENCES sch.customers(id_customer)
;

-- select from--

SELECT* FROM sch.employees
SELECT* FROM sch.customers
SELECT* FROM sch.rooms
SELECT* FROM sch.reservation
SELECT* FROM sch.payment
SELECT*	FROM sch.services
SELECT* FROM sch.reviews


--SELECT WHERE ORDER BY--

SELECT employee_name,employee_surname,salary
	FROM sch.employees
	WHERE ABS(salary) >= 1000
	ORDER BY salary ASC

SELECT service_type,service_price
	FROM sch.services
	WHERE ABS(service_price) >= 20
	ORDER BY service_price ASC

SELECT id_customer,id_room,check_in,check_out,days_count
	FROM sch.reservation
	ORDER BY check_out DESC

--GROUP BY--

SELECT employee_name,employee_surname,employee_position
	FROM sch.employees
	WHERE gender = 'M'
	GROUP BY employee_name,employee_surname, employee_position
	ORDER BY employee_name,employee_surname, employee_position

SELECT room_type,price
	FROM sch.rooms
	GROUP BY room_type,price

SELECT payment_method, COUNT(*)
	FROM sch.payment
	GROUP BY payment_method;

SELECT room_type, SUM(bed)
	FROM sch.rooms
	GROUP BY room_type
	HAVING SUM(bed)>3;


SELECT *from sch.reviews where review IN('2','4','6','8')  

SELECT *from sch.customers where customer_name LIKE'D%' ORDER BY customer_name desc

SELECT employee_name+' '+employee_surname as full_name from sch.employees as k




--INSERT INTO HOTEL Table--

INSERT INTO sch.hotel(hotel_name,hotel_address,phone_number,email,hotel_desc)
	VALUES	('Luxury Hotel','Vajanskeho 17, 078 02 Bratislava, Slovensko',0908448866,'luxury@hotel.com','Hotel ponuka 200 izieb s celkovou kapacitou 420 lozok.Perfektny vyhlad na Dunaj...')


--INSERT INTO Employees--

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Daniel','Slosar','Riaditel','Majanskeho 18, 081 14 Bratislava',0971935555,'querhkvg@gmail.com','GK48776','M','9344152846',1500)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Samuel','Bujnak','Manager','Prikopova 1, 025 14 Bratislava',0946318558,'svqfluad@gmail.com','YW81663','M','7077625038',1300)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Jan','Baudys','Kuchar','Mladna 13, 080 15 Bratislava',0914638733,'bzisrpjd@gmail.com','PM78184','M','3615294702',1100)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Frantisek','Kysela','Recepcny','Ilova 88, 088 84 Bratislava',0998342155,'hiotnqqs@gmail.com','TX41417','M','9521226160',900)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Radka','Cerna','Recepcna','Galilova 08, 071 12 Bratislava',0930330309,'xqmlculq@gmail.com','RT63296','Z','3905984808',900)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Janka','Maskova','HR manager','Liptova 44 080 15 Bratislava',0983204189,'evcjivxo@gmail.com','JU52439','Z','8512952876',1000)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Viktorie ','Hankova','Maserka','Madna 55 082 14 Bratislava',0923078529,'apfkpksv@gmail.com','RQ93719','Z','7971112054',950)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Stefan','Tvrdy','Vratnik','Komenskeho 55, 081 14 Bratislava',0952183564,'llyjgylf@gmail.com','WF20976','M','1936514317',850)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Veronika','Mickova','Upratovacka','Prievozska 11, 080 11 Bratislava',0945768117,'osuhqngp@gmail.com','QF12224','Z','7501886218',650)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Iva','Drdova','Casnicka','Richtarova 8, 080 04 Bratislava',0958289153,'hcblixym@gmail.com','HQ46003','Z','7159142010',790)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Vladimir','Gamco','Security','Tyrsova 1002, 083 12 Bratislava',0973060205,'vladimirg@arpy.com','XR22605','M','6130295408',1050)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Eliska','Machatova','Pomocna sila','Navagrova 1, 025 24 Bratislava',0972914359,'eliskam@arpy.com','GS27023','Z','7807629527',550)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Michaela','Hruzkova','Kucharka','Smotanova 18, 085 75 Bratislava',0957903278,'michaelah@arpy.com','VR25111','Z','7601745991',650)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Jozef','Slama','Vodic','Bartakova 1622, 798 03 Bratislava',0972240677,'josefs@jourapide.com','MA96485','M','1091619761',700)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Bozena','Novosadova','Ekonomka','Pivovarska 601, 064 52 Bratislava',0960732459,'bozenan@teleworm.us','JR19857','Z','8277884369',900)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Lubomir','Vedral','Manazer predaja','Druzstevna 515, 087 01 Bratislava',0937658718,'lubomirv@teleworm.us','AX52213','M','6158029180',1000)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Martin','Ondruska','Obsluha izby','Zahradna 340, 085 04 Bratislava',0908661174,'martino@dayrep.com','EA11707','M','7087419019',650)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Lucia','Schneiderova','Udrzbar','Masarykova 1044, 083 01 Bratislava',0905183564,'luciasch@gmail.com','QY98375','Z','3975298793',700)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Julia','Hromadkova','Veduci oddel','Bezrucova 617, 088 25 Bratislava',0973451632,'juliahr@rhyta.com','LP59788','Z','1343915470',1100)

INSERT INTO sch.employees(id_hotel,employee_name, employee_surname,employee_position,employee_address,phone_number,email,OP,gender,personal_id,salary)
	VALUES	(1,'Ladislav','Malik','Nocny auditor','Sokolska 1168, 075 04 Bratislava',0928370559,'ladmalik@gmail.com','TX62238','M','6726691424',800)
	

--INSERT INTO Customers--

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
	VALUES (1,'Robert','Daliborsky',0908604966,'robertd@gmail.com','HE45632','vecera')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,note)
	VALUES (1,'Dalibor','Guman',0988655861,'lhihllculx@gmail.com','GG23705','+pes')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
	VALUES (1,'Oliver','Lomecky',0991860496,'wctzni@gmail.com','MN39002','Taliansko')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
	VALUES (1,'Martin','Dansky',0919605077,'nauedg@gmail.com','GE73245','ranajky')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP)
	VALUES (1,'Simeon','Porta',0944644556,'txgntn@gmail.com','CG24670')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
	VALUES (1,'Jakub','Hulich',0987621956,'xenkja@gmail.com','QE64883','Nemecko')
	
INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
	VALUES (1,'Kristof','Kirtof',0988682316,'quqmpv@gmail.com','RS66889','Ucountry')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
	VALUES (1,'Juraj','Dudah',0948654116,'wawpyr@gmail.com','LL44472','obed')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
	VALUES (1,'Jan','Krivy',0940116616,'hqrthjmv@gmail.com','QE99744','Cesko')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
	VALUES (1,'Peter','Dlhy',0947441122,'adsfgfg@gmail.com','GG46472','obed')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
    VALUES (1,'Samuel','Daliborsky',0958784960,'samdal@gmail.com','HH95632','vecera')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,note)
    VALUES (1,'Dalibor','Samuelsky',0968289236,'lfssvvvv@gmail.com','GD37055','+tiger')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
    VALUES (1,'Oliver','Lukac',0971653155,'oliluk@gmail.com','MA78002','Ucountry')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
    VALUES (1,'Martin','Macek',0980659922,'nautteew@gmail.com','GM78245','ranajky')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP)
    VALUES (1,'Alex','Porta',0957710571,'alexport@gmail.com','CF78670')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
    VALUES (1,'Peter','Horvath',0981025925,'peretfa@gmail.com','QE64841','Nemecko')
    
INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
    VALUES (1,'Kristof','Kolumbus',0965044254,'kristfoqq@gmail.com','HS45889','Morava')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
    VALUES (1,'Jozef','Lamac',0933358396,'jozlamac@gmail.com','JL45472','olovrant')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,country)
    VALUES (1,'Jan','Kral',0943721248,'kralj@gmail.com','EE59744','Slovensko')

INSERT INTO sch.customers(id_hotel,meno, customers_surname, phone_number, email, OP,food)
    VALUES (1,'Daniel','Bot',0917244271,'aaakglwqg@gmail.com','HG44972','vecera')


--INSERT INTO Rooms--

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state,service_description)
	VALUES(1,'Apartman', 4,180,7,44180,250,5,1,'Apartman pre ludi ktory si potrpia na pohodli')

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state)
	VALUES(1,'Apartman', 3,188,8,44188,230,5,0)

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state)
	VALUES(1,'Apartman', 2,195,9,44195,220,5,1)

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state)
	VALUES(1,'Apartman', 1,200,10,44200,210,5,0)

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state)
	VALUES(1,'Standard', 1,150,6,44150,89,6,0)

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state,service_description)
	VALUES(1,'Standard', 2,130,5,44130,99,3,0,'Standardna izba pre ubytovanych ludi')

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state)
	VALUES(1,'Standard', 3,111,4,44111,110,4,1)

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state)
	VALUES(1,'Standard', 4,89,3,44890,120,3,0)

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state)
	VALUES(1,'Suita', 4,11,2,44110,66,2,0)

INSERT INTO sch.rooms(id_hotel,room_type,bed,room_number,floor_number,room_phone_number,price,reviews,room_state,service_description)
	VALUES(1,'Suita', 3,22,1,44220,55,3,1,'Suita ponuka jedinecny zazitok pre 3 osoby')


--INSERT INTO reviews--

INSERT INTO sch.reviews(id_hotel,id_customer,reviews,note)
	VALUES(1,1,2,'Otrasny pristup obsluhy')

INSERT INTO sch.reviews(id_hotel,id_customer,reviews)
	VALUES(1,3,4)

INSERT INTO sch.reviews(id_hotel,id_customer,reviews,note)
	VALUES(1,7,6,'Skoda zavreteho wellness')

INSERT INTO sch.reviews(id_hotel,id_customer,reviews)
	VALUES(1,5,8)

INSERT INTO sch.reviews(id_hotel,id_customer,reviews,note)
	VALUES(1,2,10,'Najlepsi hotel v okoli, prijemna obsluha')
	
INSERT INTO sch.reviews(id_hotel,id_customer,reviews)
    VALUES(1,4,11)
    
INSERT INTO sch.reviews(id_hotel,id_customer,reviews)
    VALUES(1,6,12)
    
INSERT INTO sch.reviews(id_hotel,id_customer,reviews)
    VALUES(1,9,13)
    
INSERT INTO sch.reviews(id_hotel,id_customer,reviews)
    VALUES(1,10,14)

INSERT INTO sch.reviews(id_hotel,id_customer,reviews)
	VALUES(1,11,8,'Super ubytko')
    

--INSERT INTO sluzby--

INSERT INTO sch.services(id_hotel,id_customer,service_type,date_time,service_price)
	VALUES(1,1,'Masaz',convert(DATETIME, '2021-02-05 13:20:12', 120),30)

INSERT INTO sch.services(id_hotel,id_customer,service_type,date_time,service_price,service_description)
	VALUES(1,7,'Sauna',convert(DATETIME, '2021-07-11 14:00:00', 120),30,'Finska sauna')

INSERT INTO sch.services(id_hotel,id_customer,service_type,date_time,service_price)
	VALUES(1,6,'Bahnovy kupel',convert(DATETIME, '2021-12-10 11:15:00', 120),25)

INSERT INTO sch.services(id_hotel,id_customer,service_type,date_time,service_price)
	VALUES(1,9,'Fitness',convert(DATETIME, '2021-05-09 17:45:00', 120),3)

INSERT INTO sch.services(id_hotel,id_customer,service_type,date_time,service_price)
	VALUES(1,11,'Herna',convert(DATETIME, '2021-08-05 22:00:00', 120),5)


--INSERT INTO Reservation--

INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,13,14,4,1,2,0,convert(DATETIME, '2020-02-05 13:48:12', 120),convert(DATETIME, '2020-02-10 18:00:00', 120),convert(DATETIME, '2020-02-15 10:00:00', 120),5,90)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,15,18,3,1,4,2,convert(DATETIME, '2020-05-06 18:44:02', 120),convert(DATETIME, '2020-05-07 12:00:00', 120),convert(DATETIME, '2020-05-08 10:00:00', 120),1,89)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,16,13,1,1,3,1,convert(DATETIME, '2020-04-01 08:33:12', 120),convert(DATETIME, '2020-04-10 11:00:00', 120),convert(DATETIME, '2020-04-14 10:00:00', 120),4,77)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,18,19,7,1,2,2,convert(DATETIME, '2020-03-08 17:29:01', 120),convert(DATETIME, '2020-02-10 10:00:00', 120),convert(DATETIME, '2020-02-12 10:00:00', 120),2,200)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,21,22,5,1,1,0,convert(DATETIME, '2020-01-10 22:28:11', 120),convert(DATETIME, '2020-02-05 15:00:00', 120),convert(DATETIME, '2020-02-15 10:00:00', 120),10,150)

INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,12,14,6,1,1,0,convert(DATETIME, '2020-05-05 13:48:12', 120),convert(DATETIME, '2020-05-10 18:00:00', 120),convert(DATETIME, '2020-02-15 10:00:00', 120),5,80)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,14,18,9,1,3,2,convert(DATETIME, '2020-12-02 12:44:02', 120),convert(DATETIME, '2020-12-10 12:00:00', 120),convert(DATETIME, '2020-12-12 10:00:00', 120),1,84)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,17,13,10,1,2,1,convert(DATETIME, '2020-07-01 08:33:12', 120),convert(DATETIME, '2020-07-05 11:00:00', 120),convert(DATETIME, '2020-07-19 10:00:00', 120),4,66)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,19,19,11,1,2,2,convert(DATETIME, '2020-06-08 17:29:01', 120),convert(DATETIME, '2020-06-28 10:00:00', 120),convert(DATETIME, '2020-06-30 10:00:00', 120),2,205)
	
INSERT INTO sch.reservation(id_hotel,id_room,id_employee,id_customer,room_state,adult,children,reservation_date,check_in,check_out,days_count,price)
	VALUES(1,11,20,23,1,1,0,convert(DATETIME, '2020-03-05 22:28:11', 120),convert(DATETIME, '2020-03-10 15:00:00', 120),convert(DATETIME, '2020-03-13 10:00:00', 120),10,110)

DELETE FROM sch.reservation WHERE days_count=10
DELETE FROM sch.reservation WHERE days_count=2


--INSERT INTO Payment--

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(12,5,13,'Platba kartou',convert(DATETIME, '2020-02-10 17:44:41', 120),98)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(21,6,22,'Platba kartou',convert(DATETIME, '2020-05-07 11:10:38', 120),220)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(13,7,17,'CASH',convert(DATETIME, '2020-04-14 14:50:33', 120),190)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(14,4,15,'Platba prevodom',convert(DATETIME, '2020-03-14 18:02:25', 120),66)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(15,9,20,'CASH',convert(DATETIME, '2020-01-15 10:11:47', 120),110)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(12,3,13,'Platba kartou',convert(DATETIME, '2020-12-12 17:44:41', 120),120)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(21,1,22,'Platba kartou',convert(DATETIME, '2020-06-12 11:10:38', 120),86)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(13,10,17,'CASH',convert(DATETIME, '2020-07-14 14:50:33', 120),170)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(14,11,15,'Platba prevodom',convert(DATETIME, '2020-02-12 18:02:25', 120),56)

INSERT INTO sch.payment(id_room,id_customer,id_employee,payment_method,payment_date,final_price)
	VALUES(15,9,20,'CASH',convert(DATETIME, '2020-09-21 10:11:47', 120),115)