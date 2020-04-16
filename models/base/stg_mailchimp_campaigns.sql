with base as (

    select *
    from {{ var('campaign')}}

), fields as (

    select 
        id,
        create_time,
        list_id,
        reply_to as reply_to_email,
        type as campaign_type,
        title
    from base

)

select *
from fields