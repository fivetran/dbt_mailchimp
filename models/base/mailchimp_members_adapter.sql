with base as (

    select *
    from {{ var('member') }}

), fields as (

    select 
        id as member_id,
        email_address,
        email_client,
        email_type,
        status,
        list_id,
        timestamp_signup as signup_timestamp,
        timestamp_opt as opt_in_timestamp,
        last_changed as last_changed_timestamp
    from base

)

select *
from fields