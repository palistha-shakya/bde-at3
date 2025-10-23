{{ 
    config(
        unique_key='listing_id',  
        alias='airbnb'
    ) 
}}

select * from {{ source('raw', 'airbnb_raw') }}
