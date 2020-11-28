
--1. Utw�rz nowy schemat dml_exercises
CREATE SCHEMA dml_excercises;
--2. Utw�rz now� tabel� sales w schemacie dml_exercises wed�ug opisu:

DROP TABLE IF EXISTS dml_excercises.sales; 

CREATE TABLE dml_excercises.sales (
	id serial PRIMARY KEY,
	sales_date timestamp NOT NULL,
	sales_amount NUMERIC (38,2),
	sales_qty NUMERIC (10,2),
	added_by TEXT DEFAULT 'admin',
	CONSTRAINT sales_less_1k CHECK (sales_amount<=1000)
);

--3. Dodaj to tabeli kilka wierszy korzystaj�c ze sk�adni INSERT INTO

INSERT INTO dml_excercises.sales (id, sales_date, sales_amount, sales_qty, added_by)
	VALUES 	(1,'10-11-2010', 900, 2, 'admin'),
			(2,'20-11-2010', 800, 2, 'admin'),
			(3, '20-11-2010', 500, 30, 'admin');
		
--3.1 Tak, aby id by�o generowane przez sekwencj�

INSERT INTO dml_excercises.sales (sales_date, sales_amount, sales_qty)
	VALUES 	('10-11-2010', 200, 2);
		
		
--3.2 Tak by pod pole added_by wpisa� warto�� nieokre�lon� NULL

INSERT INTO dml_excercises.sales (id, sales_date, sales_amount, sales_qty, added_by)
	VALUES 	(8,'10-11-2010', 100, 2, NULL),
			(9,'20-11-2010', 900, 2, 'admin'),
			(10, '20-11-2010', 200, 30, 'admin');
--3.3 Tak, aby sprawdzi� zachowanie ograniczenia sales_less_1k, gdy wpiszemy warto�ci wi�ksz od 1000

INSERT INTO dml_excercises.sales (id, sales_date, sales_amount, sales_qty, added_by)
	VALUES 	(1422,'10-11-2010', 1000, 2, NULL),
			(1423,'20-11-2010', 9919, 2, 'admin'),
			(154, '20-11-2010', 10100, 30, 'admin');
		
--4. Co zostanie wstawione, jako format godzina (HH), minuta (MM), sekunda (SS), w polu
--sales_date, jak wstawimy do tabeli nast�puj�cy rekord.

INSERT INTO dml_excercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('20/11/2019 10:01:00', 101, 50, NULL);

--5. Jaka b�dzie warto�� w atrybucie sales_date, po wstawieniu wiersza jak poni�ej. Jak
--zintepretujesz miesi�c i dzie�, �eby mie� pewno��, o jaki konkretnie chodzi.
INSERT INTO dml_excercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('04/24/2020', 1701, 5100, NULL);

SHOW datestyle;
--Widzimy DMY

--6. Dodaj do tabeli sales wstaw wiersze korzystaj�c z poni�szego polecenia
INSERT INTO dml_excercises.sales (sales_date, sales_amount, sales_qty,added_by)
 SELECT NOW() + (random() * (interval '90 days')) + '30 days',
 random() * 500 + 1,
 random() * 100 + 1,
 NULL
 FROM generate_series(1, 20000) s(i);

--7. Korzystaj�c ze sk�adni UPDATE, zaktualizuj atrybut added_by, wpisuj�c mu warto��
'sales_over_200', gdy warto�� sprzeda�y (sales_amount jest wi�ksza lub r�wna 200)

UPDATE dml_excercises.sales 
   SET added_by = 'sales_over_200'
 WHERE sales_amount >= 200;

--8. Korzystaj�c ze sk�adni DELETE, usu� te wiersze z tabeli sales, dla kt�rych warto�� w polu
--added_by jest warto�ci� nieokre�lon� NULL. Sprawd� r�nic� mi�dzy zapisemm added_by =
--NULL, a added_by IS NULL

DELETE FROM dml_excercises.sales 
WHERE added_by = 'null';

DELETE FROM dml_excercises.sales 
WHERE added_by IS NULL;

--9. Wyczy�� wszystkie dane z tabeli sales i zrestartuj sekwencje

TRUNCATE TABLE dml_excercises.sales RESTART IDENTITY;


--10. DODATKOWE ponownie wstaw do tabeli sales wiersze jak w zadaniu 4.
--Utw�rz kopi� zapasow� tabeli do pliku. Nast�pnie usu� tabel� ze schematu dml_exercises i
--odtw�rz j� z kopii zapasowej.

pg_dump --host localhost ^
		--port 5432 ^
		--username postgres ^
		--format plain ^
		--clean ^
		--file "C:\Projects\PostgreSQL_dump\M5_L16_dml_excercises_COPY.copy" ^
		postgres
		
COPY dml_excercises.sales TO 'C:\Projects\PostgreSQL_dump\M5_L16_dml_excercises_COPY.copy';

COPY dml_excercises.sales FROM 'C:\Projects\PostgreSQL_dump\M5_L16_dml_excercises_COPY.copy';

