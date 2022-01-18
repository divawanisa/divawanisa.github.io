/*Find the total amount of poster_qty paper ordered in the orders table.*/
select sum(poster_qty) from orders

/*Find the total amount of standard_qty paper ordered in the orders table.*/
select sum(standard_qty) from orders

/*Find the total dollar amount of sales using the total_amt_usd in the orders table.*/
select sum(total_amt_usd) as total_amt_usd from orders

/*Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table.*/
select standard_amt_usd + gloss_amt_usd as sum from orders

/*Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation 
and a mathematical operator.*/
select avg (standard_amt_usd/standard_qty) as standard_unit_price from orders

/*When was the earliest order ever placed? You only need to return the date.*/
select min(convert(date,occurred_at)) as earliest_date from orders

/*Try performing the same query as in question 1 without using an aggregation function.*/
select top 1 convert(date,occurred_at) as earliest_date from orders order by occurred_at desc

/*When did the most recent (latest) web_event occur?*/
select min(occurred_at) as latest_web_event from web_events

/*Try to perform the result of the previous query without using an aggregation function.*/
select top 1 convert(date,occurred_at) as earliest_date from web_events order by occurred_at desc

/*Find the mean (AVERAGE) amount spent per order on each paper type, as well as 
the mean amount of each paper type purchased per order. 
Your final answer should have 6 values - one for each paper type for the average number of sales, 
as well as the average amount.*/
select avg(standard_qty) as avg_standard_qty, avg(gloss_qty) as avg_gloss_qty, avg(poster_qty) as avg_poster_qty,
avg(standard_amt_usd) as avg_standard_amt_usd, avg(gloss_amt_usd) as avg_gloss_amt_usd, avg(poster_amt_usd) as avg_poster_amt_usd
from orders

/*Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced 
than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?*/

select count(*) from orders /*there are 6912 orders -- even number*/
select avg(total_amt_usd) from orders
where id = 6912/2 or id = (6912/2)+1


/*Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.*/
select top 1 a.name, o.occurred_at
from orders as o join accounts as a
on o.account_id = a.id
order by o.occurred_at desc

/*Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd 
and the company name.*/
select a.name as company_name, sum(o.total) as total_sales
from orders as o join accounts as a
on o.account_id = a.id
group by a.name

/*Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.*/
select top 1 w.occurred_at, w.channel, a.name as account_name
from accounts as a join web_events as w
on a.id = w.account_id
order by w.occurred_at desc

/*Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the number of times the channel was used.*/
select channel, count(channel) as count
from web_events
group by channel

/*Who was the Sales Rep associated with the earliest web_event?*/
select top 1 s.name
from web_events as w join accounts as a
on w.account_id = a.id
join sales_reps as s on s.id = a.sales_rep_id
order by w.occurred_at desc

/*Who was the primary contact associated with the earliest web_event?*/
select top 1 a.primary_poc
from web_events as w join accounts as a
on w.account_id = a.id
order by w.occurred_at desc

/*What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/
select a.name, o.total_amt_usd
from orders as o join accounts as a
on a.id = o.account_id
order by o.total_amt_usd asc

/*Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.*/
select r.name, count(s.name)
from region as r join sales_reps as s
on r.id = s.region_id
group by r.name
order by count(s.name)

/*For each account, determine the average amount of each type of paper they purchased across their orders. 
Your result should have four columns - one for the account name and one for the average quantity purchased 
for each of the paper types for each account.*/
select a.name, avg(o.standard_qty) as avg_standard, avg(o.gloss_qty) as avg_gloss, avg(o.poster_qty) as avg_poster
from accounts as a join orders as o
on a.id = o.account_id
group by a.name

/*For each account, determine the average amount spent per order on each paper type. 
Your result should have four columns - one for the account name and one for the average amount spent on each paper type.*/
select a.name, avg(o.standard_amt_usd) as avg_standard_amt_usd, avg(o.gloss_amt_usd) as avg_gloss_amt_usd, avg(o.poster_amt_usd) as avg_poster_amt_usd
from accounts as a join orders as o
on a.id = o.account_id
group by a.name

