with campaigns as (

    select *
    from {{ var('campaign')}}

), activities as (

    {{ agg_campaign_activities(['campaign']) }}

), joined as (

    select 
        campaigns.*,
        coalesce(activities.sends,0) as sends,
        coalesce(activities.opens,0) as opens,
        coalesce(activities.clicks,0) as clicks,
        coalesce(activities.unique_opens,0) as unique_opens,
        coalesce(activities.unique_clicks,0) as unique_clicks,
        coalesce(activities.unsubscribes,0) as unsubscribes
    from campaigns
    left join activities
        on campaigns.campaign_id = activities.campaign_id

)

select *
from joined