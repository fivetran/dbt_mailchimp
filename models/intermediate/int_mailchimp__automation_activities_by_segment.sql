{{ config(enabled=var('mailchimp_using_automations', True)) }}

with activities as (

    select *
    from {{ ref('mailchimp__automation_activities')}}

), recipients as (

    select *
    from {{ ref('int_mailchimp__automation_recipients') }}

), unsubscribes as (

    select *
    from {{ ref('int_mailchimp__automation_unsubscribes') }}


-- aggregate automation opens and clicks by segment

), pivoted as (

    select 
        segment_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then segment_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then segment_id end) as unique_clicks
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
        coalesce(sends.segment_id, pivoted.segment_id, unsubscribes_xf.segment_id) as segment_id,
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from sends
    left join pivoted
        on pivoted.segment_id = sends.segment_id
    left join unsubscribes_xf
        on pivoted.segment_id = unsubscribes_xf.segment_id

)

select *
from joined