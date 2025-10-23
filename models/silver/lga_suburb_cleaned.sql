{{ 
    config(
        unique_key='suburb_name',
        alias='lga_suburb_cleaned'
    ) 
}}

select 
    suburb_name,
    coalesce(lga_name, 'Unknown') as lga_name
from {{ ref('lga_suburb') }}
