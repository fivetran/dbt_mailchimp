{% macro agg_automation_activities(by) %}

{% set id_col = by ~ "_id" %}

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
        {{ id_col }},
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks, 
        count(distinct case when action_type = 'open' then {{ id_col }} end) as unique_opens, 
        count(distinct case when action_type = 'click' then {{ id_col }} end) as unique_clicks
    from activities
    where {{ id_col }} is not null
    group by 1

), sends as (

    select
        {{ id_col }},
        count(*) as sends
    from recipients
    where {{ id_col }} is not null
    group by 1

), unsubscribes_xf as (

    select
        {{ id_col }},
        count(*) as unsubscribes
    from unsubscribes
    where {{ id_col }} is not null
    group by 1

), joined as (

    select
        coalesce(pivoted.{{ id_col }}, sends.{{ id_col }}, unsubscribes_xf.{{ id_col }}) as {{ id_col }},
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends,
        unsubscribes_xf.unsubscribes
    from pivoted
    full outer join sends
        on pivoted.{{ id_col }} = sends.{{ id_col }}
    full outer join unsubscribes_xf
        on pivoted.{{ id_col }} = unsubscribes_xf.{{ id_col }}

)

select *
from joined
    
{% endmacro %}
