{% snapshot lga_code_snapshot %}

{{ config(
    target_schema='snapshots',
    unique_key='lga_code',
    strategy='timestamp',
    updated_at='created_at'
) }}

SELECT *,
       current_timestamp AS created_at
FROM {{ ref('lga_code_cleaned') }}

{% endsnapshot %}
