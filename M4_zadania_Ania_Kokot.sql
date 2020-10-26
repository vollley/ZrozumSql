--1
CREATE ROLE user_training WITH LOGIN PASSWORD '$Zpagat3';

--2
CREATE SCHEMA training AUTHORIZATION user_training;

--3
DROP ROLE user_training;

--4
REASSIGN OWNED BY user_training TO postgres;
DROP ROLE user_training;

--5
CREATE ROLE reporting_ro;
GRANT CONNECT ON DATABASE postgres TO reporting_ro;
GRANT USAGE ON SCHEMA training TO reporting_ro;
GRANT CREATE ON SCHEMA training TO reporting_ro;
GRANT ALL PRIVILEGES ON ALL TABLEs IN SCHEMA training TO reporting_ro;

--6
CREATE ROLE reporting_user WITH LOGIN PASSWORD 'WarSaw2020!';

--7
CREATE TABLE training.new_table (id serial);

--8
REASSIGN OWNED BY reporting_ro TO user_training;

--9
CREATE TABLE public.test_table (id serial);



