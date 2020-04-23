with lists as (

    select *
    from {{ ref('stg_mailchimp_lists')}}

), campaign_activities as (

    select *
    from {{ ref('campaign_activities_by_list') }}

), members as (

    select *
    from {{ ref('members_by_list') }}

), members_xf as (

    select 
        lists.*,
        coalesce(members.count_members,0) as count_members,
        members.most_recent_signup_timestamp
    from lists
    left join members
        on lists.list_id = members.list_id

), metrics as (

    select 
        members_xf.*,
        coalesce(campaign_activities.sends,0) as campaign_sends,
        coalesce(campaign_activities.opens,0) as campaign_opens,
        coalesce(campaign_activities.clicks,0) as campaign_clicks,
        coalesce(campaign_activities.unique_opens,0) as campaign_unique_opens,
        coalesce(campaign_activities.unique_clicks,0) as campaign_unique_clicks,
        coalesce(campaign_activities.unsubscribes,0) as campaign_unsubscribes,
    from members_xf
    left join campaign_activities
        on members_xf.list_id = campaign_activities.list_id

{% if var('using_automations', True) %}

), automation_activities as (

    select *
    from {{ ref('automation_activities_by_list') }}

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
        on metrics.list_id = automation_activities.list_id

)

select *
from metrics_xf

{% else %}

)

select *
from metrics 

{% endif %}