--1

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
REASSIGN OWNED BY expense_tracker_group TO expense_tracker_user;

--8
CREATE SCHEMA IF NOT EXISTS expense_tracker;

--9, 10
DROP TABLE IF EXISTS expense_tracker.users;

CREATE TABLE IF NOT EXISTS expense_tracker.users (
	id_user integer PRIMARY KEY,
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
	id_trans_type integer PRIMARY KEY,
	transaction_type_name varchar(50) NOT NULL, 
	transaction_type_desc varchar(250),
	active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 


DROP TABLE IF EXISTS expense_tracker.transaction_category;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_category (
	id_trans_cat integer PRIMARY KEY,
	category_name varchar(50) NOT NULL, 
	category_description varchar(250), 
    active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 


DROP TABLE IF EXISTS expense_tracker.transaction_subcategory;

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_subcategory (
	id_trans_subcat integer PRIMARY KEY,
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
	id_ba_own integer PRIMARY KEY,
	owner_name varchar(50) NOT null,
	owner_desc varchar(250),
	user_login integer NOT NULL, 
	active boolean DEFAULT TRUE NOT NULL, 
	insert_date timestamp DEFAULT CURRENT_TIMESTAMP,
	update_date timestamp DEFAULT CURRENT_TIMESTAMP
); 

DROP TABLE IF EXISTS expense_tracker.bank_account_types;

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_types (
	id_ba_type integer PRIMARY KEY,
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
	id_trans_ba integer PRIMARY KEY,
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
	id_transaction integer PRIMARY KEY,
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





