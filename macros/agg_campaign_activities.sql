{% macro agg_campaign_activities(by) %}

{% set id_col = by ~ "_id" %}

with recipients as (

    select *
    from {{ ref('mailchimp__campaign_recipients')}}

), pivoted as (

    select 
        {{ id_col }},
        count(*) as sends,
        sum(opens) as opens,
        sum(clicks) as clicks,
        count(distinct case when was_opened = True then member_id end) as unique_opens,
        count(distinct case when was_clicked = True then member_id end) as unique_clicks,
        count(distinct case when was_unsubscribed = True then member_id end) as unsubscribes
    from recipients
    where {{ id_col }} is not null
    group by 1
    
)

select *
from pivoted
    
{% endmacro %}
