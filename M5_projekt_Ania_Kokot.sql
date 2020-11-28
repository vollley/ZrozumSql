--1
DROP ROLE IF EXISTS expense_tracker_user;
CREATE ROLE expense_tracker_user WITH LOGIN PASSWORD 'U$er_Tracker1';
--2

REVOKE CREATE ON SCHEMA public FROM PUBLIC; 
--3

DROP SCHEMA IF EXISTS expense_tracker CASCADE;

--4
CREATE ROLE expense_tracker_group; 

--5
CREATE SCHEMA IF NOT EXISTS expense_tracker AUTHORIZATION expense_tracker_group;

--6
GRANT CONNECT ON DATABASE postgres TO expense_tracker_group; 
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA expense_tracker TO expense_tracker_group;

--7
GRANT expense_tracker_group TO expense_tracker_user;

--8
CREATE SCHEMA IF NOT EXISTS expense_tracker;

--9, 10
DROP TABLE IF EXISTS expense_tracker.users CASCADE;

CREATE TABLE IF NOT EXISTS expense_tracker.users (
	id_user serial PRIMARY KEY,
	user_login varchar(25) NOT NULL, 
	user_name varchar(50) NOT NULL, 
	user_password varchar(100) NOT NULL, 
	password_salt varchar(100) NOT NULL, 
	active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 

DROP TABLE IF EXISTS expense_tracker.transaction_type;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_type (
	id_trans_type serial PRIMARY KEY,
	transaction_type_name varchar(50) NOT NULL, 
	transaction_type_desc varchar(250),
	active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 


DROP TABLE IF EXISTS expense_tracker.transaction_category;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_category (
	id_trans_cat serial PRIMARY KEY,
	category_name varchar(50) NOT NULL, 
	category_description varchar(250), 
    active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 


DROP TABLE IF EXISTS expense_tracker.transaction_subcategory;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_subcategory (
	id_trans_subcat serial PRIMARY KEY,
	id_trans_cat integer,
	FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category (id_trans_cat),
	subcategory_name varchar(50) NOT NULL, 
	subcategory_description varchar(250),
	active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 

DROP TABLE IF EXISTS expense_tracker.bank_account_owner;

CREATE TABLE expense_tracker.bank_account_owner (
	id_ba_own serial PRIMARY KEY,
	owner_name varchar(50) NOT null,
	owner_desc varchar(250),
	user_login integer NOT NULL, 
	active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 

DROP TABLE IF EXISTS expense_tracker.bank_account_types;

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_types (
	id_ba_type serial PRIMARY KEY,
	ba_type varchar(50) NOT NULL, 
	ba_desc varchar(250),
	active boolean DEFAULT TRUE NOT NULL,
	is_common_account boolean NOT NULL DEFAULT FALSE, 
	id_ba_own integer,
	FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner (id_ba_own),
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 


DROP TABLE IF EXISTS expense_tracker.transaction_bank_accounts;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_bank_accounts (
	id_trans_ba serial PRIMARY KEY,
	id_ba_own integer,
	FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner (id_ba_own),
	id_ba_typ integer, 
	FOREIGN KEY (id_ba_typ) REFERENCES expense_tracker.bank_account_types (id_ba_type),
	bank_account_name varchar(50) NOT NULL, 
	bank_account_desc varchar(250),
	active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 


DROP TABLE IF EXISTS expense_tracker.transactions;

CREATE TABLE IF NOT EXISTS expense_tracker.transactions ( 
	id_transaction serial PRIMARY KEY,
	id_trans_ba integer,
	FOREIGN KEY (id_trans_ba) REFERENCES expense_tracker.transaction_bank_accounts (id_trans_ba),
	id_trans_cat integer,
	FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category (id_trans_cat),
	id_trans_subcat integer,
	FOREIGN KEY (id_trans_subcat) REFERENCES expense_tracker.transaction_subcategory (id_trans_subcat),
	id_trans_type integer,
	FOREIGN KEY (id_trans_type) REFERENCES expense_tracker.transaction_type (id_trans_type),
	id_user integer,
	FOREIGN KEY (id_user) REFERENCES expense_tracker.users (id_user),
	transaction_date date DEFAULT current_date,  
	transaction_value numeric (9,2),
	transaction_description TEXT,
	insert_date timestamp DEFAULT current_timestamp,
	update_date timestamp DEFAULT current_timestamp
);

--insert into table_name: users
INSERT INTO expense_tracker.users (user_login, user_name, user_password, password_salt, active)
		VALUES ('akokot', 'Anna Kokot', '$Haj$2020', '??', TRUE );

--INSERT into table_name: transaction_type

INSERT 	INTO expense_tracker.transaction_type (transaction_type_name, transaction_type_desc, active)
		VALUES 	('przelew przychodz¹cy', 'Pensja', TRUE),
				('Karta debetowa', 'P³atnoœæ sklep spo¿yczywczy', TRUE),
				('przelew wychodz¹cy', 'Op³ata UPC', TRUE); 


--INSERT into table_name: transaction_category
INSERT 	INTO expense_tracker.transaction_category (category_name, category_description ,active)
		VALUES 	('¯ywnoœæ', 'Biedronka', TRUE),
				('Rachunki', 'UPC', TRUE),
				('Edukacja', 'Kurs', TRUE),
				('Rachunki', 'Czynsz', TRUE),
				('Knajpy', 'Kawa', TRUE);


--INSERT into table_name: transaction_subcategory
INSERT 	INTO expense_tracker.transaction_subcategory (id_trans_cat, subcategory_name, subcategory_description, active)
		VALUES  (1, 'Owoce', 'Jab³ka, gruszki, œliwki', TRUE),
				(2, 'Warzywa', 'Ziemniaki, marchew, kalafior', TRUE),
				(3, 'Napoje bezalkoholowe', 'Cola, piwo bezalko', TRUE);

--INSERT into table_name: bank_account_owner
INSERT  INTO expense_tracker.bank_account_owner (owner_name, owner_desc, user_login, active)
		VALUES ('Anna Kokot', 'moje', 1, TRUE),
				('Anna Kokot', 'wspólne', 2, TRUE);
 

--INSERT into table_name: bank_account_types
INSERT 	INTO expense_tracker.bank_account_types (ba_type, ba_desc, active, is_common_account)
		VALUES 	('Alior', 'Karta debetowa', TRUE, TRUE),
				('Millenium', 'Karta Debetowa', TRUE, FALSE);

--INSERT into table_name: transaction_bank_accounts
INSERT INTO  expense_tracker.transaction_bank_accounts (id_ba_own, id_ba_typ, bank_account_name, bank_account_desc, active)
		VALUES (1, 1, 'Millenium', 'Konto 360', TRUE);
		

--INSERT into table_name: transactions

INSERT INTO expense_tracker.transactions (id_trans_ba,  id_trans_cat, id_trans_subcat, id_trans_type, id_user, transaction_date , transaction_value , transaction_description)
		VALUES (1, 1, 1, 1, 1, '18/11/2020', 20.97,'zakupy biedronka' );
		

-- kopia zapasowa bazy danych

        
pg_dump --host localhost ^
		--port 5432 ^
		--username postgres ^
		--format plain ^
		--clean ^
		--file "C:\Projects\PostgreSQL_dump\db_expense_tracker.sql" ^
		postgres
		
-- przywrócenie kopii zapasowej

pg_restore --host localhost ^
           --port 5432 ^
           --username postgres ^
           --dbname postgres ^
           --clean ^
           "C:\Projects\PostgreSQL_dump\db_expense_tracker"
psql -U postgres -p 5432 -h localhost -d postgres -f "C:\Projects\PostgreSQL_dump\db_expense_tracker.sql"

		

