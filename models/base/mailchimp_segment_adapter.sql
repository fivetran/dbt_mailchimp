{{ config(enabled=var('using_segments', True)) }}

with base as (

    select *
    from {{ var('segment')}}
    where _fivetran_deleted = false

), fields as (

    select
        id as segment_id,
        list_id,
        member_count,
        name as segment_name,
        type as segment_type,
        updated_at as updated_timestamp,
        created_at as created_timestamp
    from base

)

select *
from fields
