with members as (

    select *
    from {{ ref('mailchimp_members_adapter')}}

), activities as (

    select *
    from {{ ref('activities_by_member') }}

), joined as (

    select 
        members.*,
        coalesce(activities.sends,0) as sends,
        coalesce(activities.opens,0) as opens,
        coalesce(activities.clicks,0) as clicks,
        coalesce(activities.unique_opens,0) as unique_opens,
        coalesce(activities.unique_clicks,0) as unique_clicks,
        coalesce(activities.unsubscribes,0) as unsubscribes
    from members
    left join activities
        on members.member_id = activities.member_id

)

select *
from joined