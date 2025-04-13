-- create DATABASE
CREATE DATABASE retail_sales_db;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
			(
					transactions_id	 INT PRIMARY KEY,
					sale_date  DATE,
					sale_time  TIME,
					customer_id	 INT,
					gender VARCHAR(15),
					age	 INT,
					category VARCHAR(15),	
					quantity	 INT,
					price_per_unit	FLOAT,
					cogs   FLOAT,
					total_sale FLOAT
			);


SELECT *
FROM retail_sales;

SELECT COUNT (*)
FROM retail_sales;

-- Data Cleaning
SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	 IS NULL
	OR
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
    OR 
	cogs IS NULL
	OR
	total_sale IS NULL;


-- Check to see if Null Values for age could be filled 
SELECT *
FROM retail_sales
WHERE customer_id IN (17, 16, 67, 89, 77)
	AND gender ILIKE 'female'
ORDER BY customer_id ASC;

SELECT *
FROM retail_sales
WHERE customer_id IN (130, 25, 94, 116, 101)
	AND gender = 'Male'
ORDER BY customer_id;
	
	
DELETE 
FROM retail_sales
	WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	 IS NULL
	OR
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
    OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

SELECT *
FROM retail_sales;

-- Data Exploration 

--  Number of sales records
SELECT COUNT (*) AS total_sales
FROM retail_sales;

-- Number of unique customers
SELECT COUNT (DISTINCT customer_id) AS unique_customers
FROM retail_sales; 

-- Number of unique categories 
SELECT DISTINCT (category)
FROM retail_sales; 


-- Data Analysis & Business Key Problems & Answers 

-- My Analysis & Findings 

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transaction where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales(total_sales) for each category
-- Q.4 Write a SQL query to find the average ae of customers who purchased items from the 'Beauty' category
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater 1000
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
-- Q.7 Write a SQL query to calculate the average sale for eaach month, find out best sellin month in each year 
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query find the number of unique cutsomer who purchaseed items from each category
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transaction where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4;

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND sale_date >= DATE '2022-11-01'
  AND sale_date < DATE '2022-12-01'
  AND quantity >= 4;


-- Q.3 Write a SQL query to calculate the total sales(total_sales) for each category

SELECT category, SUM(total_sale) AS net_sales, COUNT(*) AS total_order
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category ='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater 1000

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT 
	category, 
	gender, 
	COUNT(*) AS total_trans, 
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for eaach month, find out best sellin month in each year 

SELECT 
	year,
	month,
	avg_sale 
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE rank = 1
-- ORDER BY 1, 3 DESC;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
  
SELECT  
	customer_id, 
	SUM(total_sale) AS total_sale 
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique cutsomer who purchased items from each category

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS Unique_Customer
FROM retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(transactions_id) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- End of project 
