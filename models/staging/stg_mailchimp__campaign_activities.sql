with base as (

    select * 
    from {{ ref('stg_mailchimp__campaign_activities_tmp') }}

),


fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__campaign_activities_tmp')),
                staging_columns=get_campaign_recipient_activity_columns()
            )
        }}
        
    from base
),


final as (

    select 
        action as action_type,
        campaign_id,
        member_id,
        list_id,
        cast(timestamp as {{ dbt.type_timestamp() }}) as activity_timestamp,
        ip as ip_address,
        url,
        bounce_type,
        combination_id
    from fields

), unique_key as (

    select 
        *, 
        {{ dbt_utils.generate_surrogate_key(['action_type', 'campaign_id', 'member_id', 'activity_timestamp']) }} as activity_id,
        {{ dbt_utils.generate_surrogate_key(['campaign_id','member_id']) }} as email_id
    from final

)

select *
from unique_key