with base as (

    select * 
    from {{ ref('stg_mailchimp__lists_tmp') }}

),


fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__lists_tmp')),
                staging_columns=get_list_columns()
            )
        }}
        
    from base

), 

final as (

    select 
        id as list_id,
        date_created,
        name,
        list_rating,
        beamer_address,
        contact_address_1,
        contact_address_2,
        contact_city,
        contact_company,
        contact_country,
        contact_state,
        contact_zip,
        default_from_email,
        default_from_name,
        default_language,
        default_subject,
        email_type_option,
        notify_on_subscribe,
        notify_on_unsubscribe,
        permission_reminder,
        subscribe_url_long,
        subscribe_url_short,
        use_archive_bar,
        visibility
    from fields

)

select *
from final