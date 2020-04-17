{% set values = ['open','click'] %}

with activities as (

    select *
    from {{ ref('stg_mailchimp_campaign_activities')}}

), pivoted as (

    select 
        email_id,
        {{
            dbt_utils.pivot(
                column='action_type',
                values=values,
                agg='sum',
                suffix='s'
            )
        }},
        {{
            dbt_utils.pivot(
                column='action_type',
                values=values,
                agg='count',
                distinct=True,
                prefix='unique_',
                suffix='s'
            )
        }}
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