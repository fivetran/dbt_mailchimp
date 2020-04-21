{{ config(enabled=var('using_automations', True)) }}

with activities as (

    select *
    from {{ ref('mailchimp_automation_activities_adapter') }}

), automations as (

    select *
    from {{ ref('mailchimp_automation_emails_adapter') }}

), since_send as (

    select 
        activities.*,
        automations.send_timestamp,
        {{ dbt_utils.datediff('automations.send_timestamp','activities.activity_timestamp','minute') }} as time_since_send_minutes
    from activities
    left join automations
        on activities.automation_email_id = automations.automation_email_id

), since_send_xf as (

    select
        *,
        time_since_send_minutes / 60.0 as time_since_send_hours,
        time_since_send_minutes / (60.0 * 24.0) as time_since_send_days
    from since_send

)

select *
from since_send_xf