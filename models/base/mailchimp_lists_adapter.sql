select *
from {{ var('list', ref('stg_mailchimp_lists')) }}