{{ config(enabled=var('using_automations', True)) }}

with emails as (

    select *
    from {{ ref('mailchimp_automation_emails_adapter') }}

), activities as (

    select *
    from {{ ref('automation_activities_by_email') }}

), automations as (

    select *
    from {{ ref('mailchimp_automations_adapter') }}

), joined as (

    select 
        emails.*,
        automations.list_id,
        automations.segment_id
    from emails
    left join automations
        on emails.automation_id = automations.automation_id

), metrics as (

    select
        joined.*,
        coalesce(activities.sends, 0) as sends,
        coalesce(activities.opens, 0) as opens,
        coalesce(activities.unique_opens, 0) as unique_opens,
        coalesce(activities.clicks, 0) as clicks,
        coalesce(activities.unique_clicks, 0) as unique_clicks,
        coalesce(activities.unsubscribes, 0) as unsubscribes,
        activities.first_open_timestamp
    from joined
    left join activities
        on joined.automation_email_id = activities.automation_email_id

)

select * 
from metrics