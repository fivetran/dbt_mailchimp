{{ config(enabled=var('mailchimp_using_automations', True)) }}

with emails as (

    select *
    from {{ var('automation_email') }}

), automation_activities as (

    {{ agg_automation_activities(['automation_email']) }}

), automations as (

    select *
    from {{ var('automation') }}

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
        coalesce(automation_activities.sends, 0) as sends,
        coalesce(automation_activities.opens, 0) as opens,
        coalesce(automation_activities.clicks, 0) as clicks,
        coalesce(automation_activities.unique_opens, 0) as unique_opens,
        coalesce(automation_activities.unique_clicks, 0) as unique_clicks,
        coalesce(automation_activities.unsubscribes, 0) as unsubscribes
    from joined
    left join automation_activities
        on joined.automation_email_id = automation_activities.automation_email_id

)

select * 
from metrics