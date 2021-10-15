{{ config(enabled=var('using_automations', True)) }}

with activities as (

    select *
    from {{ ref('stg_mailchimp__automation_activities') }}

), automation_emails as (

    select *
    from {{ ref('stg_mailchimp__automation_emails') }}

), automations as (

    select *
    from {{ ref('stg_mailchimp__automations') }}

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