{{ 
    config(
        unique_key='host_id',
        alias='host_dimension'
    ) 
}}

select 
    host_id,
    coalesce(host_name, 'Unknown') as host_name,
    coalesce(host_since, '2000-01-01')::date as host_since,
    coalesce(host_is_superhost, false) as host_is_superhost,
    coalesce(host_neighbourhood, 'Not specified') as host_neighbourhood
from {{ ref('airbnb_cleaned') }}
