with recipients as (

    select *
    from {{ ref('mailchimp__campaign_recipients')}}

), pivoted as (

    select
        source_relation,
        list_id,
        count(*) as sends,
        sum(opens) as opens,
        sum(clicks) as clicks,
        count(distinct case when was_opened = True then member_id end) as unique_opens,
        count(distinct case when was_clicked = True then member_id end) as unique_clicks

        {% if var('mailchimp_using_unsubscribes', True) %}
        , count(distinct case when was_unsubscribed = True then member_id end) as unsubscribes
        {% endif %}
    from recipients
    group by 1,2

)

select *
from pivoted