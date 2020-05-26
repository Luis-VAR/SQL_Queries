---
 
-- ORDERS

---


-- select everything from line_item

SELECT * FROM line_item


-- select only the first 10 rows from line_item

SELECT * FROM line_item
LIMIT 10


-- select only sku, unit_price and date from line_item and only the first 10 rows

SELECT sku, unit_price, date 
  FROM line_item
LIMIT 10


-- count the number of entires on the table

SELECT COUNT(*)
  FROM line_item

  
-- count the unique obervations in sku from

SELECT COUNT(DISTINCT sku)
  FROM line_item
  

-- generate a list with the average price of each sku ans save it as avg_price
-- sorting it by descending order
  
SELECT sku, AVG(unit_price) AS avg_price
  FROM line_item
GROUP BY sku
ORDER BY avg_price DESC


-- query to find out which products were bought in the biggest questities. limit the results to the first 100

SELECT sku, product_quantity
 FROM line_item
ORDER BY product_quantity DESC
LIMIT 100
 
 
---
 
-- ORDERS

---


-- how many orders were placed in total?

SELECT COUNT(id_order)
FROM orders


-- count orders per state

SELECT state, COUNT(id_order)
FROM orders
GROUP BY state


-- select all the orders from in January of 2017

SELECT id_order, created_date
FROM orders
WHERE created_date LIKE '2017-01%'
ORDER BY created_date


-- how many from those orders were placed in january the 1st

SELECT COUNT(id_order)
FROM orders
WHERE created_date LIKE '2017-01%'


-- how many orders were cancelled on January 4th 2017?

SELECT COUNT(id_order)
FROM orders
WHERE created_date LIKE '2017-01-04%'  AND state = 'Cancelled'


-- how many orders have been placed each month of the year?

SELECT COUNT(id_order)
FROM orders
WHERE created_date LIKE '2017-01-04%'  AND state = 'Cancelled'


-- how many orders have been placed each month of the year?

SELECT COUNT(id_order), EXTRACT(MONTH FROM created_date) as month_extracted
FROM orders
GROUP BY month_extracted
ORDER BY month_extracted


-- what is the total amount paid in all the orders?

SELECT SUM(total_paid)
FROM orders


-- what is the average amount paid per order?

SELECT SUM(total_paid)/COUNT(id_order) AS average_amount_paid
FROM orders


-- give a result to the previous question with only 2 decimals

SELECT ROUND(SUM(total_paid)/COUNT(id_order),2) AS average_amount_paid
FROM orders


-- what is the date of the newest order? And the oldest?

SELECT MAX(created_date) AS newest_order, MIN(created_date) AS oldest_order
FROM orders


-- what is the day with the highest amount of completed orders (and how many completed orders were placed that day)?

SELECT COUNT(id_order) AS highest_number_of_orders, DATE(created_date) AS transaction_date
FROM orders
WHERE  state = "Completed"
GROUP BY transaction_date
ORDER BY highest_number_of_orders DESC
LIMIT 1


-- what is the day with the highest amount paid (and how much was paid that day)?

SELECT SUM(total_paid) AS highest_daily_total, DATE(created_date) AS transaction_date
FROM orders
WHERE  state = "Completed"
GROUP BY DATE(created_date)
ORDER BY highest_daily_total DESC
LIMIT 1
 
 
---
 
-- PRODUCTS

---


-- how many products are there?

SELECT COUNT(DISTINCT ProductId) AS number_of_unique_products
FROM products


-- how many brands?

SELECT COUNT(DISTINCT Brand) AS number_of_unique_brands
FROM products

-- how many categories?


SELECT COUNT(DISTINCT manual_categories) AS number_of_unique_categories
FROM products

-- how many products per brand 

SELECT Brand AS brands, COUNT(DISTINCT ProductId) AS number_of_products
FROM products
GROUP BY brands
ORDER BY number_of_products DESC

-- & products per category?

SELECT manual_categories AS unique_categories, COUNT(DISTINCT ProductId) AS number_of_products
FROM products
GROUP BY unique_categories
ORDER BY number_of_products DESC

-- what's the average price per brand 

SELECT Brand AS brand, ROUND(AVG(price),2) AS average_price
FROM products
GROUP BY brand

-- and the average price per category?

