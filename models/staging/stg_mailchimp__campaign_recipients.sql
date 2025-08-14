with base as (

    select * 
    from {{ ref('stg_mailchimp__campaign_recipients_tmp') }}

),


fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__campaign_recipients_tmp')),
                staging_columns=get_campaign_recipient_columns()
            )
        }}
        
    from base
),

final as (

    select 
        campaign_id,
        member_id,
        combination_id,
        list_id
    from fields

), 

unique_key as (

    select 
        *,
        {{ dbt_utils.generate_surrogate_key(['campaign_id','member_id']) }} as email_id
    from final
    
)

select *
from unique_key