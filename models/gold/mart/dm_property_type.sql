{{ 
    config(
        materialized='view',
        alias='dm_property_type'
    ) 
}}

with active_listings as (
    select 
        property_type,
        room_type,
        accommodates,
        date_trunc('month', scraped_date) as month_year,
        price,
        review_scores_rating,
        host_id,
        host_is_superhost,
        has_availability,
        availability_30,
        (30 - availability_30) as number_of_stays,
        (price * (30 - availability_30)) as estimated_revenue
    from {{ ref('fact_listings') }}
    where has_availability = 't'
),
agg_metrics as (
    select 
        property_type,
        room_type,
        accommodates,
        month_year,
        count(*) as total_listings,
        count(*) * 100.0 / nullif(count(*) over (partition by property_type, room_type, accommodates, month_year), 0) as active_listings_rate,
        min(price) as min_price,
        max(price) as max_price,
        percentile_cont(0.5) within group (order by price) as median_price,
        avg(price) as avg_price,
        count(distinct host_id) as distinct_hosts,
        count(distinct case when host_is_superhost = 't' then host_id end) * 100.0 / nullif(count(distinct host_id), 0) as superhost_rate,
        avg(review_scores_rating) as avg_review_scores_rating,
        sum(number_of_stays) as total_number_of_stays,
        avg(estimated_revenue) as avg_estimated_revenue_per_active_listing
    from active_listings
    group by property_type, room_type, accommodates, month_year
),
changes as (
    select
        property_type,
        room_type,
        accommodates,
        month_year,
        (active_listings_rate - lag(active_listings_rate) over (partition by property_type, room_type, accommodates order by month_year)) 
        * 100 / nullif(lag(active_listings_rate) over (partition by property_type, room_type, accommodates order by month_year), 0) 
        as pct_change_active_listings,
        
        (100 - active_listings_rate - lag(100 - active_listings_rate) over (partition by property_type, room_type, accommodates order by month_year)) 
        * 100 / nullif(lag(100 - active_listings_rate) over (partition by property_type, room_type, accommodates order by month_year), 0) 
        as pct_change_inactive_listings
    from agg_metrics
)

select 
    a.*,
    c.pct_change_active_listings,
    c.pct_change_inactive_listings
from agg_metrics a
left join changes c 
    on a.property_type = c.property_type 
    and a.room_type = c.room_type 
    and a.accommodates = c.accommodates 
    and a.month_year = c.month_year
order by property_type, room_type, accommodates, month_year
