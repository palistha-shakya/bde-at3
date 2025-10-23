{% snapshot host_dimension_snapshot %}

{{ config(
    target_schema='snapshots',
    unique_key='host_id',
    strategy='timestamp',
    updated_at='host_since'
) }}

SELECT *
FROM {{ ref('host_dimension') }}

{% endsnapshot %}
