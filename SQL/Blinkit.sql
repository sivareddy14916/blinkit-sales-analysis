Use Blinkit
select * from blinkit

-- Data cleaning
update blinkit
set Item_Fat_Content = 
case 
    when Item_Fat_Content in ('low Fat','LF') then 'Low Fat'
    when Item_Fat_Content = 'reg' then 'Regular'
    else Item_Fat_Content
end


-- To check whether update works or not
select distinct(Item_Fat_Content) from blinkit


--  KPI's

-- total sales = 1201681.49196053
select sum(Sales) as Total_Sales from blinkit

-- total sales in millions
select concat(cast(sum(Sales)/1000000 as decimal(10,2)),' M') as Total_Sales_In_Millons from blinkit

-- avg sales
select cast(avg(Sales) as decimal(10,2)) as Avg_Sales from blinkit

-- no.of items - total count of different items sold
select count(*) as Number_Of_Items from blinkit

-- Avg_rating for items
select cast(avg(rating) as decimal(10,2)) as avg_rating from blinkit



-- Granular requirement

-- total sales by fat content along with all remaining KPI's
select Item_Fat_Content, 
       cast(sum(Sales) as decimal(10,2)) as total_sales,
       cast(avg(Sales) as decimal(10,2)) as Avg_Sales,
       count(*) as Number_Of_Items,
       cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit
group by Item_Fat_Content

-- similarly for item type but top 5
select top 5 Item_Type, 
       cast(sum(Sales) as decimal(10,2)) as total_sales,
       cast(avg(Sales) as decimal(10,2)) as Avg_Sales,
       count(*) as Number_Of_Items,
       cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit
group by Item_Type
order by 2 desc

-- Fat content by outlet for total sales
select Outlet_Location_Type ,Item_Fat_Content, 
       cast(sum(Sales) as decimal(10,2)) as total_sales,
       cast(avg(Sales) as decimal(10,2)) as Avg_Sales,
       count(*) as Number_Of_Items,
       cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit
group by Outlet_Location_Type,Item_Fat_Content
order by 3 asc;

-- Pivoting way
SELECT 
    Outlet_Location_Type,

    -- Low Fat Sales
    cast(SUM(CASE
            WHEN Item_Fat_Content = 'Low Fat'
            THEN Sales
        END) as decimal(10,2)) AS [Low Fat Total Sales],

    -- Regular Sales
    cast(SUM(CASE
            WHEN Item_Fat_Content = 'Regular'
            THEN Sales
        END)  as decimal(10,2))AS [Regular Total Sales],

    -- Low Fat Avg Rating
    cast(AVG(CASE
            WHEN Item_Fat_Content = 'Low Fat'
            THEN Rating
        END) as decimal(10,2)) AS [Low Fat Avg Rating],

    -- Regular Avg Rating
    cast(AVG(CASE
            WHEN Item_Fat_Content = 'Regular'
            THEN Rating
        END) as decimal(10,2)) AS [Regular Avg Rating],

    -- Low Fat Item Count
    COUNT(CASE
              WHEN Item_Fat_Content = 'Low Fat'
              THEN 1
          END) AS [Low Fat Number Of Items],

    -- Regular Item Count
    COUNT(CASE
              WHEN Item_Fat_Content = 'Regular'
              THEN 1
          END) AS [Regular Number Of Items]

FROM blinkit

GROUP BY Outlet_Location_Type

ORDER BY Outlet_Location_Type;


-- total sales by outlet establishment
select Outlet_Establishment_Year, sum(sales) as total_Sales from blinkit
group by Outlet_Establishment_Year
order by 1;

select Outlet_Establishment_Year,
       cast(sum(Sales) as decimal(10,2)) as total_sales,
       cast(avg(Sales) as decimal(10,2)) as Avg_Sales,
       count(*) as Number_Of_Items,
       cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit
group by Outlet_Establishment_Year
order by 2 desc;


select Outlet_Size,sum(sales) as total_Sales,sum(sales)*100/ (select sum(sales) from blinkit) as perc
from blinkit
group by Outlet_Size

-- All metrics by outlet type
select Outlet_Type,
       cast(sum(Sales) as decimal(10,2)) as total_sales,
       cast(avg(Sales) as decimal(10,2)) as Avg_Sales,
       count(*) as Number_Of_Items,
       cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit
group by Outlet_Type
order by 2 desc;