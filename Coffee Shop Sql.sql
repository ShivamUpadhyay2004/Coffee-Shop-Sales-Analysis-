create database coffee_shop_sales_db;
use coffee_shop_sales_db;

select * from coffee_shop_sales;


desc coffee_shop_sales;



set Sql_safe_updates = 0 ;

update coffee_shop_sales set transaction_date = str_to_date(transaction_date,'%d-%m-%Y');




alter table coffee_shop_sales modify column transaction_date DATE ;



update coffee_shop_sales set transaction_time = str_to_date(transaction_time,'%H:%i:%s');



alter table coffee_shop_sales modify column transaction_time TIME ;




desc coffee_shop_sales;


alter table coffee_shop_sales rename column ï»¿transaction_id to transaction_id ; 



select round(sum(unit_price * transaction_qty),1) as Total_Sales from coffee_shop_sales where month(transaction_date) = 3 ;       -- May Month






SELECT 
    MONTH(transaction_date) AS month, -- Number of Month
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales, -- Total Sales 
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) -- Month Sales Difference 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) -- Division By Previous Month Sales
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage -- Percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April(PM) and May(CM)
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    
    
    
    
    
    
    select count(transaction_id) as Total_orders
from coffee_shop_sales where month(transaction_date) = 5; -- May month(CM)   
    
    
    
    
    
    
    SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

    





select sum(transaction_qty) as Total_Quantity_Sold
from coffee_shop_sales where month(transaction_date) = 5; -- May month(CM)





SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);












select 
concat(round(sum(unit_price * transaction_qty)/1000,1),'k') as Total_Sales ,
concat(round(count(transaction_id)/1000,1),'k') as Total_orders,
concat(round(sum(transaction_qty)/1000,1),'k') as Total_Quantity_Sold
from coffee_shop_sales 
where transaction_date = '2023-05-18'; 









-- weekdays = saturday & sunday
-- weakends = mon to friday

-- sunday = 1
-- monday = 2 .......... saturday = 7



select case when dayofweek(transaction_date) in(1,7) then 'Weekends'
else 'Weekdays'
end as Day_type
,concat(round(sum(unit_price * transaction_qty)/1000,1),'k') as Total_Sales
from coffee_shop_sales 
where month(transaction_date) = 2 -- may month
group by case when dayofweek(transaction_date) in(1,7) then 'Weekends'
else 'Weekdays'
end ;




 
-- store location wise total sales

select 
store_location ,
concat(round(sum(unit_price * transaction_qty)/1000,1),'k') as Total_sales
from coffee_shop_sales 
where month(transaction_date) = 5 -- may month
group by store_location  ;








-- monthwise Avg & Total Sales


select concat(round(Avg(Total_sales)/1000,1),'k') as Avg_Sales
from 
(select sum(unit_price * transaction_qty) as Total_sales
from coffee_shop_sales 
where month(transaction_date) = 5 -- may month
group by transaction_date) as inner_query;




SELECT 
    DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);
    
    
    
    
    
    
    
    
    
    SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;









-- product_category wise sales 

select 
product_category,
round(sum(unit_price * transaction_qty),2) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5 -- may month
group by product_category
order by Total_sales desc;






-- product_type wise sales 

select product_type,
round(sum(unit_price * transaction_qty),2) as Total_sales 
from coffee_shop_sales
where month(transaction_date) = 5 and product_category = 'Coffee'
group by product_type 
order by Total_sales desc
limit 10;











-- total sales by month , day & hour


select 
round(sum(unit_price * transaction_qty),2) as Total_sales ,
sum(transaction_qty) as Total_qty_sold,
count(transaction_id) as Total_orders
from coffee_shop_sales 
where month(transaction_date) = 5 -- may month
and dayofweek(transaction_date) = 2 -- monday
and hour(transaction_time) = 8; -- for hour number 8








-- total sales by hour or  which is peak hour

select hour(transaction_time) as Day_hours,
 round(sum(unit_price * transaction_qty),2) as Total_sales 
 from coffee_shop_sales 
 where month(transaction_date) = 5 -- for may month
 group by Day_hours
 order by Day_hours ;
 








-- total sales by days


SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END; 