/*Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/
select s.name, w.channel, count(w.channel) as channel_usage_count
from web_events as w join accounts as a
on w.account_id = a.id join sales_reps as s
on a.sales_rep_id = s.id
group by s.name, w.channel
order by s.name, count(w.channel) desc

/*Determine the number of times a particular channel was used in the web_events table for each region. 
Your final table should have three columns - the region name, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/
select r.name, w.channel, count(w.channel) as channel_usage_count
from web_events as w join accounts as a
on w.account_id = a.id join sales_reps as s
on a.sales_rep_id = s.id join region as r
on s.region_id = r.id
group by r.name, w.channel
order by r.name, count(w.channel) desc

/*Use DISTINCT to test if there are any accounts associated with more than one region.*/
/*answer: every account name has one region*/
select distinct a.name, r.name
from accounts as a join sales_reps as s
on a.sales_rep_id = s.id join region as r
on s.region_id = r.id
order by a.name

/*Have any sales reps worked on more than one account?*/
/* answer: yes, it seems that every sales reop worked on more than one account*/
select s.name, count(a.name) as account_count
from sales_reps as s join accounts as a
on a.sales_rep_id = s.id
group by s.name

/*How many of the sales reps have more than 5 accounts that they manage?*/
/*answer: there are 34 sales reps who managed more than 5 accounts*/
with counting as (select s.name as sales_rep, count(a.name) as account_count
from sales_reps as s join accounts as a
on a.sales_rep_id = s.id
group by s.name)

select count(sales_rep)
from counting
where account_count > 5

/*How many accounts have more than 20 orders?*/
/* answer: there are about 120 account that have more than 20 orders*/
select count(account) as account_more_20_orders
from (
	select a.name as account, count(o.id) as order_count
	from accounts as a join orders as o on o.account_id = a.id
	group by a.name) as yahu
where order_count > 20

/*Which account has the most orders?*/
/* answer: Leucadia National */
select top 1 account
from (
	select a.name as account, count(o.id) as order_count
	from accounts as a join orders as o on o.account_id = a.id
	group by a.name) as yahu
order by order_count desc

/*Which accounts spent more than 30,000 usd total across all orders?*/
/*answer: Almost all accounts spent more than 30,000 usd (there are 350 out of 351 accounts) */
select account
from (
	select a.name as account, sum(o.total_amt_usd) as order_total
	from accounts as a join orders as o on o.account_id = a.id
	group by a.name) as yahu1
where order_total > 30000

/*Which accounts spent less than 1,000 usd total across all orders?*/
/*answer: there is no account with spending number less than 1000 usd*/
select account
from (
	select a.name as account, sum(o.total_amt_usd) as order_total
	from accounts as a join orders as o on o.account_id = a.id
	group by a.name) as yahu1
where order_total <1000

/*Which account has spent the most with us?*/
/*answer: EOG Resources*/
select top 1 a.name
from accounts as a join orders as o on o.account_id = a.id
group by a.name
order by sum(o.total_amt_usd) desc

/*Which account has spent the least with us?*/
/*answer: Nike*/
select top 1 a.name
from accounts as a join orders as o on o.account_id = a.id
group by a.name
order by sum(o.total_amt_usd)

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/
select a.name
from accounts as a join web_events as w
on a.id = w.account_id
where w.channel like 'facebook'
group by a.name
having count(w.channel) > 6

/*Which account used facebook most as a channel?*/
/*answer: these are 9 accounts that used facebook most as a channel*/
select account
from(
	select a.name as account, w.channel, row_number()over(partition by a.name order by a.name, count(w.channel) desc) as the_rank
	from accounts as a join web_events as w
	on a.id = w.account_id
	group by a.name, w.channel) as channel_rank
where the_rank = 1 and channel = 'facebook'


/*Which channel was most frequently used by most accounts?*/
/*answer: direct channel */
select top 1 w.channel, count(a.name) as account_number
from accounts as a join web_events as w
on a.id = w.account_id
group by w.channel
order by count(a.name) desc


/*Which channel was most frequently used by most accounts? (including account name)*/
/*answer: the most frequent account is Leucisia National with 52 times using direct channel */

select top 1 w.channel, a.name,count(a.name) as account_number
from accounts as a join web_events as w
on a.id = w.account_id
group by a.name, w.channel
order by count(a.name) desc

