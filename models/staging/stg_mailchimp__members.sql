with base as (

    select * 
    from {{ ref('stg_mailchimp__members_tmp') }}

),


fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__members_tmp')),
                staging_columns=get_member_columns()
            )
        }}
        
    from base
),

final as (

    select 
        id as member_id,
        email_address,
        email_client,
        email_type,
        status,
        list_id,
        timestamp_signup as signup_timestamp,
        timestamp_opt as opt_in_timestamp,
        last_changed as last_changed_timestamp,
        country_code,
        dstoff,
        gmtoff,
        ip_opt as opt_in_ip_address,
        ip_signup as signup_ip_address,
        language,
        latitude,
        longitude,
        member_rating,
        timezone,
        unique_email_id,
        vip
        
        --The below macro adds the fields defined within your mailchimp__member_pass_through_columns variable into the staging model
        {{ fivetran_utils.fill_pass_through_columns('mailchimp__members_pass_through_columns') }}
        
    from fields

)

select *
from final