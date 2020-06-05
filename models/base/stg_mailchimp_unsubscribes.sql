with base as (

    select *
    from {{ var('unsubscribe') }}

), fields as (

    select 
        campaign_id,
        member_id,
        list_id,
        reason as unsubscribe_reason,
        timestamp as unsubscribe_timestamp
    from base

), unique_key as (

    select 
        *, 
        {{ dbt_utils.surrogate_key([ 'member_id', 'list_id', 'unsubscribe_timestamp']) }} as id
    from fields

)

select *
from unique_key