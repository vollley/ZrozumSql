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

id - typ ca³kowity, klucz g³ówny,
? sales_date - typ data i czas (data + czêœæ godziny, minuty, sekundy), to pole ma nie zawieraæ
wartoœci nieokreœlonych NULL,
? sales_amount - typ zmiennoprzecinkowy (NUMERIC 38 znaków, do 2 znaków po przecinku)
? sales_qty - typ zmiennoprzecinkowy (NUMERIC 10 znaków, do 2 znaków po przecinku)
? product_id - typ ca³kowity INTEGER
? added_by - typ tekstowy (nielimitowana iloœæ znaków), z wartoœci¹ domyœln¹ 'admin'
UWAGA: nie ma tego w materia³ach wideo. Przeczytaj o atrybucie DEFAULT dla kolumny
https://www.postgresql.org/docs/12/ddl-default.html
? Korzystaj¹c z definiowania przy tworzeniu tabeli, po definicji kolumn, dodaje ograniczenie o
nazwie sales_over_1k na polu sales_amount typu CHECK takie, ¿e wartoœci w polu
sales_amount musz¹ byæ wiêksze od 1000

