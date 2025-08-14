with members as (

    select *
    from {{ ref('stg_mailchimp__members')}}

), campaign_activities as (

    select *
    from {{ ref('int_mailchimp__campaign_activities_by_member') }}

), metrics as (

    select 
        members.*,
        coalesce(campaign_activities.sends,0) as campaign_sends,
        coalesce(campaign_activities.opens,0) as campaign_opens,
        coalesce(campaign_activities.clicks,0) as campaign_clicks,
        coalesce(campaign_activities.unique_opens,0) as campaign_unique_opens,
        coalesce(campaign_activities.unique_clicks,0) as campaign_unique_clicks

        {% if var('mailchimp_using_unsubscribes', True) %}
        , coalesce(campaign_activities.unsubscribes,0) as campaign_unsubscribes
        {% endif %}
    from members
    left join campaign_activities
        on members.member_id = campaign_activities.member_id
        and members.list_id = campaign_activities.list_id

{% if var('mailchimp_using_automations', True) %}

), automation_activities as (

    select *
    from {{ ref('int_mailchimp__automation_activities_by_member') }}

), metrics_xf as (

    select 
        metrics.*,
        coalesce(automation_activities.sends,0) as automation_sends,
        coalesce(automation_activities.opens,0) as automation_opens,
        coalesce(automation_activities.clicks,0) as automation_clicks,
        coalesce(automation_activities.unique_opens,0) as automation_unique_opens,
        coalesce(automation_activities.unique_clicks,0) as automation_unique_clicks

        {% if var('mailchimp_using_unsubscribes', True) %}
        , coalesce(automation_activities.unsubscribes,0) as automation_unsubscribes
        {% endif %}
    from metrics
    left join automation_activities
        on metrics.member_id = automation_activities.member_id
        and metrics.list_id = automation_activities.list_id

)

select *
from metrics_xf

{% else %}

)

select *
from metrics 

{% endif %}