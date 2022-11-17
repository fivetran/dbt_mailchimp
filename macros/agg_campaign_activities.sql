{% macro agg_campaign_activities(by) %}

{% set id_cols = [] %}
{% for col in by %}
    {% do id_cols.append(col ~ "_id" ) %}
{% endfor %}

with recipients as (

    select *
    from {{ ref('mailchimp__campaign_recipients')}}

), pivoted as (

    select 
        {% for id_col in id_cols %}
        {{ id_col }},
        {% endfor %}
        count(*) as sends,
        sum(opens) as opens,
        sum(clicks) as clicks,
        count(distinct case when was_opened = True then member_id end) as unique_opens,
        count(distinct case when was_clicked = True then member_id end) as unique_clicks,
        count(distinct case when was_unsubscribed = True then member_id end) as unsubscribes
    from recipients
    where
    {% for id_col in id_cols %}
        {% if not loop.first %}and {% endif %}{{ id_col }} is not null
    {% endfor %}
    group by 
        {% for id_col in id_cols %}
        {% if not loop.first %}, {% endif %}{{ id_col }}
        {% endfor %}
    
)

select *
from pivoted
    
{% endmacro %}
