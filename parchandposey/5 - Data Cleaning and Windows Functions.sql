/*************** LEFT & RIGHT ***************/

/*1) In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are using. 
A list of extensions (and pricing) is provided at https://iwantmyname.com/domains. 
Pull these extensions and provide how many of each website type exist in the accounts table. */
select right(website,3) as extension, count(*) as count
from accounts
group by right(website,3)

/*2) There is much debate about how much the name (or even the first letter of a company name) matters. 
Use the accounts table to pull the first letter of each company name to see 
the distribution of company names that begin with each letter (or number).*/
select left(name, 1) as first_letter, count(*) as count
from accounts
group by left(name, 1)
order by left(name, 1)

/*3) Use the accounts table and a CASE statement to create two groups: 
one group of company names that start with a number 
and a second group of those company names that start with a letter. 
What proportion of company names start with a letter?*/

with letter_type as (select case when isnumeric(left(name,1)) = 0 then 'Letter' else 'Number' end as first_type
from accounts)
select (cast(count_letter as float)/ cast(total as float)) as proportion
from (select top 1 (select count(first_type) as letter from letter_type where first_type = 'Letter') as count_letter, count(first_type) as total 
from letter_type) as first_types

/*4) Consider vowels as a, e, i, o, and u. 
What proportion of company names start with a vowel, and what percent start with anything else?*/
with vowels as (select name as vowels_comp from accounts where left(name,1) in ('A','E','I','O','U'))
select cast(vowel_counts as float)/cast(total as float)as vowels_proportion
from(select top 1 (select count(vowels_comp) as jumlah from vowels) as vowel_counts, count(*) as total from accounts) as final

/****** POSITION & STRPOS *************/

/*1)Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.*/
select primary_poc,
left(primary_poc, charindex(' ', primary_poc) - 1) as FirstName,
reverse(substring(reverse(primary_poc), 1, charindex(' ', reverse(primary_poc)) - 1))  as LastName
from accounts


/*2) Now see if you can do the same thing for every rep name in the sales_reps table. 
Again provide first and last name columns.*/
select left(name, charindex(' ', name) - 1) as FirstName,
reverse(substring(reverse(name), 1, charindex(' ', reverse(name)) - 1))  as LastName
from sales_reps

/****** CONCATE or || *************/

/*1/2)Each company in the accounts table wants to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.*/
select concat(FirstName, '.', LastName, '@', company, '.com') as primary_poc_email
from (select primary_poc,
	left(primary_poc, charindex(' ', primary_poc) - 1) as FirstName,
	reverse(substring(reverse(primary_poc), 1, charindex(' ', reverse(primary_poc)) - 1))  as LastName,
	replace(name, ' ', '') as company
	from accounts) as first_last


/*We would also like to create an initial password, which they will change after their first log in. 
The first password will be the first letter of the primary_poc's first name (lowercase), 
then the last letter of their first name (lowercase), 
the first letter of their last name (lowercase), 
the last letter of their last name (lowercase), 
the number of letters in their first name, 
the number of letters in their last name, 
and then the name of the company they are working with, 
all capitalized with no spaces.
*/
with letters as(select left(lower(primary_poc),1) as letter_1,
	right(charindex(' ', primary_poc) - 1,1) as letter_2,
	left(reverse(substring(reverse(primary_poc), 1, charindex(' ', reverse(primary_poc)) - 1)),1) as letter_3,
	right(primary_poc,1) as letter_4,
	charindex(' ', primary_poc) - 1 as letter_5,
	charindex(' ', reverse(primary_poc)) - 1 as letter_6,
	replace(name, ' ', '') as company_name
from accounts)
select concat (letter_1,letter_2,letter_3,letter_4,letter_5,letter_6,company_name) as email_password from letters

----------------------------------------------------------------

/*create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. 
Your final table should have two columns: 
one with the amount being added for each new row, and a second with the running total.*/
select occurred_at, standard_amt_usd, sum(standard_amt_usd) over(order by occurred_at) as cumulative
from orders

/*create a running total of standard_amt_usd (in the orders table) over order time, 
but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. 
Your final table should have three columns: One with the amount being added for each row, 
one for the truncated date, and a final column with the running total within each year.*/
select year, yearly_amt_usd, sum(yearly_amt_usd) over(order by year) as cumulative
from
	(select year(occurred_at) as year, sum(standard_amt_usd) as yearly_amt_usd
	from orders
	group by year(occurred_at)) as amt

/*Ranking Total Paper Ordered by Account
Select the id, account_id, and total variable from the orders table, 
then create a column called total_rank that ranks this total amount of paper ordered 
(from highest to lowest) for each account using a partition. Your final table should have these four columns.*/
select id, account_id,total, rank() over(partition by account_id order by total desc) as rank
from orders

/*you want to determine how the current order's total revenue 
("total" meaning from sales of all types of paper) 
compares to the next order's total revenue.
there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.*/
with next_order_cte as (select lead(total_amt_usd) over(order by occurred_at) as lead_amt,occurred_at as current_order, total_amt_usd 
from orders)
select current_order, total_amt_usd, lead_amt, lead_amt-total_amt_usd as lead_differences
from next_order_cte

/*Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty 
for their orders. Your resulting table should have the account_id, the occurred_at time for each order, 
the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.*/
select account_id, occurred_at, standard_qty, ntile(4) over(order by standard_qty desc) as standard_quartile
from orders

/*Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty 
for their orders. Your resulting table should have the account_id, 
the occurred_at time for each order, the total amount of gloss_qty paper purchased, 
and one of two levels in a gloss_half column.
*/
select account_id, occurred_at, gloss_qty, ntile(2) over(partition by account_id order by gloss_qty) as gloss_half
from orders

/*Use the NTILE functionality to divide the orders for each account into 100 levels 
in terms of the amount of total_amt_usd for their orders. 
Your resulting table should have the account_id, the occurred_at time for each order, 
the total amount of total_amt_usd paper purchased,
and one of 100 levels in a total_percentile column.*/
select account_id, occurred_at, total_amt_usd, 
ntile(100) over(partition by account_id order by total_amt_usd) as total_percentile
from orders