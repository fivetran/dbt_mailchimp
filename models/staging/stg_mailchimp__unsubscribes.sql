{{ config(enabled=var('mailchimp_using_unsubscribes', True)) }}

with base as (

    select * 
    from {{ ref('stg_mailchimp__unsubscribes_tmp') }}

),


fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__unsubscribes_tmp')),
                staging_columns=get_unsubscribe_columns()
            )
        }}
        
    from base

), 

final as (

    select 
        campaign_id,
        member_id,
        list_id,
        reason as unsubscribe_reason,
        timestamp as unsubscribe_timestamp
    from fields

), 

unique_key as (

    select 
        *, 
        {{ dbt_utils.generate_surrogate_key([ 'member_id', 'list_id', 'unsubscribe_timestamp']) }} as unsubscribe_id
    from final

)

select *
from unique_key