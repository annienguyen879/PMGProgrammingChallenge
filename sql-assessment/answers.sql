-- Q1: sum of impressions by day
select date, sum(impressions) as total_impressions
from marketing_data
group by date;


-- Q2: top 3 revenue-generating states from best to worst
-- Ohio (third best) generated $37,577
select top 3 state, sum(revenue) as total_revenue 
from website_revenue
group by state
order by total_revenue desc;


-- Q3: total cost, impressions, clicks, and revenue of each campaign
with rev as (
		select campaign_id, sum(revenue) as total_revenue
		from website_revenue
		group by campaign_id
	),
	marketing as (
		select campaign_id, sum(cost) as total_cost, sum(impressions) as total_impressions, 
			sum(clicks) as total_clicks
		from marketing_data
		group by campaign_id
	)

select name, rev.campaign_id, total_cost, total_impressions, total_clicks, total_revenue
from campaign_info c
left join rev
on c.id = rev.campaign_id
left join marketing
on c.id = marketing.campaign_id;


-- Q4: # of conversions of campaign 5
-- GA generated the most conversions
with market as (
	select campaign_id, conversions, replace(geo, 'United States-', '') as geo
	from marketing_data
	)
select geo, sum(conversions) as total_conversions
from market
left join campaign_info c
on market.campaign_id = c.id
where name = 'Campaign5'
group by geo
order by total_conversions desc;


-- Q5: which campaign most efficient?
/*
To assess the efficiency of a campaign, we must look beyond website engagement. After calculating profit,
we see that Campaign3 produces the highest profit, but if we look at the marginal profit for each 
additional impression, marginal profit for Campaign5 far exceeds the other campaigns. 
Because Campaign5 produces the highest marginal profit, this would suggest that Campaign5 would be
the most efficient.
*/
with rev as (
		select campaign_id, sum(revenue) as total_revenue
		from website_revenue
		group by campaign_id
	),
	marketing as (
		select campaign_id, sum(cost) as total_cost, sum(impressions) as total_impressions, 
			sum(clicks) as total_clicks, sum(conversions) as total_conversions
		from marketing_data
		group by campaign_id
	)

select name, rev.campaign_id, total_revenue, total_cost, (total_revenue-total_cost) as profit, 
	((total_revenue-total_cost)/total_impressions) as marginal_profit,
	total_impressions, total_clicks, total_conversions
from campaign_info c
left join rev
on c.id = rev.campaign_id
left join marketing
on c.id = marketing.campaign_id
order by profit desc;

-- BONUS: best day of week to run ads
/* 
Based on this data, Friday is the best day because impressions, clicks, and conversions are higher overall.
*/
select datename(weekday, date) as weekday, sum(impressions) as impressions, 
	sum(clicks) as clicks, sum(conversions) as conversions
from marketing_data
group by datename(weekday, date)
order by impressions desc;
