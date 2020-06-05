{{ config(enabled=var('using_automations', True)) }}

with base as (

    select *
    from {{ var('automation_recipient')}}

), fields as (

    select
        member_id,
        automation_email_id,
        list_id
    from base

), unique_key as (

    select 
        *,
        {{ dbt_utils.surrogate_key(['member_id','automation_email_id']) }} as automation_recipient_id
    from fields

)

select *
from unique_key