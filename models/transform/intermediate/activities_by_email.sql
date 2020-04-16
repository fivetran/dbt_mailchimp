with activities as (

    select *
    from {{ ref('stg_mailchimp_campaign_activities')}}

), pivoted as (

    select 
        email_id,
        {{
            dbt_utils.pivot(
                column='action_type',
                values=['open','click'],
                agg='sum',
                suffix='s'
            )
        }},

        count(distinct case when action_type = 'open' then member_id end) as unique_opens,
        count(distinct case when action_type = 'click' then member_id end) as unique_clicks
        
    from activities
    group by 1
    
), booleans as (

    select 
        *,
        case when opens > 0 then True else False end as was_opened,
        case when clicks > 0 then True else False end as was_clicked
    from pivoted

)

select *
from booleans