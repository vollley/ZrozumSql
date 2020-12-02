DROP TABLE IF EXISTS products;

CREATE TABLE dml_excercises.products (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO dml_excercises.products (product_name, product_code, product_quantity,
manufactured_date)
 	SELECT 	'Product '||floor(random() * 10 + 1)::int,
 			'PRD'||floor(random() * 10 + 1)::int,
 			random() * 10 + 1,
 			CAST((NOW() - (random() * (interval '90 days')))::timestamp AS date)
 	FROM generate_series(1, 10) s(i);

DROP TABLE IF EXISTS sales;

CREATE TABLE dml_excercises.sales (
	id SERIAL,
	sal_description TEXT,
	sal_date DATE,
	sal_value NUMERIC(10,2),
	sal_qty NUMERIC(10,2),
	sal_product_id INTEGER,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO dml_excercises.sales (sal_description, sal_date, sal_value, sal_qty, sal_product_id)
 	SELECT left(md5(i::text), 15),
 		CAST((NOW() - (random() * (interval '60 days'))) AS DATE),
 		random() * 100 + 1,
 		floor(random() * 10 + 1)::int,
 		floor(random() * 10)::int
 	FROM generate_series(1, 10000) s(i);

--1. Wyświetl unikatowe daty stworzenia produktów (według atrybutu manufactured_date)
SELECT DISTINCT products.manufactured_date 
FROM dml_excercises.products;

--2. Jak sprawdzisz czy 10 wstawionych produktów to 10 unikatowych kodów produktów?

--nie mam pomysłu, jak zrobic to jedną komendą

SELECT products.product_code
FROM dml_excercises.products;

SELECT product_code 
FROM dml_excercises.products;

--3. Korzystając ze składni IN wyświetl produkty od kodach PRD1 i PRD9
SELECT products.product_name, products.product_code 
FROM dml_excercises.products 
WHERE product_code IN ('PRD1', 'PRD9');


--4. Wyświetl wszystkie atrybuty z danych sprzedażowych, takie że data sprzedaży jest w
--zakresie od 1 sierpnia 2020 do 31 sierpnia 2020 (włącznie). Dane wynikowe mają być
--posortowane według wartości sprzedaży malejąco i daty sprzedaży rosnąco.
--Nie było danych za sierpień, zmieniłam to na wrzesień. 
SELECT * 
FROM dml_excercises.sales
WHERE sales.sal_date > '2020/09/01' AND sales.sal_date <= '2020/09/30'
ORDER BY sales.sal_date ASC, sales.sal_qty DESC; 


--5. Korzystając ze składni NOT EXISTS wyświetl te produkty z tabeli PRODUCTS, które nie
--biorą udziału w transakcjach sprzedażowych (tabela SALES). ID z tabeli Products i
--SAL_PRODUCT_ID to klucz łączenia.

SELECT p.* 
FROM dml_excercises.products p
WHERE NOT EXISTS (SELECT 1
						FROM dml_excercises.sales s
						WHERE s.sal_product_id = p.id) ;

--6. Korzystając ze składni ANY i operatora = wyświetl te produkty, których występują w
--transakcjach sprzedażowych (według klucza Products ID, Sales SAL_PRODUCT_ID)
--takich, że wartość sprzedaży w transakcji jest większa od 100

SELECT *
FROM dml_excercises.products 
WHERE COALESCE (product_code,'')
				= ANY (SELECT coalesce (product_code,'')
 				FROM sales
				WHERE products.id = sales.sal_product_id
				AND sal_value>100);
			
--czy może powinnien być SELECT DISTINTC (tak jak poniżej)?			
SELECT *
FROM dml_excercises.products 
WHERE COALESCE (product_code,'')
				= ANY (SELECT DISTINCT coalesce (product_code,'')
 				FROM dml_excercises.sales
				WHERE products.id = sales.sal_product_id
				AND sal_value>100);	
			
--7. Stwórz nową tabelę PRODUCTS_OLD_WAREHOUSE o takich samych kolumnach jak
--istniejąca tabela produktów (tabela PRODUCTS). Wstaw do nowej tabeli kilka wierszy -
--dowolnych według Twojego uznania.

CREATE TABLE dml_excercises.products_old_warehouse (
	id SERIAL,
	product_name VARCHAR(100),
	product_code VARCHAR(10),
	product_quantity NUMERIC(10,2),
	manufactured_date DATE,
	added_by TEXT DEFAULT 'admin',
	created_date TIMESTAMP DEFAULT now()
);

INSERT INTO dml_excercises.products_old_warehouse (product_name, product_code, product_quantity,
manufactured_date)
 	SELECT 	'Product '||floor(random() * 1 + 5)::int,
 			'PRD'||floor(random() * 5 + 1)::int,
 			random() * 5 + 1,
 			CAST((NOW() - (random() * (interval '90 days')))::timestamp AS date)
 	FROM generate_series(1, 5) s(i);
 
 SELECT * 
 FROM dml_excercises.products_old_warehouse;

 SELECT * 
 FROM dml_excercises.products;
--8. Na podstawie tabeli z zadania 7, korzystając z operacji UNION oraz UNION ALL połącz
--tabelę PRODUCTS_OLD_WAREHOUSE z 5 dowolnym produktami z tabeli
--PRODUCTS, w wyniku wyświetl jedynie nazwę produktu (kolumna PRODUCT_NAME)
--i kod produktu (kolumna PRODUCT_CODE). Czy w przypadku wykorzystania UNION
--jakieś wierszy zostały pominięte?

-- tu nie do końca rozumiem, czy limit 5 powinniśmy dać, żeby połączyć 5 dowolnych produktów. Czy może chodziło o coś innego?
SELECT product_name, product_code 
FROM dml_excercises.products_old_warehouse 
UNION ALL 
SELECT product_name, product_code 
FROM dml_excercises.products
LIMIT 5;

SELECT product_name, product_code 
FROM dml_excercises.products_old_warehouse 
UNION 
SELECT product_name, product_code 
FROM dml_excercises.products
LIMIT 5;

--9. Na podstawie tabeli z zadania 7, korzystając z operacji EXCEPT znajdź różnicę zbiorów
--pomiędzy tabelą PRODUCTS_OLD_WAREHOUSE a PRODUCTS, w wyniku wyświetl
--jedynie kod produktu (kolumna PRODUCT_CODE).

SELECT product_code
FROM dml_excercises.products
EXCEPT ALL
SELECT product_code 
FROM dml_excercises.products_old_warehouse;

--10. Wyświetl 10 rekordów z tabeli sprzedażowej sales. Dane powinny być posortowane
--według wartości sprzedaży (kolumn SAL_VALUE) malejąco.

SELECT *
FROM dml_excercises.sales s2 
ORDER BY s2.sal_qty DESC
LIMIT 10; 

--11. Korzystając z funkcji SUBSTRING na atrybucie SAL_DESCRIPTION, wyświetl 3 dowolne
--wiersze z tabeli sprzedażowej w taki sposób, aby w kolumnie wynikowej dla
--SUBSTRING z SAL_DESCRIPTION wyświetlonych zostało tylko 3 pierwsze znaki.

SELECT substring(sal_description,1, 3)  AS znaki_sal_description
FROM dml_excercises.sales
LIMIT 3;

--12. Korzystając ze składni LIKE znajdź wszystkie dane sprzedażowe, których opis sprzedaży
--(SAL_DESCRIPTION) zaczyna się od c4c.

SELECT *
FROM dml_excercises.sales 
WHERE sales.sal_description LIKE 'c4c%';
