with unsubscribes as (

    select *
    from {{ ref('mailchimp_unsubscribes_adapter') }}

), automation_emails as (

    select *
    from {{ ref('mailchimp_automation_emails_adapter') }}

), automations as (

    select *
    from {{ ref('mailchimp_automations_adapter') }}

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