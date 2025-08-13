{{ config(enabled=var('mailchimp_using_automations', True)) }}

with base as (

    select *
    from {{ ref('stg_mailchimp__automation_emails_tmp')}}

), 

fields as (

    select 
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__automation_emails_tmp')),
                staging_columns=get_automation_email_columns()
            )
        }}
        
    from base         

), 

final as (

    select
        -- IDs and standard timestamp
        id as automation_email_id,
        automation_id,
        create_time as created_timestamp,
        start_time as started_timestamp,
        send_time as send_timestamp,

        -- email details
        from_name,
        reply_to,
        status,
        subject_line,
        title,
        to_name,

        archive_url,
        authenticate,
        auto_footer,
        auto_tweet,
        clicktale,
        content_type,
        delay_action,
        delay_action_description,
        delay_amount,
        delay_direction,
        delay_full_description,
        delay_type,
        drag_and_drop,
        fb_comments,
        folder_id,
        google_analytics,
        inline_css,
        position,
        template_id,
        timewarp,
        track_ecomm_360,
        track_goals,
        track_html_clicks,
        track_opens,
        track_text_clicks,
        use_conversation
    from fields

)

select *
from final
