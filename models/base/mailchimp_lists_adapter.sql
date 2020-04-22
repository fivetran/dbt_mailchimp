with base as (

    select *
    from {{ var('list') }}
    where _fivetran_deleted = false

), fields as (

    select 
        id as list_id,
        date_created,
        name,
        list_rating
    from base

)

select *
from fields