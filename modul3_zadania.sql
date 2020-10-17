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
