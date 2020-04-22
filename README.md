# Mailchimp 

This package models Mailchimp data from Fivetran's data connector. It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1i8JjWRgP4bDcL-TYv5flABglA_aOBXxA_OF-j1hsDcM/edit#slide=id.g244d368397_0_1).

The main focus of the package is to transform the 'recipient' and 'activity' tables into analytics-ready models and use that data to provide aggregate metrics about campaigns, automations, lists, members and segments.

### Models

The primary outputs of this package are described below. There are several intermediate models to create these output models.

| model                         | description                                                                                                                                                              |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| mailchimp_automation_emails   | Each record represents the send of an automation email, enriched with click, open and unsubscribe metrics. (Enabled if you are using automations.)                       |
| mailchimp_automations         | Each record represents an automation in Mailchimp, enriched with click, open and unsubscribe metrics. (Enabled if you are using automations.)                            |
| mailchimp_campaign_activities | Each record represents an activity taken in relation to a campaign email, enriched with data about when the campaign was sent and the lag between send and the activity. |
| mailchimp_campaign_emails     | Each record represents the send of a campaign emails, enriched with click, open and unsubscribe metrics.                                                                 |
| mailchimp_campaigns           | Each record represents a campaign in Mailchimp, enriched with click, open and unsubscribe metrics.                                                                       |
| mailchimp_lists               | Each record represents a list in Mailchimp, enriched with campaign metrics, (optionally) automation metrics and information about members.                               |
| mailchimp_members             | Each record represents a member in Mailchimp, enriched with campaign metrics and (optionally) automation metrics.                                                        |
| mailchimp_segments            | Each record represents a segment in Mailchimp, enriched with campaign metrics and (optionally) automation metrics. (Enabled if you are using segments.)                  |

## Upcoming changes with dbt version 0.17.0

As a result of functionality being released with version 0.17.0 of dbt, there will be some upcoming changes to this package. The staging/adapter models will move into a seperate package, `mailchimp_source`, that defines the staging models and adds a source for Mailchimp data. The two packages will work together seamlessly. By default, this package will reference models in the source package, unless the config is overridden. 

There are a few benefits to this approach:
* For users who want to manage their own transformations, they can still benefit from the source definition, documentation and staging models of the source package.
* For users who have multiple sets of Mailchimp data in their warehouse, a package defining sources doesn't make sense. They will have to define their own sources and union that data together. At that point, they will still be able to make use of this package to transform their data.

When this change occurs, we will release a new version of this package.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration

The [variables](https://docs.getdbt.com/docs/using-variables) needed to configure this package are as follows:

| variable                      | information                                                                  |                required                |
| ----------------------------- | ---------------------------------------------------------------------------- | :------------------------------------: |
| campaign                      | Table, model or source containing campaign details                           |                  Yes                   |
| campaign_recipient            | Table, model or source containing campaign recipient details                 |                  Yes                   |
| campaign_recipient_activity   | Table, model or source containing campaign recipient activity details        |                  Yes                   |
| segment_member                | Table, model or source containing segment member details                     |                  Yes                   |
| list                          | Table, model or source containing list details                               |                  Yes                   |
| member                        | Table, model or source containing member details                             |                  Yes                   |
| unsubscribe                   | Table, model or source containing unsubscribe details                        |                  Yes                   |
| automation                    | Table, model or source containing automation details                         | Yes, if using_automations is not False |
| automation_email              | Table, model or source containing automation email details                   | Yes, if using_automations is not False |
| automation_recipient          | Table, model or source containing automation recipient details               | Yes, if using_automations is not False |
| automation_recipient_activity | Table, model or source containing automation recpient activity details       | Yes, if using_automations is not False |
| segment                       | Table, model or source containing segment details                            |  Yes, if using_segments is not False   |
| using_automations             | Boolean flag to set whether automation models should be used, default = True |                   No                   |
| using_segments                | Boolean flag to set whether segment models should be used, default = True    |                   No                   |

An example `dbt_project.yml` configuration:

```yml
# dbt_project.yml

...

models:
    mailchimp:
        vars:
            automation: "{{ source('mailchimp', 'automation') }}"   # or "{{ ref('mailchimp_automations_unioned'}) }}"
            automation_email: "{{ source('mailchimp', 'automation_email') }}" 
            automation_recipient: "{{ source('mailchimp', 'automation_recipient') }}"
            automation_recipient_activity: "{{ source('mailchimp', 'automation_recipient_activity') }}"
            campaign: "{{ source('mailchimp', 'campaign') }}"
            campaign_recipient: "{{ source('mailchimp', 'campaign_recipient') }}"
            campaign_recipient_activity: "{{ source('mailchimp', 'campaign_recipient_activity') }}"
            segment: "{{ source('mailchimp', 'segment') }}"
            segment_member: "{{ source('mailchimp', 'segment_member') }}"
            list: "{{ source('mailchimp', 'list') }}"
            member: "{{ source('mailchimp', 'member') }}"
            unsubscribe: "{{ source('mailchimp', 'unsubscribe') }}"
```

### Contributions ###

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
