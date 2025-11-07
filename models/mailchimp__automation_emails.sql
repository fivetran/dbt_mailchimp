{{ config(enabled=var('mailchimp_using_automations', True)) }}

with emails as (

    select *
    from {{ ref('stg_mailchimp__automation_emails') }}

), activities as (

    select *
    from {{ ref('int_mailchimp__automation_activities_by_email') }}

), automations as (

    select *
    from {{ ref('stg_mailchimp__automations') }}

), joined as (

    select
        emails.*,
        automations.list_id,
        automations.segment_id
    from emails
    left join automations
        on emails.automation_id = automations.automation_id
        and emails.source_relation = automations.source_relation

), metrics as (

    select
        joined.*,
        coalesce(activities.sends, 0) as sends,
        coalesce(activities.opens, 0) as opens,
        coalesce(activities.clicks, 0) as clicks,
        coalesce(activities.unique_opens, 0) as unique_opens,
        coalesce(activities.unique_clicks, 0) as unique_clicks

        {% if var('mailchimp_using_unsubscribes', True) %}
        , coalesce(activities.unsubscribes, 0) as unsubscribes
        {% endif %}
    from joined
    left join activities
        on joined.automation_email_id = activities.automation_email_id
        and joined.source_relation = activities.source_relation

)

select * 
from metrics