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
        source_relation,
        list_id,
        count(*) as unsubscribes
    from unsubscribes
    group by 1,2
{% endif %}

-- aggregate automation opens and clicks by list

), pivoted as (

    select
        source_relation,
        list_id,
        sum(case when action_type = 'open' then 1 end) as opens,
        sum(case when action_type = 'click' then 1 end) as clicks,
        count(distinct case when action_type = 'open' then member_id end) as unique_opens,
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks
    from activities
    group by 1,2

), sends as (

    select
        source_relation,
        list_id,
        count(*) as sends
    from recipients
    group by 1,2

), joined as (

    select
        coalesce(sends.source_relation
            , pivoted.source_relation
            {{ ', unsubscribes_xf.source_relation' if var('mailchimp_using_unsubscribes', True) }}
            ) as source_relation,
        coalesce(sends.list_id
            , pivoted.list_id
            {{ ', unsubscribes_xf.list_id' if var('mailchimp_using_unsubscribes', True) }}
            ) as list_id,
        pivoted.opens,
        pivoted.clicks,
        pivoted.unique_opens,
        pivoted.unique_clicks,
        sends.sends
        {{ ', unsubscribes_xf.unsubscribes' if var('mailchimp_using_unsubscribes', True) }}
    from sends
    left join pivoted
        on pivoted.list_id = sends.list_id
        and pivoted.source_relation = sends.source_relation

    {% if var('mailchimp_using_unsubscribes', True) %}
    left join unsubscribes_xf
        on unsubscribes_xf.list_id = sends.list_id
        and unsubscribes_xf.source_relation = sends.source_relation
    {% endif %}
)

select *
from joined