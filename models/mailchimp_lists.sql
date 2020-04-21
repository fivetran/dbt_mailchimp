with lists as (

    select *
    from {{ ref('mailchimp_lists_adapter')}}

), activities as (

    select *
    from {{ ref('campaign_activities_by_list') }}

), members as (

    select *
    from {{ ref('members_by_list') }}

), metrics as (

    select 
        lists.*,
        coalesce(activities.sends,0) as sends,
        coalesce(activities.opens,0) as opens,
        coalesce(activities.clicks,0) as clicks,
        coalesce(activities.unique_opens,0) as unique_opens,
        coalesce(activities.unique_clicks,0) as unique_clicks,
        coalesce(activities.unsubscribes,0) as unsubscribes
    from lists
    left join activities
        on lists.list_id = activities.list_id

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