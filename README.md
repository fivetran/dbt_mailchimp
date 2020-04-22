# Mailchimp 

This package models Mailchimp data from Fivetran's data connector. It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1i8JjWRgP4bDcL-TYv5flABglA_aOBXxA_OF-j1hsDcM/edit#slide=id.g244d368397_0_1).

The main focus of the package is to transform the 'recipient' and 'activity' tables into analytics ready and use that data to provide aggregate metrics about campaigns, automations, lists, members and segments.

### Models

The primary outputs of this package are described below. There are several intermediate models to create these output models.

| model                         | description                                                                                                |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------- |
| mailchimp_automation_emails   | Each record represents the send of an automation emails, enriched with click, open and unsubscribe metrics |
| mailchimp_automations         |                                                                                                            |
| mailchimp_campaign_activities |                                                                                                            |
| mailchimp_campaign_emails     |                                                                                                            |
| mailchimp_campaigns           |                                                                                                            |
| mailchimp_lists               |                                                                                                            |
| mailchimp_members             |                                                                                                            |
| mailchimp_segments            |                                                                                                            |

## Upcoming changes with 0.17.0

## Configuration

The [variables](https://docs.getdbt.com/docs/using-variables) needed to configure this package are as follows:

| variable | information | required |
| -------- | ----------- | :------: |

## Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
