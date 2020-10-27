# Mailchimp 

This package models Mailchimp data from [Fivetran's connector](https://fivetran.com/docs/applications/mailchimp). It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1i8JjWRgP4bDcL-TYv5flABglA_aOBXxA_OF-j1hsDcM/edit#slide=id.g244d368397_0_1).

The main focus of the package is to transform the 'recipient' and 'activity' tables into analytics-ready models and use that data to provide aggregate metrics about campaigns, automations, lists, members, and segments.

## Models

The primary outputs of this package are described below. Intermediate models are used to create these output models.

| model                         | description                                                                                                                                                              |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| mailchimp_automation_emails   | Each record represents an automation email (that make up automations), enriched with click, open, and unsubscribe metrics. This output is enabled if you are using automations.       |
| mailchimp_automations         | Each record represents an automation in Mailchimp, enriched with click, open, and unsubscribe metrics. This output is enabled if you are using automations.                            |
| mailchimp_campaign_activities | Each record represents an activity taken in relation to a campaign email, enriched with data about when the campaign was sent and the lag between send and the activity. |
| mailchimp_campaign_recipients | Each record represents the send of a campaign email, enriched with click, open, and unsubscribe metrics.                                                                  |
| mailchimp_campaigns           | Each record represents a campaign in Mailchimp, enriched with click, open, and unsubscribe metrics.                                                                       |
| mailchimp_lists               | Each record represents a list in Mailchimp, enriched with campaign metrics, (optional) automation metrics, and (optional) information about members.                               |
| mailchimp_members             | Each record represents a member in Mailchimp, enriched with campaign metrics and (optional) automation metrics.                                                        |
| mailchimp_segments            | Each record represents a segment in Mailchimp, enriched with campaign metrics and (optional) automation metrics. This output is enabled if you are using segments.                  |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default, this package looks for your Mailchimp data in the `mailchimp` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Mailchimp data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    mailchimp_schema: your_database_name
    mailchimp_database: your_schema_name
```

## Disabling models

It's possible that your Mailchimp connector does not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Mailchimp or actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must add the relevant variables. By default, all variables are assumed to be `true`. Add variables for only the tables you would like to disable:  

```yml
# dbt_project.yml

...
config-version: 2

vars:
  zendesk:
    using_automations: false #disable if you do not have the automation_email, automation_email, or automation_recipient_activity tables
    using_segments: false #disable if you do not have the segment table
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn more about Fivetran [in the Fivetran docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices