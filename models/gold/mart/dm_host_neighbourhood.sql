{{ 
    config(
        materialized='view',
        alias='dm_host_neighbourhood'
    ) 
}}

with revenue_data as (
    select 
        host_neighbourhood as host_neighbourhood_lga,
        date_trunc('month', scraped_date) as month_year,
        host_id,
        price,
        (30 - availability_30) as number_of_stays,
        (price * (30 - availability_30)) as estimated_revenue
    from {{ ref('fact_listings') }}
    where has_availability = 't'
),
agg_metrics as (
    select 
        host_neighbourhood_lga,
        month_year,
        count(distinct host_id) as distinct_hosts,
        sum(estimated_revenue) as total_estimated_revenue,
        sum(estimated_revenue) / count(distinct host_id) as estimated_revenue_per_host
    from revenue_data
    group by host_neighbourhood_lga, month_year
)
select * 
from agg_metrics
order by host_neighbourhood_lga, month_year
