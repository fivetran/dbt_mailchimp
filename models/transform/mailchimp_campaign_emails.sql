with recipients as (
    
    select *
    from {{ ref('stg_mailchimp_campaign_recipients') }}

), activities as (

    select *
    from {{ ref('activities_by_email') }}

), joined as (

    select
        recipients.*,
        coalesce(activities.opens) as opens,
        coalesce(activities.unique_opens) as unique_opens,
        coalesce(activities.clicks) as clicks,
        coalesce(activities.unique_clicks) as unique_clicks,
        activities.was_opened,
        activities.was_clicked
    from recipients
    left join activities
        on recipients.email_id = activities.email_id

)

select * 
from joined