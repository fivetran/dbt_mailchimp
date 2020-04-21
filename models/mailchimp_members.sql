with members as (

    select *
    from {{ ref('mailchimp_members_adapter')}}

), campaign_activities as (

    select *
    from {{ ref('campaign_activities_by_member') }}

), automation_activities as (

    select *
    from {{ ref('automation_activities_by_member') }}

), joined as (

    select 
        members.*,

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
    from members
    left join campaign_activities
        on members.member_id = campaign_activities.member_id
    left join automation_activities
        on members.member_id = automation_activities.member_id

)

select *
from joined