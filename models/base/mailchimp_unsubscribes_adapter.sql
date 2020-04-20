select *
from {{ var('unsubscribe', ref('stg_mailchimp_unsubscribes')) }}