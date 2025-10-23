{{ 
    config(
        unique_key='listing_id',
        alias='property_dimension'
    ) 
}}

select 
    listing_id,
    property_type,
    room_type,
    accommodates
from {{ ref('airbnb_cleaned') }}
