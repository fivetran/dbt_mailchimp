# Mailchimp Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_mailchimp/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_mailchimp/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that leverage Mailchimp data from [Fivetran's connector](https://fivetran.com/docs/applications/mailchimp) in the format described by [this ERD](https://fivetran.com/docs/applications/mailchimp#schemainformation) and builds off the output of our [Mailchimp source package](https://github.com/fivetran/dbt_mailchimp_source).
- Transforms the 'recipient' and 'activity' tables into analytics-ready models and use that data to provide aggregate metrics about campaigns, automations, lists, members, and segments.

<!--section="mailchimp_transformation_model-->
- Generates a comprehensive data dictionary of your source and modeled Mailchimp data through the [dbt docs site](https://fivetran.github.io/dbt_mailchimp/#!/overview).
The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_mailchimp/#!/overview?g_v=1).

| **Table**                | **Description**                                                                                                                                |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [mailchimp__automations_activities](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__automations_activities)       | Each record represents an activity taken in relation to a automation email. |
| [mailchimp__automation_emails](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__automation_emails)   | Each record represents an automation email (that make up automations), enriched with click, open, and unsubscribe metrics. This output is enabled if you are using automations.       |
| [mailchimp__automations](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__automations)        | Each record represents an automation in Mailchimp, enriched with click, open, and unsubscribe metrics. This output is enabled if you are using automations.                            |
| [mailchimp__campaign_activities](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__campaign_activities) | Each record represents an activity taken in relation to a campaign email, enriched with data about when the campaign was sent and the lag between send and the activity. |
| [mailchimp__campaign_recipients](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__campaign_recipients) | Each record represents the send of a campaign email, enriched with click, open, and unsubscribe metrics.                                                                  |
| [mailchimp__campaigns](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__campaigns)          | Each record represents a campaign in Mailchimp, enriched with click, open, and unsubscribe metrics.                                                                       |
| [mailchimp__lists](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__lists)             | Each record represents a list in Mailchimp, enriched with campaign metrics, (optional) automation metrics, and (optional) information about members.                               |
| [mailchimp__members](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__members)           | Each record represents a member in Mailchimp, enriched with campaign metrics and (optional) automation metrics.                                                        |
| [mailchimp__segments](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__segments)          | Each record represents a segment in Mailchimp, enriched with campaign metrics and (optional) automation metrics. This output is enabled if you are using segments.                  |

### Materialized Models
Each Quickstart transformation job run materializes 33 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Mailchimp connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Step 2: Install the package
Include the following mailchimp package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/mailchimp
    version: [">=0.11.0", "<0.12.0"] # we recommend using ranges to capture non-breaking changes automatically
```
Do **NOT** include the `mailchimp_source` package in this file. The transformation package itself has a dependency on it and will install the source package as well.

#### Databricks dispatch configuration
If you are using a Databricks destination with this package, you must add the following (or a variation of the following) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']

## Step 3: Define database and schema variables
By default, this package runs using your destination and the `mailchimp` schema. If this is not where your Mailchimp data is (for example, if your Mailchimp schema is named `mailchimp_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    mailchimp_schema: your_schema_name
    mailchimp_database: your_database_name
```

## Step 4: Disable models for non-existent sources
Your Mailchimp connection might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Mailchimp or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable: 

```yml
vars:
  mailchimp_using_automations: false # disable if you do not have the automation_email, automation_email, or automation_recipient_activity tables
  mailchimp_using_segments: false # disable if you do not have the segment table
  mailchimp_using_unsubscribes: false #disable if you do not have the unsubscribe table
```

## (Optional) Step 5: Additional configurations
<details open><summary>Expand/collapse configurations</summary>

### Changing the Build Schema
By default this package will build the Mailchimp staging models within a schema titled (<target_schema> + `_stg_mailchimp`) and the Mailchimp final models within a schema titled (<target_schema> + `_mailchimp`) in your target database. If this is not where you would like your modeled Mailchimp data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
models:
  mailchimp:
    +schema: my_new_schema_name # leave blank for just the target_schema
  mailchimp_source:
    +schema: my_new_schema_name # leave blank for just the target_schema

```

### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_mailchimp_source/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    mailchimp_<default_source_table_name>_identifier: your_table_name 
```
</details>

## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: fivetran/mailchip_source
      version: [">=0.7.0", "<0.8.0"]
```

# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/mailchimp/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_mailchimp/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_mailchimp/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
