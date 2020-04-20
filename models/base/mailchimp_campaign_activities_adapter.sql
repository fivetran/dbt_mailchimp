select *
from {{ var('campaign_campaign_activity', ref('stg_mailchimp_campaign_activities')) }}