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


-- aggregate automation opens and clicks by member

), pivoted as (

    select 
        member_id,
        list_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then member_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks
    from activities
    group by 1,2

), sends as (

    select
        member_id,
        list_id,
        count(*) as sends
    from recipients
    group by 1,2

), unsubscribes_xf as (

    select
        member_id,
        list_id,
        count(*) as unsubscribes
    from unsubscribes
    group by 1,2

), joined as (

    select
        coalesce(pivoted.member_id, sends.member_id, unsubscribes_xf.member_id) as member_id,
        pivoted.list_id,
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from sends
    left join pivoted
        on pivoted.member_id = sends.member_id
    left join unsubscribes_xf
        on unsubscribes_xf.member_id = sends.member_id

)

select *
from joined