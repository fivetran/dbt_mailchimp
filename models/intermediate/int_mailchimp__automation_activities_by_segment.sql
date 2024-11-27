{{ config(enabled=var('mailchimp_using_automations', True)) }}

with activities as (

    select *
    from {{ ref('mailchimp__automation_activities')}}

), recipients as (

    select *
    from {{ ref('int_mailchimp__automation_recipients') }}

{% if var('mailchimp_using_unsubscribes', True) %}
), unsubscribes as (

    select *
    from {{ ref('int_mailchimp__automation_unsubscribes') }}

), unsubscribes_xf as (

    select
        segment_id,
        count(*) as unsubscribes
    from unsubscribes
    where segment_id is not null
    group by 1
{% endif %}

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

), joined as (

    select
        coalesce(sends.segment_id
            , pivoted.segment_id
            {{ ', unsubscribes_xf.segment_id' if var('mailchimp_using_unsubscribes', True) }}
            ) as segment_id,
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends
        {{ ', unsubscribes_xf.unsubscribes' if var('mailchimp_using_unsubscribes', True) }}
    from sends
    left join pivoted
        on pivoted.segment_id = sends.segment_id
    
    {% if var('mailchimp_using_unsubscribes', True) %}
    left join unsubscribes_xf
        on pivoted.segment_id = unsubscribes_xf.segment_id
    {% endif %}
)

select *
from joined