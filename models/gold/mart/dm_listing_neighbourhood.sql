{{
    config(
        materialized='view',
        alias='dm_listing_neighbourhood'
    )
}}

with listing_data as (
    select
        listing_neighbourhood,
        date_trunc('month', scraped_date) as month_year,
        listing_id,
        host_id,
        price,
        review_scores_rating,
        host_is_superhost,
        has_availability,
        30 - availability_30 as number_of_stays
    from {{ ref('fact_listings') }}
),

agg_metrics as (
    select
        listing_neighbourhood,
        month_year,
        count(distinct listing_id) filter (where has_availability='t') * 1.0 / nullif(count(distinct listing_id),0) * 100 as active_listings_rate,
        count(distinct listing_id) filter (where has_availability='f') * 1.0 / nullif(count(distinct listing_id),0) * 100 as inactive_listings_rate,
        min(price) filter (where has_availability='t') as min_price,
        max(price) filter (where has_availability='t') as max_price,
        percentile_cont(0.5) within group (order by price) filter (where has_availability='t') as median_price,
        avg(price) filter (where has_availability='t') as avg_price,
        count(distinct host_id) as distinct_hosts,
        count(distinct host_id) filter (where host_is_superhost='t') * 1.0 / nullif(count(distinct host_id),0) * 100 as superhost_rate,
        avg(review_scores_rating) filter (where has_availability='t') as avg_review_score,
        sum(number_of_stays) filter (where has_availability='t') as total_stays,
        avg(number_of_stays * price) filter (where has_availability='t') as avg_estimated_revenue
    from listing_data
    group by listing_neighbourhood, month_year
),

pct_change as (
    select
        listing_neighbourhood,
        month_year,
        active_listings_rate,
        inactive_listings_rate,
        min_price,
        max_price,
        median_price,
        avg_price,
        distinct_hosts,
        superhost_rate,
        avg_review_score,
        total_stays,
        avg_estimated_revenue,
        (active_listings_rate - lag(active_listings_rate) over (partition by listing_neighbourhood order by month_year))
            / nullif(lag(active_listings_rate) over (partition by listing_neighbourhood order by month_year),0) * 100 as pct_change_active,
        (inactive_listings_rate - lag(inactive_listings_rate) over (partition by listing_neighbourhood order by month_year))
            / nullif(lag(inactive_listings_rate) over (partition by listing_neighbourhood order by month_year),0) * 100 as pct_change_inactive
    from agg_metrics
)

select *
from pct_change
order by listing_neighbourhood, month_year
