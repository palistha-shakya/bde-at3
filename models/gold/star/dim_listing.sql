{{ 
    config(
        materialized='table',
        unique_key='listing_id',
        alias='dim_listing'
    ) 
}}

select 
    listing_id,
    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood,
    property_type,
    room_type,
    accommodates
from {{ ref('airbnb_cleaned') }}
