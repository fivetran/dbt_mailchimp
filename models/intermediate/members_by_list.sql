with members as (

    select *
    from {{ ref('mailchimp_members') }}

), by_list as (

    select 
        list_id,
        count(*) as count_members,
        max(signup_timestamp) as most_recent_signup_timestamp
    from members 
    group by 1

)

select *
from by_list