/*Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals*/
/* answer: the trend is increasing from 2013 until 2016, and decreasing from 2016 to 2017 */
select year(occurred_at) as year, sum(total_amt_usd) as total_usd
from orders
group by year(occurred_at)
order by year(occurred_at)


/*Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?*/
/* Answer: December*/
select month(occurred_at) as month, count(*) as total_order,sum(total_amt_usd) as total_usd
from orders
group by month(occurred_at)
order by total_usd desc

/* continued answer: it seems that year 2013 and 2017 consist of only one month, which causes extra sales count
for certain months like January and December*/
select year(occurred_at) as year, month(occurred_at) as month, count(month(occurred_at)) as count
from orders
group by year(occurred_at), month(occurred_at)
order by year

/*Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset?*/
/* Answer: 2016. The years are not evenly represented because there is only one month sales data in 2013 and 2017*/
select year(occurred_at) as year, sum(total) as total_sales
from orders
group by year(occurred_at)
order by total_sales desc

/*Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all months evenly represented by the dataset?*/
/* Answer: December. it seems that year 2013 and 2017 consist of only one month, which causes extra sales count
for certain months like January and December*/

select month(occurred_at) as month, sum(total) as total_sales
from orders
group by month(occurred_at)
order by total_sales desc

/*In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/
/*Answer: The fifth month of the year, May */
select top 1 month(o.occurred_at) as month, sum(o.gloss_qty) as total_gloss_paper
from orders as o join accounts as a
on o.account_id = a.id
where a.name = 'Walmart'
group by month(o.occurred_at)
order by total_gloss_paper desc

/*Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’
- depending on if the order is $3000 or more, or smaller than $3000.*/
select a.id, count(total) as total_order,
	case when sum(total_amt_usd) <3000 then 'Small'
		 else 'Big' end as order_size
from orders as o join accounts as a
on o.account_id = a.id
group by a.id

/*Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/
select id, case when total<=1000 then 'Less than 1000'
				when total>1000 and total<2000 then 'Between 1000 and 2000'
				else 'At least 2000' end as category
from orders

/*We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. 
The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. 
You should provide the account name, the total sales of all orders for the customer, and the level. 
Order with the top spending customers listed first.*/
select a.name, sum(o.total_amt_usd) as total_sales,
		case when sum(o.total_amt_usd) >= 200000 then 'Top Level'
			 when sum(o.total_amt_usd) >100000 and sum(o.total_amt_usd) < 200000 then 'Mid Level'
			 else 'Low Level' end as account_level
from orders as o join accounts as a
on o.account_id = a.id
group by a.name
order by sum(o.total_amt_usd) desc

/*We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. Order with the top spending customers listed first.*/
select a.name, sum(o.total_amt_usd) as total_sales,
		case when sum(o.total_amt_usd) >= 200000 then 'Top Level'
			 when sum(o.total_amt_usd) >100000 and sum(o.total_amt_usd) < 200000 then 'Mid Level'
			 else 'Low Level' end as account_level
from orders as o join accounts as a
on o.account_id = a.id
where year(o.occurred_at) = 2016 or year(o.occurred_at) = 2017
group by a.name
order by sum(o.total_amt_usd) desc

/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.*/
select s.name, count(*) as total_order,
	case when count(*)> 200 then 'Top'
		 else 'Not Top' end as category
from orders as o join accounts as a
on o.account_id = a.id join sales_reps as s
on a.sales_rep_id = s.id
group by s.name
order by total_order desc


/*The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 
We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders 
or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
Create a table with the sales rep name, the total number of orders, total sales across all orders, 
and a column with top, middle, or low depending on this criteria. 
Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!*/
select s.name, count(*)  as total_order, sum(o.total_amt_usd) as total_sales,
	case when count(*)> 200 or count(o.total_amt_usd) > 750000 then 'Top'
		 when count(*)> 150 or count(o.total_amt_usd) > 500000 then 'Middle'
		 else 'Low' end as category
from orders as o join accounts as a
on o.account_id = a.id join sales_reps as s
on a.sales_rep_id = s.id
group by s.name
order by total_order desc

