{{ 
    config(
        materialized='table',
        unique_key='listing_id',
        alias='facts_listings'
    ) 
}}

select 
    listing_id,
    scrape_id,
    scraped_date,
    host_id,
    listing_neighbourhood,
    host_neighbourhood,
    property_type,  
    room_type,      
    accommodates,   
    host_is_superhost,
    price::numeric,
    has_availability,
    availability_30,
    number_of_reviews,
    review_scores_rating
from {{ ref('airbnb_cleaned') }}
