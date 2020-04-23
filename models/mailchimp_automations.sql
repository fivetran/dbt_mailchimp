{{ config(enabled=var('using_automations', True)) }}

with automations as (

    select *
    from {{ ref('stg_mailchimp_automations')}}

), activities as (

    select *
    from {{ ref('automation_activities_by_automation') }}

), joined as (

    select 
        automations.*,
        coalesce(activities.sends,0) as sends,
        coalesce(activities.opens,0) as opens,
        coalesce(activities.clicks,0) as clicks,
        coalesce(activities.unique_opens,0) as unique_opens,
        coalesce(activities.unique_clicks,0) as unique_clicks,
        coalesce(activities.unsubscribes,0) as unsubscribes
    from automations
    left join activities
        on automations.automation_id = activities.automation_id

)

select *
from joined