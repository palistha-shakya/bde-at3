{{ 
    config(
        materialized='table',
        unique_key='host_id',
        alias='dim_host'
    ) 
}}

select 
    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood
from {{ ref('airbnb_cleaned') }}
