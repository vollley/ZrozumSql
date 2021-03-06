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
	sales_date timestamp NOT NULL, 
	sales_amount decimal (38,2),
	sales_qty decimal (10,2),
	product_id integer,
	added_by TEXT DEFAULT 'admin',
	CONSTRAINT sales_over_1k CHECK (sales_amount>1000)
);
 
ALTER TABLE products ADD CONSTRAINT sales FOREIGN KEY(id)
REFERENCES sales (id)
ON DELETE CASCADE;

DROP SCHEMA training_zs CASCADE;
