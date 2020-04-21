{{ config(enabled=var('using_automations', True)) }}

with activities as (

    select *
    from {{ ref('mailchimp_automation_activities')}}

), pivoted as (

    select 
        automation_email_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then member_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks,
        min(case when action_type = 'open' then activity_timestamp end) as first_open_timestamp,
        min(case when action_type = 'open' then time_since_send_minutes end) as time_to_open_minutes,
        min(case when action_type = 'open' then time_since_send_hours end) as time_to_open_hours,
        min(case when action_type = 'open' then time_since_send_days end) as time_to_open_days
    from activities
    group by 1
    
), booleans as (

    select 
        *,
        case when opens > 0 then True else False end as was_opened,
        case when clicks > 0 then True else False end as was_clicked
    from pivoted

)

select *
from booleans