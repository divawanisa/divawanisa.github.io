/*Say you're an analyst at Parch & Posey and you want to see:
each account who has a sales rep and each sales rep that has an account 
(all of the columns in these returned rows will be full)
but also each account that does not have a sales rep and each sales rep that does not have an account 
(some of the columns in these returned rows will be empty)*/
select a.name as account, s.name as sales_rep_name
from accounts as a full join sales_reps as s on a.sales_rep_id = s.id

/* To see rows where 1) Companies without sales rep OR 2)sales rep without accouts */
select a.name as account, s.name as sales_rep_name
from accounts as a full join sales_reps as s on a.sales_rep_id = s.id
where a.name = NULL or s.name = null

/*Inequality Join
 write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number 
 and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name
The query results should be a table with three columns: 
the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), 
and the sales representative's name (e.g. Samuel Racine)*/
select a.name as account_name, primary_poc, s.name as sales_rep_name
from accounts as a left join sales_reps as s on a.sales_rep_id = s.id and a.primary_poc < s.name

/*Getting list of web events which happens one day duration one after another*/
with crossjoincol as (select occurred_at from web_events)
select web1.id, w1.occurred_at as w1_time,web2.id, w2.occurred_at as w2_time, datediff(day,w1.occurred_at, w2.occurred_at) as day_difference
from crossjoincol as w1 cross join crossjoincol as w2
join web_events as web1 on web1.occurred_at = w1.occurred_at join web_events as web2 on web2.occurred_at = w2.occurred_at
where datediff(day,w1.occurred_at, w2.occurred_at) = 1


/* UNION ALL vs UNION */
/*Nice! UNION only appends distinct values. 
More specifically, when you use UNION, the dataset is appended, and any rows in the appended table 
that are exactly identical to rows in the first table are dropped. 
If you’d like to append all the values from the second table, use UNION ALL. 
You’ll likely use UNION ALL far more often than UNION.*/
select *
from accounts as a1 where name like 'Nike'
union all select * from accounts as a2 where name like 'Walmart'

/*Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and 
name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. 
If you do this correctly, your query results should have a count of 2 for each name.*/
with double_accounts as (
select *
from accounts as a1
union all select * from accounts as a2)

select name, count(*) as count
from double_accounts
group by name







