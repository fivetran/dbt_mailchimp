{{ config(enabled=var('mailchimp_using_automations', True)) }}

with recipients as (

    select *
    from {{ ref('stg_mailchimp__automation_recipients') }}

), automation_emails as (

    select *
    from {{ ref('stg_mailchimp__automation_emails') }}

), automations as (

    select *
    from {{ ref('stg_mailchimp__automations') }}

), joined as (

    select
        recipients.*,
        automations.segment_id,
        automations.automation_id

    from recipients
    left join automation_emails
        on recipients.automation_email_id = automation_emails.automation_email_id
        and recipients.source_relation = automation_emails.source_relation
    left join automations
        on automation_emails.automation_id = automations.automation_id
        and automation_emails.source_relation = automations.source_relation

)

select * 
from joined