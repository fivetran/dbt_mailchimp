select *
from {{ var('campaign', ref('stg_mailchimp_campaigns')) }}