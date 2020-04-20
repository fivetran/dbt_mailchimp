select *
from {{ var('campaign_recipient', ref('stg_mailchimp_campaign_recipients')) }}