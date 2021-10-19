with recipients as (
    
    select *
    from {{ var('campaign_recipient') }}

), activities as (

    select *
    from {{ ref('int_mailchimp__campaign_activities_by_email') }}

), unsubscribes as (

    select *
    from {{ var('unsubscribe') }}

), campaigns as (

    select *
    from {{ var('campaign') }}

), joined as (

    select 
        recipients.*,
        campaigns.segment_id,
        campaigns.send_timestamp
    from recipients
    left join campaigns
        on recipients.campaign_id = campaigns.campaign_id

), metrics as (

    select
        joined.*,
        coalesce(activities.opens,0) as opens,
        coalesce(activities.unique_opens,0) as unique_opens,
        coalesce(activities.clicks,0) as clicks,
        coalesce(activities.unique_clicks,0) as unique_clicks,
        coalesce(activities.was_opened, False) as was_opened,
        coalesce(activities.was_clicked, False) as was_clicked,
        activities.first_open_timestamp,
        activities.time_to_open_minutes,
        activities.time_to_open_hours,
        activities.time_to_open_days
    from joined
    left join activities
        on joined.email_id = activities.email_id

), unsubscribes_xf as (

    select 
        member_id,
        campaign_id
    from unsubscribes
    group by 1,2

), metrics_xf as (

    select 
        metrics.*,
        case when unsubscribes_xf.member_id is not null then True else False end as was_unsubscribed
    from metrics
    left join unsubscribes_xf
        on metrics.member_id = unsubscribes_xf.member_id
        and metrics.campaign_id = unsubscribes_xf.campaign_id

)

select * 
from metrics_xf