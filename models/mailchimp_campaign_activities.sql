with activities as (

    select *
    from {{ ref('mailchimp_campaign_activities_adapter') }}

), campaigns as (

    select *
    from {{ ref('mailchimp_campaigns_adapter') }}

), since_send as (

    select 
        activities.*,
        campaigns.send_timestamp,
        {{ dbt_utils.datediff('campaigns.send_timestamp','activities.activity_timestamp','minute') }} as time_since_send_minutes,
        {{ dbt_utils.datediff('campaigns.send_timestamp','activities.activity_timestamp','hour') }} as time_since_send_hours,
        {{ dbt_utils.datediff('campaigns.send_timestamp','activities.activity_timestamp','day') }} as time_since_send_days
    from activities
    left join campaigns
        on activities.campaign_id = campaigns.campaign_id

)

select *
from since_send