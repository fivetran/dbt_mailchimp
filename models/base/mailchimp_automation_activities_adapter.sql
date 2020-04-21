with base as (

    select *
    from {{ var('automation_recipient_activity')}}

), fields as (

    select 
        action as action_type,
        automation_email_id,
        member_id,
        list_id,
        timestamp as activity_timestamp,
        ip as ip_address,
        url
    from base

), unique_key as (

    select 
        *, 
        {{ dbt_utils.surrogate_key(['action_type', 'automation_email_id', 'member_id', 'activity_timestamp']) }} as activity_id
    from fields

)


select *
from unique_key
