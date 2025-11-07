with members as (

    select *
    from {{ ref('mailchimp__members') }}

), by_list as (

    select
        source_relation,
        list_id,
        count(*) as count_members,
        max(signup_timestamp) as most_recent_signup_timestamp
    from members
    group by 1,2

)

select *
from by_list