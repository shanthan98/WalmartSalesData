-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- --------------------------------------------------------------------------------------------------
-- -------------------------------------Feature Engineering------------------------------------------

-- time of the day
select 
	time,
    (case 
		when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end)as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day = (case 
		when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end);
    
-- day name
select 
	date,
    dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- month name

select 
	date,
	monthname(date) as month_name
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

-- -------------------------------------------------------------
-- -----------------------Generic-------------------------------

-- How many unique cities does the data have?
select 
	distinct city
from sales;

-- In which city is each branch?
select 
	distinct branch
from sales;

select 
	distinct city,
    branch
from sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------

-- How many unique product lines does the data have?

select
	count(distinct product_line)
from sales;

-- most common payment method
select
	payment_method,
    count(*) as cnt
from sales
group by 1
order by 2 desc;

 -- What is the most selling product line
select
	product_line,
    count(*) as cnt
from sales
group by 1
order by 2 desc;

-- total revenue by month
select
	month_name as month,
    sum(total) as total_rev
from sales
group by 1
order by 2 desc;

-- What month had the largest COGS?
select 
	month_name as month,
    sum(cogs) as cogs
from sales
group by 1
order by 2 desc;

-- What product line had the largest revenue?
select
	product_line,
    sum(total) as total_rev
from sales
group by 1
order by 2 desc;

-- What is the city with the largest revenue?
select
	city,
    branch,
    sum(total) as total_rev
from sales
group by city,branch
order by 3 desc;

-- What product line had the largest VAT?
select
	product_line,
    avg(vat) as avg_vat
from sales
group by 1
order by 2 desc;

-- Fetch each product line and add a column to those product line 
-- showing "Good", "Bad". Good if its greater than average sales
select
	product_line,
    sum(total) as total_sales
from sales
group by 1
order by 2 desc;

-- Which branch sold more products than average product sold?
select 
	branch,
    sum(quantity)
from sales
group by 1
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select 
	gender,
    product_line,
    count(gender) as gender_cnt
from sales
group by 1,2
order by 3 desc;

-- What is the average rating of each product line?
select
	product_line,
	round(avg(rating),2) as avg_rating
from sales
group by 1
order by 2 desc;

-- --------------------------------------------------------------------
-- -------------------------- Sales -----------------------------------

-- Number of sales made in each time of the day per weekday
select
	time_of_day,
    count(*) total_sales
from sales
where day_name = 'Sunday'
group by 1
order by 2 desc;

-- Which of the customer types brings the most revenue?
select
	customer_type,
    sum(total) as revenue
from sales
group by 1
order by 2 desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select
	city,
    sum(vat)
from sales
group by 1;

-- Which customer type pays the most in VAT?
select
	customer_type,
    sum(vat)
from sales
group by 1;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------

-- How many unique customer types does the data have?
select
	distinct customer_type
from sales;

-- How many unique payment methods does the data have?
select
	distinct payment_method
from sales;

-- What is the most common customer type?
select
	customer_type,
    count(*)
from sales
group by 1
order by 2 desc;

-- Which customer type buys the most?
select
	customer_type,
    count(*)
from sales
group by 1
order by 2 desc;

-- What is the gender of most of the customers?
select
	gender,
    count(*) as gender_cnt
from sales
group by 1
order by 2 desc;

-- What is the gender distribution per branch?
select
	gender,
    count(*) as gender_cnt,
    branch
from sales
where branch = "A"
group by 1
order by 2 desc;

-- Which time of the day do customers give most ratings?
select
	time_of_day,
    count(*)
from sales
group by 1;

-- Which time of the day do customers give most ratings per branch?
select
	time_of_day,
    count(*)
from sales
where branch = 'A'
group by 1;

-- Which day fo the week has the best avg ratings?
select
	day_name,
    avg(rating)
from sales
group by 1
order by 2 desc;

-- Which day of the week has the best average ratings per branch?
select
	day_name,
    avg(rating)
from sales
where branch = 'A'
group by 1
order by 2 desc;


















