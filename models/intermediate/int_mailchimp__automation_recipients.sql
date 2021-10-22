{{ config(enabled=var('mailchimp_using_automations', True)) }}

with recipients as (

    select *
    from {{ var('automation_recipient') }}

), automation_emails as (

    select *
    from {{ var('automation_email') }}

), automations as (

    select *
    from {{ var('automation') }}

), joined as (

    select 
        recipients.*,
        automations.segment_id,
        automations.automation_id

    from recipients
    left join automation_emails
        on recipients.automation_email_id = automation_emails.automation_email_id
    left join automations
        on automation_emails.automation_id = automations.automation_id

)

select * 
from joined