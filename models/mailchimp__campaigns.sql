with campaigns as (

    select *
    from {{ var('campaign')}}

), activities as (

    select *
    from {{ ref('int_mailchimp__campaign_activities_by_campaign') }}

), joined as (

    select 
        campaigns.*,
        coalesce(activities.sends,0) as sends,
        coalesce(activities.opens,0) as opens,
        coalesce(activities.clicks,0) as clicks,
        coalesce(activities.unique_opens,0) as unique_opens,
        coalesce(activities.unique_clicks,0) as unique_clicks
        
        {% if var('mailchimp_using_unsubscribes', True) %}
        , coalesce(activities.unsubscribes,0) as unsubscribes
        {% endif %}
    from campaigns
    left join activities
        on campaigns.campaign_id = activities.campaign_id

)

select *
from joined