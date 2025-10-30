{{ config(enabled=var('mailchimp_using_automations', True)) }}

with base as (

    select *
    from {{ ref('stg_mailchimp__automation_activities_tmp')}}

), 

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__automation_activities_tmp')),
                staging_columns=get_automation_recipient_activity_columns()
            )
        }}
        {{ mailchimp.apply_source_relation() }}

    from base

), 

final as (

    select
        source_relation,
        action as action_type,
        automation_email_id,
        member_id,
        list_id,
        timestamp as activity_timestamp,
        ip as ip_address,
        url,
        bounce_type
    from fields

),

unique_key as (

    select
        *,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'action_type', 'automation_email_id', 'member_id', 'activity_timestamp']) }} as activity_id
    from final
)

select * from unique_key