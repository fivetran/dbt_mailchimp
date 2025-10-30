{{ config(enabled=var('mailchimp_using_automations', True)) }}

with base as (

    select * 
    from {{ ref('stg_mailchimp__automations_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__automations_tmp')),
                staging_columns=get_automation_columns()
            )
        }}
        {{ mailchimp.apply_source_relation() }}

    from base
),

final as (

    select
        source_relation,
        id as automation_id,
        list_id,
        segment_id, 
        segment_text,
        start_time as started_timestamp,
        create_time as created_timestamp,
        status,
        title,
        trigger_settings
    from fields

)

select *
from final
