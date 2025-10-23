{{ 
    config(
        materialized='table',
        unique_key='suburb_name',
        alias='dim_suburb'
    ) 
}}

select 
    suburb_name,
    coalesce(lga_name, 'Unknown') as lga_name
from {{ ref('lga_suburb_cleaned') }}
