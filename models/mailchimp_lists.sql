with lists as (

    select *
    from {{ ref('mailchimp_lists_adapter')}}

), activities as (

    select *
    from {{ ref('activities_by_list') }}

), joined as (

    select 
        lists.*,
        coalesce(activities.sends,0) as sends,
        coalesce(activities.opens,0) as opens,
        coalesce(activities.clicks,0) as clicks,
        coalesce(activities.unique_opens,0) as unique_opens,
        coalesce(activities.unique_clicks,0) as unique_clicks,
        coalesce(activities.unsubscribes,0) as unsubscribes
    from lists
    left join activities
        on lists.list_id = activities.list_id

)

select *
from joined