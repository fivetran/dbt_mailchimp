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

), pivoted as (

    select 
        automation_email_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then member_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks
    from activities
    group by 1

), sends as (

    select
        automation_email_id,
        count(*) as sends
    from recipients
    group by 1

), unsubscribes_xf as (

    select
        campaign_id as automation_email_id,
        count(*) as unsubscribes
    from unsubscribes
    group by 1

), joined as (

    select
        coalesce(pivoted.automation_email_id, sends.automation_email_id, unsubscribes_xf.automation_email_id) as automation_email_id,
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from pivoted
    full outer join sends
        on pivoted.automation_email_id = sends.automation_email_id
    full outer join unsubscribes_xf
        on pivoted.automation_email_id = unsubscribes_xf.automation_email_id

)

select *
from joined