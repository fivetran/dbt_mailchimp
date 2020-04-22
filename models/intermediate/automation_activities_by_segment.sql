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
        segment_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then segment_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then segment_id end) as unique_clicks,
        min(case when action_type = 'open' then activity_timestamp end) as first_open_timestamp
    from activities
    where segment_id is not null
    group by 1

), sends as (

    select
        segment_id,
        count(*) as sends
    from recipients
    where segment_id is not null
    group by 1

), unsubscribes_xf as (

    select
        segment_id,
        count(*) as unsubscribes
    from unsubscribes
    where segment_id is not null
    group by 1

), joined as (

    select
        coalesce(pivoted.segment_id, sends.segment_id, unsubscribes_xf.segment_id) as segment_id,
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        pivoted.first_open_timestamp,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from pivoted
    full outer join sends
        on pivoted.segment_id = sends.segment_id
    full outer join unsubscribes_xf
        on pivoted.segment_id = unsubscribes_xf.segment_id

)

select *
from joined