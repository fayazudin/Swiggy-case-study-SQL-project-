
SELECT* FROM orders;
--Swiggy Case Study-

1. Find customers who have never ordered
Query- 
select name from users where user_id not in (select user_id from orders);

2. Find the average price per dish? Sort the output in descending based on avg_price field.
Query-
select f_name, round(avg(price),2) as avg_price from food f join menu m on f.f_id=m.f_id group by f_name order
by avg_price desc;

3. Find the top restaurant in terms of the number of orders for a given month?
Query-
select monthname(date) as month, r_name, count(o.r_id) as total_orders from orders o join restaurants r on 
o.r_id=r.r_id where monthname(date) like "may" group by month, r_name order by total_orders desc limit 1;

4. Find restaurants with monthly sales greater than 500 for 
Query 1-
select monthname(date) as month, r_name, sum(amount) as total_sales from orders o join restaurants r on 
o.r_id=r.r_id group by month, r_name  having (total_sales>500);
Or 
Query 2-
select o.r_id, r_name, sum(amount) as total_sales from orders o join restaurants r on 
o.r_id=r.r_id where monthname(date) like 'june' 
 group by r_id, r_name having(total_sales>500);
 
5. Show all orders with order details for a particular customer in a particular date range
Query-
select o.order_id, r.r_name, o.user_id, u.name, ro.f_id , f.f_name, o.amount
from orders o join order_details ro on o.order_id=ro.order_id 
join users u on o.user_id= u.user_id join food f on f.f_id=ro.f_id join restaurants r on 
r.r_id=o.r_id
where u.name='neha' and date>'2022-06-10' and date<'2022-07-10';

6. Find restaurants with max repeated customers 
Query-
with cte1 as
(select o.r_id, u.user_id, u.name, count(*) as visits from orders o
join users u on o.user_id=u.user_id group by o.r_id, u.user_id having (visits>1))
select r_id, user_id, name, count(*) as loyal_customers from cte1 group by r_id, user_id;

7. Month over month revenue growth of swiggy
Query 1-
with cte1 as(
select monthname(date) as month, sum(amount) as revenue from orders group by month order by month desc),
cte2 as (select month, revenue, lag(revenue,1) over() as prev_r from cte1)
select * , (revenue- prev_r)*100/prev_r as mom_growth from cte2;

Or 

Query 2-
select month, ((revenue- prev_r)/prev_r*100)as mom_growth from (
with cte1 as(
select monthname(date) as month, sum(amount) as revenue from orders group by month order by month desc)
select month, revenue, lag(revenue,1) over() as prev_r from cte1) t;

8. Month over month revenue growth of all restaurants
Query-
with cte1 as(
select r_name, monthname(date) as month, sum(amount) as revenue from orders o 
join restaurants r on o.r_id=r.r_id group by r_name, month order by month desc),
cte2 as (select r_name, month, revenue, lag(revenue,1) over(partition by r_name) as prev_r from cte1)
select * , (revenue- prev_r)*100/prev_r as mom_growth from cte2;

9. Find customers - favorite food
Query 1- 
with cte1 as (select o.*, od.f_id, u.name, f.f_name from orders o join order_details od on o.order_id= od.order_id
join users u on u.user_id=o.user_id join food f on f.f_id = od.f_id)
select name, f_name, count(f_id) frequency  from cte1 group by f_id, name order by 
frequency desc;

Or

Query 2-
with cte1 as (
select u.name, f.f_name, count(*) as frequency from orders o join order_details od on o.order_id= od.order_id
join users u on u.user_id=o.user_id join food f on f.f_id = od.f_id
group by u.name, f.f_name) 
select * from cte1 t where frequency = (select max(frequency) from cte1 t2 where t.name=t2.name);


