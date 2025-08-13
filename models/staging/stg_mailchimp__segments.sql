{{ config(enabled=var('mailchimp_using_segments', True)) }}

with base as (

    select * 
    from {{ ref('stg_mailchimp__segments_tmp') }}

),


fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__segments_tmp')),
                staging_columns=get_segment_columns()
            )
        }}
        
    from base

), 

final as (

    select
        id as segment_id,
        list_id,
        member_count,
        name as segment_name,
        type as segment_type,
        updated_at as updated_timestamp,
        created_at as created_timestamp
    from fields

)

select *
from final
