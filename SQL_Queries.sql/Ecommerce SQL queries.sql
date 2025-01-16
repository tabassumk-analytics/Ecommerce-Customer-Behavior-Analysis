create table customer_behavior(
	customer_id serial primary key,
	gender varchar(10), age int, city varchar(50),
	membership_type varchar(20),
	total_spend numeric(10,2),
	items_purchased int,
	average_rating numeric(3,2),
	discount_applied boolean,
	days_since_last_purchase int,
	satisfaction_level varchar(20)
)

select * from customer_behavior

--Check for Duplicates
select customer_id, count(*)
from customer_behavior
group by customer_id
having count(*)>1

---Check for Missing Data

select count(*) as null_count
from customer_behavior
where gender is null
	or age is null
	or city is null
	or membership_type is null
	or total_spend is null
	or items_purchased is null
	or average_rating is null
	or discount_applied is null
	or days_since_last_purchase is null
	or satisfaction_level is null
	
--Identify Missing Data Rows
--Run this query to see the rows with missing data:	
	
select *
from customer_behavior
where gender is null
	or age is null
	or city is null
	or membership_type is null
	or total_spend is null
	or items_purchased is null
	or average_rating is null
	or discount_applied is null
	or days_since_last_purchase is null
	or satisfaction_level is null

--Delete Rows with Missing Data

DELETE FROM customer_behavior
WHERE satisfaction_level IS NULL;

--Gender Distribution

SELECT gender, count(*)as count
	from customer_behavior
	group by gender

---Membership Type Distribution
select membership_type, count(*) as count
from customer_behavior
group by membership_type
order by count desc


-- City-wise Customer Count
SELECT City, count(*)as customer_count
	from customer_behavior
	group by city
	order by customer_count desc


--Average Spend by Membership Type
select 
	membership_type, 
	round(avg(total_spend),2) as avg_spend
from customer_behavior
group by membership_type
order by avg_spend desc

--Rating Distribution
SELECT ROUND(average_rating) AS rating, COUNT(*) AS count
FROM customer_behavior
GROUP BY ROUND(average_rating)
ORDER BY rating;

-- Impact of Discounts on Spending
select
	discount_applied,
	round(avg(total_spend),2) as avg_spend
from customer_behavior
group by discount_applied

--Retention Analysis (Days Since Last Purchase)

select
	case
		when days_since_last_purchase <=30 then 'Active(0-30 days)'
		when days_since_last_purchase between 31 and 90 then 'Dormant (31-90 Days)'
		else 'Inactive(>90 days)'
	end as customer_status,
	count(*) as customer_count
from customer_behavior
group by customer_status
order by customer_status

--Correlation Between Total Spend and Items Purchased

SELECT round(cast(corr(total_spend, items_purchased)as numeric),2) as correlation
FROM customer_behavior;

--Spending Patterns by Satisfaction Level

Select
	Satisfaction_level,
	round(avg(total_spend),2)as avg_spend
from customer_behavior
group by satisfaction_level
order by avg_spend desc

--Spending Trends by Age Group
--*Key demographics contributing the most to revenue.
--*Opportunities for targeted marketing campaigns based on age-specific preferences.

select
	case
		when age between 18 and 25 then '18-25'
		when age between 26 and 35 then '26-35'
		when age between 36 and 50 then '36-50'
		else '51+'
	end as Age_group,
	round(avg(total_spend),2) as avg_spend,
	count(*) as customer_count
from customer_behavior
group by age_group
order by avg_spend desc

--Membership Type Trends by Age Group
--Age groups that prefer premium memberships (e.g., Gold).
--Target segments for upselling or tier-specific campaigns.

select 
	case
		when age between 18 and 25 then '18-25'
		when age between 26 and 35 then '26-35'
		when age between 36 and 50 then '36-50'
		else '51+'
	end as age_group,
	membership_type,
	count(*) customer_count
from customer_behavior
group by age_group, membership_type
order by age_group, customer_count desc

--Discount Effectiveness by Membership Tier

select
	membership_type,
	discount_applied,
	round(avg(total_spend),2) as avg_spend,
	count(*) as customer_count,
	round(100.0*count(*)/sum(count(*)) over(),2) as percentage ---The OVER () clause ensures this total is computed for the entire dataset.
from customer_behavior
group by membership_type, discount_applied
order by membership_type, discount_applied


--for each memb_type---
SELECT 
    membership_type,
    discount_applied,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY membership_type), 2) AS percentage_within_type
FROM customer_behavior
GROUP BY membership_type, discount_applied
ORDER BY membership_type, discount_applied;

--Days Since Last Purchase by Membership Type

 select
 	membership_type,
	round(avg(days_since_last_purchase),0) as avg_days_since_last_purchase,
	count(*) as customer_count
from customer_behavior
group by membership_type
order by avg_days_since_last_purchase asc