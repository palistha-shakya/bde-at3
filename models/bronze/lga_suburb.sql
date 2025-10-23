{{ 
    config(
        unique_key='suburb_name',
        alias='lga_suburb'
    ) 
}}

select * from {{ source('raw', 'lga_suburb') }}
