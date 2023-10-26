#question 1
select CAST(date AS DATE) as day, sum(impressions) as impression_sum from marketing_performance 
group by CAST(date AS DATE) order by day;

#question2
select state, revenue_sum from (
select state, sum(revenue) as revenue_sum, dense_rank() over (order by sum(revenue) desc) as rk
from website_revenue group by state) t
where rk <= 3;

#The third best state is OH, generating a total revenue of $37577.
select state, revenue_sum from (
select state, sum(revenue) as revenue_sum, dense_rank() over (order by sum(revenue) desc) as rk
from website_revenue group by state) t
where rk = 3;

#question3
select a.name, b.totalcost, b.totalimpressions, b.totalclicks, c.totalrevenue from campaign_info as a 
right join (select campaign_id, sum(cost) as totalcost,
sum(impressions) as totalimpressions, sum(clicks) as totalclicks from marketing_performance group by campaign_id) b
on a.id = b.campaign_id
left join (select campaign_id, sum(revenue) as totalrevenue from website_revenue group by campaign_id) c 
on c.campaign_id = b.campaign_id
order by a.name;

#question 4
select geo, sum(conversions) as num_of_conversions from campaign_info as a right join marketing_performance as b
on a.id = b.campaign_id where a.name = 'Campaign5'
group by geo order by num_of_conversions desc;
#State GA generates the most conversions for this campaign 5

#question 5

select a.name, b.mktcounts, c.webcounts, b.avgcost, b.avgimpressions, b.avgclicks, c.avgrevenue from campaign_info as a 
right join (select campaign_id, count(date) as mktcounts, avg(cost) as avgcost,
avg(impressions) as avgimpressions, avg(clicks) as avgclicks from marketing_performance group by campaign_id) b
on a.id = b.campaign_id
left join (select campaign_id, count(date) as webcounts, avg(revenue) as avgrevenue from website_revenue group by campaign_id) c 
on c.campaign_id = b.campaign_id
order by a.name;
/*
In my opnion, campaign 4 was the most efficient
To evaluate the performances of campaigns fairly, 
first I observe if the number of activites hold by each campaign are equal across campaigns.
And the result is they are unequal. Some campaigns have done more marketing or website activites than others.
Using the result derived from question 3 to address which campaign is effecient would be biased.
Instead of using sum to calculate each campaign's cost, impressions, clicks, and revenue,
I choose to average these quantities to elimiate the bias existing in question 3 and drive a reasonable conclusion.
After average, I could learn that campaign 4 used the least cost and received the largest revenue compared to all the others.
And this campaign reached customers the most successfully that it left more impressions than others.
It possibly illustrates campaign would lead to customers' future purchase and explains why the largest revenue is generated.
Thus, I would say campaign 4 was the most efficient.
*/

# bonus question
select dayname(b.date) as day_in_week, avg(a.cost) as avgcost, avg(a.impressions) as avgimpression, 
avg(a.clicks) as avgclick, avg(a.conversions) as avgconversion, avg(b.revenue) as avgrevenue
from marketing_performance as a right join 
website_revenue as b on dayname(a.date) = dayname(b.date)
group by dayname(b.date)
order by FIELD(day_in_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
/*
(There are no data about campaign activities on Tuesday in marketing_performance data, so that's why they are null)
The best day would be Wednesday.
Although Sunday generated the most revenue, it used the most cost compared with others.
And Wednesday is the day of the week that generated the second most revenue on average, as well as spending the least cost.
Its conversion number is also the highest, which means the customers would be more likely to 
convert from a viewer of advertisment to a buyer of the product due to the advertisement on Wednesday.
*/