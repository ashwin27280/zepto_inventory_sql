create table zepto(
sku_id serial primary key,
Category varchar(200),
name	varchar(200) not null,
mrp	numeric(8,2),
discountPercent	numeric,
availableQuantity	numeric,
discountedSellingPrice	numeric,
weightInGms	numeric,
outOfStock	boolean,
quantity numeric
);

--data exploration

--count of rows
select count(*) from zepto;

--have a look data
select * from zepto;

--check null values
select *from zepto
where name is null
or 
category is null
or 
mrp is null
or
discountPercent is null
or
availableQuantity is null
or 
discountedSellingPrice is null
or 
weightInGms is null
or
outOfStock	is null
or 
quantity is null;

--different product category 
select distinct category
from zepto
order by category;

--product in stock vs out of stock
select outofstock , count(sku_id)
from zepto
group by outofstock;

--product names present multiple times
select name,count(name)as count from zepto
group by name
order by count desc;

--data cleaning

--product with mrp/price =0
select *from zepto
where mrp=0 or discountedSellingPrice =0;

delete from zepto
where mrp=0;

--convert paise to rupees
update zepto
set mrp=mrp/100,
discountedSellingPrice=discountedSellingPrice/100;

select *from zepto;


--NUMERIC(5,2) means 5 total digits, with 2 digits after the decimal point.
alter table zepto
alter column discountedSellingPrice type numeric(10,2);


--Find the top 10 best values products based on the discount percentage
select distinct name, discountPercent from zepto
order by discountPercent desc
limit 10;

--what are the products with high mrp but out of stock
select  distinct name,mrp
from zepto
where outOfStock =TRUE and mrp>300
order by mrp desc;

--calculate estimated revenue for each category
select category, sum(discountedSellingPrice*quantity) as totalrevenue
from zepto
group by category
order by totalrevenue desc;

--find all the products where mrp is greater thhan rs500 and discount< 10%
select distinct name,mrp,discountPercent 
from zepto
where mrp>500 and discountPercent<10
order by mrp desc,discountPercent desc;

--identify the top 5 categories offering the highest average discount percentage
select category, 
round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--find the price per gram for products above 100g and sort by best value
select name, round(discountedSellingPrice/weightInGms,2)as price_per_gram
from zepto
where weightInGms>=100
order by price_per_gram desc;

--group the products into categories like low,medium,bulk
select distinct name,weightInGms,
case when weightInGms <1000 then 'low'
	when weightInGms <5000 then 'medium'
	else 'bulk'
	end as weightcategory
from zepto
order by weightcategory;

--what is the total inventory weight per category
select category, sum(weightInGms/quantity)as total_weight
from zepto
group by category
order by total_weight;


