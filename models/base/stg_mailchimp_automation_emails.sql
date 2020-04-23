{{ config(enabled=var('using_automations', True)) }}

with base as (

    select *
    from {{ var('automation_email')}}
    where _fivetran_deleted = false

), fields as (

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
    from base

)

select *
from fields
