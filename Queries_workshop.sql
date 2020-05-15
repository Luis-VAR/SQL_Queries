-- LINE_ITEM

-- select everything from line_item

SELECT * FROM line_item

-- select only the first 10 rows from line_item

SELECT * FROM line_item
LIMIT 10

-- select only sku, unit_price and dateSelect only the columns sku, unit_price and date from the line_item table (and only the first 10 rows)

SELECT sku, unit_price, date 
  FROM line_item
LIMIT 10

-- Count the total number of rows of the line_item table

SELECT COUNT(*)
  FROM line_item
  
-- Count the total number of unique "sku" from the line_item table

  
SELECT COUNT(DISTINCT sku)
  FROM line_item
  
-- Generate a list with the average price of each sku
--  …now name the column of the previous query with the average price "avg_price", and sort the list that you by that column (bigger to smaller price)
  
SELECT sku, AVG(unit_price) AS avg_price
  FROM line_item
GROUP BY sku
ORDER BY avg_price DESC

-- Which products were bought in largest quantities?
-- select the 100 lines with the biggest "product quantity"


SELECT sku, product_quantity
 FROM line_item
ORDER BY product_quantity DESC
LIMIT 100
 
-- ORDERS

-- How many orders were placed in total?

SELECT COUNT(id_order)
FROM orders


-- Make a count of orders by their state

SELECT state, COUNT(id_order)
FROM orders
GROUP BY state


-- Select all the orders placed in January of 2017

SELECT id_order, created_date
FROM orders
WHERE created_date LIKE '2017-01%'
ORDER BY created_date

-- Count the number of orders of your previous select query (i.e. How many orders were placed in January of 2017?)

SELECT COUNT(id_order)
FROM orders
WHERE created_date LIKE '2017-01%'


-- How many orders were cancelled on January 4th 2017?

SELECT COUNT(id_order)
FROM orders
WHERE created_date LIKE '2017-01-04%'  AND state = 'Cancelled'

-- How many orders have been placed each month of the year?

SELECT COUNT(id_order)
FROM orders
WHERE created_date LIKE '2017-01-04%'  AND state = 'Cancelled'


-- How many orders have been placed each month of the year?

SELECT COUNT(id_order), EXTRACT(MONTH FROM created_date) as month_extracted
FROM orders
GROUP BY month_extracted
ORDER BY month_extracted

-- What is the total amount paid in all the orders?

SELECT SUM(total_paid)
FROM orders

-- What is the average amount paid per order?

SELECT SUM(total_paid)/COUNT(id_order) AS average_amount_paid
FROM orders

-- Give a result to the previous question with only 2 decimals

SELECT ROUND(SUM(total_paid)/COUNT(id_order),2) AS average_amount_paid
FROM orders

-- What is the date of the newest order? And the oldest?

SELECT MAX(created_date) AS newest_order, MIN(created_date) AS oldest_order
FROM orders

-- What is the day with the highest amount of completed orders (and how many completed orders were placed that day)?

SELECT COUNT(id_order) AS highest_number_of_orders, DATE(created_date) AS transaction_date
FROM orders
WHERE  state = "Completed"
GROUP BY transaction_date
ORDER BY highest_number_of_orders DESC
LIMIT 1

-- What is the day with the highest amount paid (and how much was paid that day)?

SELECT SUM(total_paid) AS highest_daily_total, DATE(created_date) AS transaction_date
FROM orders
WHERE  state = "Completed"
GROUP BY DATE(created_date)
ORDER BY highest_daily_total DESC
LIMIT 1

-- PRODUCTS

-- How many products are there?

SELECT COUNT(DISTINCT ProductId) AS number_of_unique_products
FROM products


-- How many brands?

SELECT COUNT(DISTINCT Brand) AS number_of_unique_brands
FROM products

-- How many categories?


SELECT COUNT(DISTINCT manual_categories) AS number_of_unique_categories
FROM products