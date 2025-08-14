{{ config(enabled=var('mailchimp_using_automations', True) and var('mailchimp_using_unsubscribes', True)) }}

with unsubscribes as (

    select *
    from {{ ref('stg_mailchimp__unsubscribes') }}

), automation_emails as (

    select *
    from {{ ref('stg_mailchimp__automation_emails') }}

), automations as (

    select *
    from {{ ref('stg_mailchimp__automations') }}

), joined as (

    select 
        unsubscribes.*,
        automations.segment_id,
        automations.automation_id

    from unsubscribes
    left join automation_emails
        on unsubscribes.campaign_id = automation_emails.automation_email_id
    left join automations
        on automation_emails.automation_id = automations.automation_id

)

select * 
from joined