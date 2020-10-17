CREATE SCHEMA training;

ALTER SCHEMA training RENAME TO training_zs;

CREATE TABLE products(
			id integer,	
			production_qty DECIMAL (10, 2),
			product_name varchar (100),
			product_code varchar (10),
			description TEXT, 
			manufacturing_date date
); 

ALTER TABLE products ADD PRIMARY KEY (id); 

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
	id integer PRIMARY KEY,
	sales_date
	sales_amount,
	sales_qty
	product_id
	added_by
	CHECK sales_over_1k sales_amount_typ (sales_amount>1000)
);

id - typ ca�kowity, klucz g��wny,
? sales_date - typ data i czas (data + cz�� godziny, minuty, sekundy), to pole ma nie zawiera�
warto�ci nieokre�lonych NULL,
? sales_amount - typ zmiennoprzecinkowy (NUMERIC 38 znak�w, do 2 znak�w po przecinku)
? sales_qty - typ zmiennoprzecinkowy (NUMERIC 10 znak�w, do 2 znak�w po przecinku)
? product_id - typ ca�kowity INTEGER
? added_by - typ tekstowy (nielimitowana ilo�� znak�w), z warto�ci� domy�ln� 'admin'
UWAGA: nie ma tego w materia�ach wideo. Przeczytaj o atrybucie DEFAULT dla kolumny
https://www.postgresql.org/docs/12/ddl-default.html
? Korzystaj�c z definiowania przy tworzeniu tabeli, po definicji kolumn, dodaje ograniczenie o
nazwie sales_over_1k na polu sales_amount typu CHECK takie, �e warto�ci w polu
sales_amount musz� by� wi�ksze od 1000

