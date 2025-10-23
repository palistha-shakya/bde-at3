{{ 
    config(
        unique_key='listing_id',
        alias='airbnb_cleaned'
    ) 
}}

with cleaned as (
    select 
        listing_id,
        scrape_id,
        scraped_date,
        host_id,
        coalesce(host_name, 'Unknown') as host_name,
        coalesce(host_since, '2000-01-01') as host_since,
        coalesce(host_is_superhost, 'No') as host_is_superhost,
        coalesce(host_neighbourhood, 'Not specified') as host_neighbourhood,
        listing_neighbourhood,
        property_type,
        room_type,
        accommodates,
        price::numeric,  
        has_availability,
        availability_30,
        number_of_reviews,
        coalesce(review_scores_rating, 0) as review_scores_rating,
        coalesce(review_scores_accuracy, 0) as review_scores_accuracy,
        coalesce(review_scores_cleanliness, 0) as review_scores_cleanliness,
        coalesce(review_scores_checkin, 0) as review_scores_checkin,
        coalesce(review_scores_communication, 0) as review_scores_communication,
        coalesce(review_scores_value, 0) as review_scores_value
    from {{ ref('airbnb_raw') }}
)

select * from cleaned
