/*
Total Cost Of Orders


Last Updated: June 2026

Easy
ID 10183

198

Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.

Tables
customers
orders

Topic Family
Aggregate Functions
Aggregations
Data Retrieval Basics
Grouped Aggregates
Joins & Set Operations
Join Types
Sorting Results
Topic Functions
sum()

customers
Preview
address:
text
city:
text
first_name:
text
id:
bigint
last_name:
text
phone_number:
text
orders
Preview
cust_id:
bigint
id:
bigint
order_date:
date
order_details:
text
total_order_cost:
bigint
*/

select c.id, c.first_name, sum(o.total_order_cost) as total_order_cost
from customers c 
join orders o on c.id = o.cust_id
group by c.id, c.first_name
order by c.first_name;
