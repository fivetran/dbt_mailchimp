with lists as (

    select *
    from {{ ref('mailchimp_lists_adapter')}}

), campaign_activities as (

    select *
    from {{ ref('campaign_activities_by_list') }}

), automation_activities as (

    select *
    from {{ ref('automation_activities_by_list') }}

), members as (

    select *
    from {{ ref('members_by_list') }}

), metrics as (

    select 
        lists.*,

        coalesce(campaign_activities.sends,0) as campaign_sends,
        coalesce(campaign_activities.opens,0) as campaign_opens,
        coalesce(campaign_activities.clicks,0) as campaign_clicks,
        coalesce(campaign_activities.unique_opens,0) as campaign_unique_opens,
        coalesce(campaign_activities.unique_clicks,0) as campaign_unique_clicks,
        coalesce(campaign_activities.unsubscribes,0) as campaign_unsubscribes,

        coalesce(automation_activities.sends,0) as automation_sends,
        coalesce(automation_activities.opens,0) as automation_opens,
        coalesce(automation_activities.clicks,0) as automation_clicks,
        coalesce(automation_activities.unique_opens,0) as automation_unique_opens,
        coalesce(automation_activities.unique_clicks,0) as automation_unique_clicks,
        coalesce(automation_activities.unsubscribes,0) as automation_unsubscribes
    from lists
    left join campaign_activities
        on lists.list_id = campaign_activities.list_id
    left join automation_activities
        on lists.list_id = automation_activities.list_id

), metrics_xf as (

    select 
        metrics.*,
        coalesce(members.count_members,0) as count_members,
        members.most_recent_signup_timestamp
    from metrics
    left join members
        on metrics.list_id = members.list_id

)

select *
from metrics_xf