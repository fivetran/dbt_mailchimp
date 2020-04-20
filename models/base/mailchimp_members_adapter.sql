select *
from {{ var('member', ref('stg_mailchimp_members')) }}