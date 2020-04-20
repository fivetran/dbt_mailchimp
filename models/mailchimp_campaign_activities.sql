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
        {{ dbt_utils.datediff('campaigns.send_timestamp','activities.activity_timestamp','minute') }} as time_since_send_minutes
    from activities
    left join campaigns
        on activities.campaign_id = campaigns.campaign_id

), since_send_xf as (

    select
        *,
        time_since_send_minutes / 60.0 as time_since_send_hours,
        time_since_send_minutes / (60.0 * 24.0) as time_since_send_days
    from since_send

)

select *
from since_send_xf