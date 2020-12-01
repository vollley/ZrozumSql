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

--1. Wyœwietl unikatowe daty stworzenia produktów (wed³ug atrybutu manufactured_date)
SELECT DISTINCT products.manufactured_date 
FROM dml_excercises.products;

--2. Jak sprawdzisz czy 10 wstawionych produktów to 10 unikatowych kodów produktów?

--nie mam pomys³u, jak zrobic to jedn¹ komend¹

SELECT products.product_code
FROM dml_excercises.products;

SELECT product_code 
FROM dml_excercises.products;

--3. Korzystaj¹c ze sk³adni IN wyœwietl produkty od kodach PRD1 i PRD9
SELECT products.product_name, products.product_code 
FROM dml_excercises.products 
WHERE product_code IN ('PRD1', 'PRD9');


--4. Wyœwietl wszystkie atrybuty z danych sprzeda¿owych, takie ¿e data sprzeda¿y jest w
--zakresie od 1 sierpnia 2020 do 31 sierpnia 2020 (w³¹cznie). Dane wynikowe maj¹ byæ
--posortowane wed³ug wartoœci sprzeda¿y malej¹co i daty sprzeda¿y rosn¹co.
--Nie by³o danych za sierpieñ, zmieni³am to na wrzesieñ. 
SELECT * 
FROM dml_excercises.sales
WHERE sales.sal_date > '2020/09/01' AND sales.sal_date <= '2020/09/30'
ORDER BY sales.sal_date ASC, sales.sal_qty DESC; 


--5. Korzystaj¹c ze sk³adni NOT EXISTS wyœwietl te produkty z tabeli PRODUCTS, które nie
--bior¹ udzia³u w transakcjach sprzeda¿owych (tabela SALES). ID z tabeli Products i
--SAL_PRODUCT_ID to klucz ³¹czenia.

SELECT p.* 
FROM dml_excercises.products p
WHERE NOT EXISTS (SELECT 1
						FROM dml_excercises.sales s
						WHERE s.sal_product_id = p.id) ;

--6. Korzystaj¹c ze sk³adni ANY i operatora = wyœwietl te produkty, których wystêpuj¹ w
--transakcjach sprzeda¿owych (wed³ug klucza Products ID, Sales SAL_PRODUCT_ID)
--takich, ¿e wartoœæ sprzeda¿y w transakcji jest wiêksza od 100

SELECT *
FROM dml_excercises.products 
WHERE COALESCE (product_code,'')
				= ANY (SELECT coalesce (product_code,'')
 				FROM sales
				WHERE products.id = sales.sal_product_id
				AND sal_value>100);
			
--czy mo¿e powinnien byæ SELECT DISTINTC (tak jak poni¿ej)?			
SELECT *
FROM dml_excercises.products 
WHERE COALESCE (product_code,'')
				= ANY (SELECT DISTINCT coalesce (product_code,'')
 				FROM dml_excercises.sales
				WHERE products.id = sales.sal_product_id
				AND sal_value>100);	
			
--7. Stwórz now¹ tabelê PRODUCTS_OLD_WAREHOUSE o takich samych kolumnach jak
--istniej¹ca tabela produktów (tabela PRODUCTS). Wstaw do nowej tabeli kilka wierszy -
--dowolnych wed³ug Twojego uznania.

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
--8. Na podstawie tabeli z zadania 7, korzystaj¹c z operacji UNION oraz UNION ALL po³¹cz
--tabelê PRODUCTS_OLD_WAREHOUSE z 5 dowolnym produktami z tabeli
--PRODUCTS, w wyniku wyœwietl jedynie nazwê produktu (kolumna PRODUCT_NAME)
--i kod produktu (kolumna PRODUCT_CODE). Czy w przypadku wykorzystania UNION
--jakieœ wierszy zosta³y pominiête?

-- tu nie do koñca rozumiem, czy limit 5 powinniœmy daæ, ¿eby po³¹czyæ 5 dowolnych produktów. Czy mo¿e chodzi³o o coœ innego?
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

--9. Na podstawie tabeli z zadania 7, korzystaj¹c z operacji EXCEPT znajdŸ ró¿nicê zbiorów
--pomiêdzy tabel¹ PRODUCTS_OLD_WAREHOUSE a PRODUCTS, w wyniku wyœwietl
--jedynie kod produktu (kolumna PRODUCT_CODE).

SELECT product_code
FROM dml_excercises.products
EXCEPT ALL
SELECT product_code 
FROM dml_excercises.products_old_warehouse;

--10. Wyœwietl 10 rekordów z tabeli sprzeda¿owej sales. Dane powinny byæ posortowane
--wed³ug wartoœci sprzeda¿y (kolumn SAL_VALUE) malej¹co.

SELECT *
FROM dml_excercises.sales s2 
ORDER BY s2.sal_qty DESC
LIMIT 10; 

--11. Korzystaj¹c z funkcji SUBSTRING na atrybucie SAL_DESCRIPTION, wyœwietl 3 dowolne
--wiersze z tabeli sprzeda¿owej w taki sposób, aby w kolumnie wynikowej dla
--SUBSTRING z SAL_DESCRIPTION wyœwietlonych zosta³o tylko 3 pierwsze znaki.

SELECT substring(sal_description,1, 3)  AS znaki_sal_description
FROM dml_excercises.sales;

--12. Korzystaj¹c ze sk³adni LIKE znajdŸ wszystkie dane sprzeda¿owe, których opis sprzeda¿y
--(SAL_DESCRIPTION) zaczyna siê od c4c.

SELECT *
FROM dml_excercises.sales 
WHERE sales.sal_description LIKE 'c4c%';
