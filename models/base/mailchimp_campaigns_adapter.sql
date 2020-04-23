with base as (

    select *
    from {{ var('campaign') }}
    where _fivetran_deleted = false

), fields as (

    select 
        id as campaign_id,
        segment_id,
        create_time as create_timestamp,
        send_time as send_timestamp, 
        list_id,
        reply_to as reply_to_email,
        type as campaign_type,
        title,
        archive_url,
        authenticate,
        auto_footer,
        auto_tweet,
        clicktale,
        content_type,
        drag_and_drop,
        fb_comments,
        folder_id,
        from_name,
        google_analytics,
        inline_css,
        long_archive_url,
        status,
        subject_line,
        template_id,
        test_size,
        timewarp,
        to_name,
        track_ecomm_360,
        track_goals,
        track_html_clicks,
        track_opens,
        track_text_clicks,
        use_conversation,
        wait_time,
        winner_criteria,
        winning_campaign_id,
        winning_combination_id
    from base

)

select *
from fields