SELECT manual_categories AS categories, ROUND(AVG(price),2) AS average_price
FROM products
GROUP BY categories

-- what's the name and description of the most expensive product per brand and per category?

SELECT name_en as product_name, short_desc_en AS description, p.brand, price
FROM ( SELECT brand, MAX(price) as maxprice FROM products p GROUP BY brand) AS temp
INNER JOIN products AS p 
ON p.brand = temp.brand AND p.price=temp.maxprice
ORDER BY temp.maxprice DESC

SELECT name_en as product_name, short_desc_en AS description, p.manual_categories, price
FROM ( SELECT manual_categories, MAX(price) as maxprice FROM products p GROUP BY manual_categories) AS temp
INNER JOIN products AS p 
ON p.manual_categories = temp.manual_categories AND p.price=temp.maxprice
ORDER BY temp.maxprice DESC


---
 
-- JOINS

---


-- Query 1. the first query should return the "sku", "product_quantity", "date" and "unit_price" 
-- from the line_item table together with the "name" and the "price" of each product from the "products" table. 
-- only products present in both tables.

SELECT p.name_en, l.product_quantity AS quantity, l.date, l.unit_price,  p.price, l.sku
FROM line_item l
INNER JOIN products p
ON l.sku = p.sku
LIMIT 100

-- Query 2. you might notice that the unit_price from the line_item table and the price from the product table is not the same. 
-- Extend your previous query by adding a column with the difference in price. Name that column price_difference.

SELECT p.name_en, l.product_quantity AS quantity, l.date, l.unit_price,  p.price, p.price - l.unit_price AS price_difference, l.sku
FROM line_item l
INNER JOIN products p
ON l.sku = p.sku
LIMIT 100

-- Query 3. build a query that outputs the price difference that was just calculated 
-- grouping products by category. Round the result.

SELECT  p.manual_categories, AVG(p.price - l.unit_price) AS price_difference
FROM line_item l
INNER JOIN products p
ON l.sku = p.sku
GROUP BY p.manual_categories


-- Query 4. create the same query as before. Calculating the price difference between the line_item and the products tables
-- but now grouping by brands instead of categories.

SELECT  p.brand, AVG(p.price - l.unit_price) AS price_difference
FROM line_item l
INNER JOIN products p
ON l.sku = p.sku
GROUP BY p.brand


-- Query 5. focus on the brands with a big price difference: run the same query as before, but now limiting the results 
-- to only brands with an avg_price_dif of more than 50000. Order the results by avg_price_dif (descending).

SELECT  p.brand, AVG(p.price - l.unit_price) AS avg_price_difference
FROM line_item l
INNER JOIN products p
ON l.sku = p.sku
GROUP BY p.brand
HAVING AVG(p.price - l.unit_price) > 50000
ORDER BY avg_price_difference DESC

-- Query 6. first, connect each product (sku) from the line_item table to the orders table. 
-- I only want sku that have been in any order. This table will contain duplicates, and it´s ok. I´ll group and count this information later.

SELECT l.sku
FROM line_item l
JOIN orders o
ON l.id_order = o.id_order
LIMIT 100

-- Query 7. now, add to the previous query the brand and the category from the products table to this query.

SELECT p.brand, p.manual_categories, l.sku
FROM line_item l
JOIN orders o
ON l.id_order = o.id_order
JOIN products p
ON l.sku=p.sku
LIMIT 100

-- Query 8. Let's keep working on the same query: now we want to keep only "Cancelled" orders. Modify this query to group the results from the previous query 
-- first by category and then by brand, adding in both cases a count so we know which categories and which brands are most times present in "Cancelled"" orders.

SELECT p.manual_categories, COUNT(o.id_order) AS Cnt, o.state
FROM line_item l
JOIN orders o
ON l.id_order = o.id_order
JOIN products p
ON l.sku=p.sku
GROUP BY p.manual_categories, o.state
HAVING o.state = "Cancelled" AND Cnt > 200
ORDER BY Cnt DESC

SELECT p.brand, COUNT(o.id_order) AS Cnt, o.state
FROM line_item l
JOIN orders o
ON l.id_order = o.id_order
JOIN products p
ON l.sku=p.sku
GROUP BY p.brand, o.state
HAVING o.state = "Cancelled" AND Cnt > 200
ORDER BY Cnt DESC