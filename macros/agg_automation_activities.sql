{% macro agg_automation_activities(by) %}

{% set id_cols = [] %}
{% for col in by %}
    {% do id_cols.append(col ~ "_id" ) %}
{% endfor %}

with activities as (

    select *
    from {{ ref('mailchimp__automation_activities')}}

), recipients as (

    select *
    from {{ ref('int_mailchimp__automation_recipients') }}

), unsubscribes as (

    select *
    from {{ ref('int_mailchimp__automation_unsubscribes') }}


-- aggregate automation opens and clicks by {{ by }}

), pivoted as (

    select 
        {% for id_col in id_cols %}
        {{ id_col }},
        {% endfor %}
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then member_id end) as unique_opens, 
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks
    from activities
    where
    {% for id_col in id_cols %}
        {% if not loop.first %}and {% endif %}{{ id_col }} is not null
    {% endfor %}
    group by 
        {% for id_col in id_cols %}
        {% if not loop.first %}, {% endif %}{{ id_col }}
        {% endfor %}

), sends as (

    select
        {% for id_col in id_cols %}
        {{ id_col }},
        {% endfor %}
        count(*) as sends
    from recipients
    where
    {% for id_col in id_cols %}
        {% if not loop.first %}and {% endif %}{{ id_col }} is not null
    {% endfor %}
    group by 
        {% for id_col in id_cols %}
        {% if not loop.first %}, {% endif %}{{ id_col }}
        {% endfor %}

), unsubscribes_xf as (

    select
        {% for id_col in id_cols %}
        {{ id_col }},
        {% endfor %}
        count(*) as unsubscribes
    from unsubscribes
    where 
    {% for id_col in id_cols %}
        {% if not loop.first %}and {% endif %}{{ id_col }} is not null
    {% endfor %}
    group by 
        {% for id_col in id_cols %}
        {% if not loop.first %}, {% endif %}{{ id_col }}
        {% endfor %}

), joined as (

    select
        {% for id_col in id_cols %}
        sends.{{ id_col }},
        {% endfor %}
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from sends
    left join pivoted on
        {% for id_col in id_cols %}
        {% if not loop.first %}and {% endif %}sends.{{ id_col }} = pivoted.{{ id_col }}
        {% endfor %}
    full outer join unsubscribes_xf on
        {% for id_col in id_cols %}
        {% if not loop.first %}and {% endif %}sends.{{ id_col }} = unsubscribes_xf.{{ id_col }}
        {% endfor %}

)

select *
from joined
    
{% endmacro %}
