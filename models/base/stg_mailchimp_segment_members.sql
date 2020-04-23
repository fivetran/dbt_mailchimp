{{ config(enabled=var('using_segments', True)) }}

with base as (

    select *
    from {{ var('segment_member')}}
    where _fivetran_deleted = false

), fields as (

    select
        segment_id,
        member_id,
        list_id
    from base

)

select *
from fields
