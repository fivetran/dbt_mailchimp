{{ config(enabled=var('using_automations', True)) }}

with recipients as (
    
    select *
    from {{ ref('mailchimp_automation_recipients_adapter') }}

), emails as (

    select *
    from {{ ref('mailchimp_automation_emails_adapter') }}

), activities as (

    select *
    from {{ ref('automation_activities_by_email') }}

), unsubscribes as (

    select *
    from {{ ref('mailchimp_unsubscribes_adapter') }}

), recipients_xf as (

    select
        emails.*,
        recipients.member_id,
        recipients.list_id,
        recipients.automation_recipient_id
    from emails
    inner join recipients
        on emails.automation_email_id = recipients.automation_email_id

), metrics as (

    select
        recipients_xf.*,
        coalesce(activities.opens) as opens,
        coalesce(activities.unique_opens) as unique_opens,
        coalesce(activities.clicks) as clicks,
        coalesce(activities.unique_clicks) as unique_clicks,
        activities.was_opened,
        activities.was_clicked,
        activities.first_open_timestamp
    from recipients_xf
    left join activities
        on recipients_xf.automation_email_id = activities.automation_email_id

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
        and metrics.automation_email_id = unsubscribes_xf.campaign_id

)

select * 
from metrics_xf