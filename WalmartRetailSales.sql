CREATE DATABASE salesDataWalmart;
CREATE TABLE IF NOT EXISTS sales(
		invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
        Branch VARCHAR(5) NOT NULL, 
        city VARCHAR(30) NOT NULL,
        customer_type VARCHAR(30) NOT NULL,
        gender VARCHAR(10) NOT NULL,
        product_line VARCHAR(100) NOT NULL,
        unit_price	DECIMAL(10, 2) NOT NULL,
        quantity INT NOT NULL,
        VAT FLOAT(6, 4) NOT NULL,
        total DECIMAL(12, 4) NOT NULL,
        date DATETIME NOT NULL,
        time TIME NOT NULL,
        payment_method VARCHAR(15) NOT NULL,
        cogs DECIMAL(10, 2) NOT NULL,
        gross_margin_percentage	FLOAT(11, 9),
        gross_income DECIMAL(12, 4) NOT NULL,
        rating FLOAT(2, 1)
);


-- -------------------------------------------------------------------------------------
-- ------------------------- Feature Engineering ---------------------------------------

-- time_of_day

SELECT time, (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
	) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);	-- Added a new column

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
);

-- day_name

SELECT date, DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT date, MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales MODIFY COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);
-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- --------------------------- Generic --------------------------------------------------

-- 1.How many unique cities does the data have?
SELECT DISTINCT city 
FROM sales;

-- 2.In which city is each branch?
SELECT DISTINCT branch
FROM sales;

SELECT DISTINCT city, branch
FROM sales;

-- ---------------------------------------------------------------------------------------
-- ---------------------------- Product --------------------------------------------------
-- 1. How many unique product lines does the data have?
SELECT 
	COUNT(DISTINCT product_line) AS Total_Product_Line
FROM sales;

-- 2. What is the most common payment method?
SELECT 
	payment_method,
	COUNT(payment_method) AS count
FROM sales
GROUP BY payment_method
ORDER BY count DESC;

-- 3. What is the most selling product line?
SELECT 
	product_line,
	COUNT(product_line) AS count
FROM sales
GROUP BY product_line
ORDER BY count DESC;

-- 4. What is the total revenue by month?
SELECT 
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 5. What month had the largest COGS?
SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- 6. What product line had the largest revenue?
SELECT 
	product_line,
    SUM(total) AS total_revenue 
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 7. What is the city with the largest revenue?
SELECT 
	city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- 8. What product line had the largest VAT?
SELECT 
	product_line,
    avg(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales



-- 10 Which branch sold more products than average product sold?
SELECT 
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- 11 What is the most common product line by gender?
SELECT 
	gender,
    product_line,
    COUNT(gender) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY total_count DESC;


-- 12. What is the average rating of each product line?
SELECT 
	product_line,
    ROUND(AVG(rating)) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- ----------------------------------------------------------------------------------
-- -------------------------------- Sales -------------------------------------------

-- 1. Number of sales made in each time of the day per weekday
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;


-- 2. Which of the customer types brings the most revenue?
SELECT 
	customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;


-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;


-- 4. Which customer type pays the most in VAT?
SELECT 
	customer_type,
    AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- ---------------------------------------------------------------------
-- --------------------------- Customer --------------------------------

-- 1. How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- 2.How many unique payment methods does the data have?
SELECT 
	DISTINCT payment_method
FROM sales;

-- 3. What is the most common customer type?
SELECT 
	customer_type,
	COUNT(*) AS total_sales
FROM sales
GROUP BY customer_type
ORDER BY total_sales DESC;

-- 4. Which customer type buys the most?
SELECT 
	customer_type,
    COUNT(*) AS customer_count
FROM sales
GROUP BY customer_type;

-- 5. What is the gender of most of the customer?
SELECT 
	gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;
 
-- 6. What is the gender distribution per branch?
SELECT 
	gender,
    COUNT(*) AS gender_count
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_count DESC;

-- 7. Which time of the day do customers give most ratings?
SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating;

-- 9. Which day of the week has the best avg ratings?
SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- 10. Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY day_name
ORDER BY avg_rating DESC;
 






-- ---------------------------------------------------------------------------------------