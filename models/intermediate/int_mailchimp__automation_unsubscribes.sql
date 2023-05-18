{{ config(enabled=var('mailchimp_using_automations', True)) }}

with unsubscribes as (

    select *
    from {{ var('unsubscribe') }}

), automation_emails as (

    select *
    from {{ var('automation_email') }}

), automations as (

    select *
    from {{ var('automation') }}

), joined as (

    select 
        unsubscribes.*,
        automations.segment_id,
        automations.automation_id,
        automation_emails.automation_email_id
    from unsubscribes
    left join automation_emails
        on unsubscribes.campaign_id = automation_emails.automation_email_id
    left join automations
        on automation_emails.automation_id = automations.automation_id

)

select * 
from joined