with base as (

    select *
    from {{ var('list')}}

), fields as (

    select 
        id,
        date_created,
        name,
        list_rating
    from base

)

select *
from fields