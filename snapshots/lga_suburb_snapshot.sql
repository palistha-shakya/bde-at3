{% snapshot lga_suburb_snapshot %}

{{ config(
    target_schema='snapshots',
    unique_key='suburb_name',
    strategy='timestamp',
    updated_at='created_at'
) }}

SELECT *,
       current_timestamp AS created_at
FROM {{ ref('lga_suburb_cleaned') }}

{% endsnapshot %}
