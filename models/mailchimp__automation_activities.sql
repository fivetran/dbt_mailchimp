{{ config(enabled=var('mailchimp_using_automations', True)) }}

with activities as (

    select *
    from {{ var('automation_recipient_activity') }}

), automation_emails as (

    select *
    from {{ var('automation_email') }}

), automations as (

    select *
    from {{ var('automation') }}

), joined as (

    select 
        activities.*,
        automations.automation_id,
        automations.segment_id
    from activities
    left join automation_emails
        on activities.automation_email_id = automation_emails.automation_email_id
    left join automations
        on automation_emails.automation_id = automations.automation_id

)

select *
from joined