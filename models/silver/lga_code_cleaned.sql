{{ 
    config(
        unique_key='lga_code',
        alias='lga_code_cleaned'
    ) 
}}

select 
    lga_code,
    lga_name
from {{ ref('lga_code') }}
where lga_code is not null
