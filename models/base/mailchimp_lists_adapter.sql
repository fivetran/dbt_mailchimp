with base as (

    select *
    from {{ var('list') }}
    where _fivetran_deleted = false

), fields as (

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
    from base

)

select *
from fields