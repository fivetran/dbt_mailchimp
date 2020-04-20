select *
from {{ var('campaign_campaign', ref('stg_mailchimp_campaigns')) }}