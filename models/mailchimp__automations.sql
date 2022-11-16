{{ config(enabled=var('mailchimp_using_automations', True)) }}

with automations as (

    select *
    from {{ var('automation')}}

), automation_activities as (

    {{ agg_automation_activities('automation') }}

), joined as (

    select 
        automations.*,
        coalesce(automation_activities.sends,0) as sends,
        coalesce(automation_activities.opens,0) as opens,
        coalesce(automation_activities.clicks,0) as clicks,
        coalesce(automation_activities.unique_opens,0) as unique_opens,
        coalesce(automation_activities.unique_clicks,0) as unique_clicks,
        coalesce(automation_activities.unsubscribes,0) as unsubscribes
    from automations
    left join automation_activities
        on automations.automation_id = automation_activities.automation_id

)

select *
from joined