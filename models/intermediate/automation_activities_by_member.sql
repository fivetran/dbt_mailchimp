{{ config(enabled=var('using_automations', True)) }}

with activities as (

    select *
    from {{ ref('mailchimp_automation_activities')}}

), recipients as (

    select *
    from {{ ref('automation_recipients') }}

), unsubscribes as (

    select *
    from {{ ref('automation_unsubscribes') }}

), pivoted as (

    select 
        member_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then member_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks,
        min(case when action_type = 'open' then activity_timestamp end) as first_open_timestamp
    from activities
    group by 1
    
), booleans as (

    select 
        *,
        case when opens > 0 then True else False end as was_opened,
        case when clicks > 0 then True else False end as was_clicked
    from pivoted

), sends as (

    select
        member_id,
        count(*) as sends
    from recipients
    group by 1

), unsubscribes_xf as (

    select
        member_id,
        count(*) as unsubscribes
    from unsubscribes
    group by 1

), joined as (

    select
        coalesce(booleans.member_id, sends.member_id, unsubscribes_xf.member_id) as member_id,
        booleans.opens,
        booleans.clicks,
        booleans.unique_opens,
        booleans.unique_clicks,
        booleans.first_open_timestamp,
        booleans.was_opened,
        booleans.was_clicked,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from booleans
    full outer join sends
        on booleans.member_id = sends.member_id
    full outer join unsubscribes_xf
        on booleans.member_id = unsubscribes_xf.member_id

)

select *
from joined