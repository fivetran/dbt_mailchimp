{{ config(enabled=var('mailchimp_using_segments', True)) }}

with segments as (

    select *
    from {{ var('mailchimp_segment')}}

), campaign_activities as (

    select *
    from {{ ref('int_mailchimp__campaign_activities_by_segment') }}

), lists as (

    select *
    from {{ var('list')}}

), metrics as (

    select 
        segments.*,
        coalesce(campaign_activities.sends,0) as campaign_sends,
        coalesce(campaign_activities.opens,0) as campaign_opens,
        coalesce(campaign_activities.clicks,0) as campaign_clicks,
        coalesce(campaign_activities.unique_opens,0) as campaign_unique_opens,
        coalesce(campaign_activities.unique_clicks,0) as campaign_unique_clicks

        {% if var('mailchimp_using_unsubscribes', True) %}
        , coalesce(campaign_activities.unsubscribes,0) as campaign_unsubscribes
        {% endif %}
        lists.name as list_name

    from segments
    left join campaign_activities
        on segments.segment_id = campaign_activities.segment_id
    left join lists 
        on segments.list_id = lists.list_id

{% if var('mailchimp_using_automations', True) %}

), automation_activities as (

    select *
    from {{ ref('int_mailchimp__automation_activities_by_segment') }}

), metrics_xf as (

    select 
        metrics.*,
        coalesce(automation_activities.sends,0) as automation_sends,
        coalesce(automation_activities.opens,0) as automation_opens,
        coalesce(automation_activities.clicks,0) as automation_clicks,
        coalesce(automation_activities.unique_opens,0) as automation_unique_opens,
        coalesce(automation_activities.unique_clicks,0) as automation_unique_clicks,
        coalesce(automation_activities.unsubscribes,0) as automation_unsubscribes
    from metrics
    left join automation_activities
        on metrics.segment_id = automation_activities.segment_id

)

select *
from metrics_xf

{% else %}

)

select *
from metrics 

{% endif %}