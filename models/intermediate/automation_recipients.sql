with recipients as (

    select *
    from {{ ref('mailchimp_automation_recipients_adapter') }}

), automation_emails as (

    select *
    from {{ ref('mailchimp_automation_emails_adapter') }}

), automations as (

    select *
    from {{ ref('mailchimp_automations_adapter') }}

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