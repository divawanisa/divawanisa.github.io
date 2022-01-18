/*number of events that occur for each day for each channel*/
select channel, day(occurred_at) as day, count(*) as count
from web_events
group by channel, day(occurred_at)
order by channel, day

/*list of orders happended at the first month in P&P history , ordered by occurred_at */
select id
from orders
where 
month(occurred_at) =  (select top 1 month(occurred_at) as month_1
						from orders
						group by year(occurred_at), month(occurred_at)
						order by year(occurred_at), month(occurred_at)) 
and year(occurred_at) = (select top 1 year(occurred_at) as year_1
						from orders
						group by year(occurred_at)
						order by year(occurred_at)) 

/*list of orders happended at the first day in P&P history , ordered by occurred_at */
select id
from orders
where convert(date,occurred_at) = (select top 1 convert(date,occurred_at)
					from orders
					order by occurred_at)

/*average of paper quantity happended at the first month in P&P history*/
select top 1 year(occurred_at) as year, month(occurred_at) as month, avg(total) as avg_paper_quantity
from orders
group by year(occurred_at), month(occurred_at)
order by year(occurred_at), month(occurred_at)

/*sales rep total sales for each region*/
select s.name as sales_rep_name, r.name as region, sum(o.total_amt_usd) as total_sales_in_usd
from orders as o join accounts as a on o.account_id = a.id
join sales_reps as s on a.sales_rep_id = s.id
join region as r on s.region_id = r.id
group by s.name, r.name
order by s.name, r.name

/*maximum total sales in each region*/
select r.name as region,max(o.total_amt_usd) as max_sale_in_usd
from orders as o join accounts as a on o.account_id = a.id
join sales_reps as s on a.sales_rep_id = s.id
join region as r on s.region_id = r.id
group by r.name

/*1) Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/
select region, sales_rep
from(select r.name as region, s.name as sales_rep, row_number()over(partition by r.name order by sum(total_amt_usd) desc) as the_rank
	from orders as o join accounts as a on o.account_id = a.id
	join sales_reps as s on a.sales_rep_id = s.id
	join region as r on s.region_id = r.id
	group by r.name, s.name) as channel_rank
where the_rank = 1

/*2) For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?*/
select top 1 count(*) as order_count
from orders as o join accounts as a on o.account_id = a.id
join sales_reps as s on a.sales_rep_id = s.id
join region as r on s.region_id = r.id
group by r.name
order by sum(total_amt_usd) desc