{{ config(enabled=var('using_automations', True)) }}

with base as (

    select *
    from {{ var('automation')}}
    where _fivetran_deleted = false

), fields as (

    select
        id as automation_id,
        list_id,
        segment_id, 
        segment_text,
        start_time as started_timestamp,
        create_time as created_timestamp,
        status,
        title,
        trigger_settings
    from base

)

select *
from fields
