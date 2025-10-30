with activities as (

    select *
    from {{ ref('stg_mailchimp__campaign_activities') }}

), campaigns as (

    select *
    from {{ ref('stg_mailchimp__campaigns') }}

), since_send as (

    select
        activities.*,
        campaigns.send_timestamp,
        {{ dbt.datediff('campaigns.send_timestamp','activities.activity_timestamp','minute') }} as time_since_send_minutes,
        {{ dbt.datediff('campaigns.send_timestamp','activities.activity_timestamp','hour') }} as time_since_send_hours,
        {{ dbt.datediff('campaigns.send_timestamp','activities.activity_timestamp','day') }} as time_since_send_days
    from activities
    left join campaigns
        on activities.campaign_id = campaigns.campaign_id
        and activities.source_relation = campaigns.source_relation

)

select *
from since_send