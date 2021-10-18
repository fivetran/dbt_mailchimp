{{ config(enabled=var('using_automations', True)) }}

with activities as (

    select *
    from {{ ref('mailchimp__automation_activities')}}

), recipients as (

    select *
    from {{ ref('int_mailchimp__automation_recipients') }}

), unsubscribes as (

    select *
    from {{ ref('int_mailchimp__automation_unsubscribes') }}


-- aggregate automation opens and clicks by list

), pivoted as (

    select 
        list_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then member_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks
    from activities
    group by 1

), sends as (

    select
        list_id,
        count(*) as sends
    from recipients
    group by 1

), unsubscribes_xf as (

    select
        list_id,
        count(*) as unsubscribes
    from unsubscribes
    group by 1

), joined as (

    select
        coalesce(pivoted.list_id, sends.list_id, unsubscribes_xf.list_id) as list_id,
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from pivoted
    full outer join sends
        on pivoted.list_id = sends.list_id
    full outer join unsubscribes_xf
        on pivoted.list_id = unsubscribes_xf.list_id

)

select *
from joined