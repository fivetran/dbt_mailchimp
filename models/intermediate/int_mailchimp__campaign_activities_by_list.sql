with recipients as (

    select *
    from {{ ref('mailchimp__campaign_recipients')}}

), pivoted as (

    select 
        list_id,
        count(*) as sends,
        sum(opens) as opens,
        sum(clicks) as clicks,
        count(distinct case when was_opened = True then member_id end) as unique_opens,
        count(distinct case when was_clicked = True then member_id end) as unique_clicks,
        count(distinct case when was_unsubscribed = True then member_id end) as unsubscribes
    from recipients
    group by 1
    
)

select *
from pivoted