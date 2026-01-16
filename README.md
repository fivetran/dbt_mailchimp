<!--section="mailchimp_transformation_model"-->
# Mailchimp dbt Package

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_mailchimp/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0,_<3.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

This dbt package transforms data from Fivetran's Mailchimp connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 33
- Connector documentation
  - [Mailchimp connector documentation](https://fivetran.com/docs/connectors/applications/mailchimp)
  - [Mailchimp ERD](https://fivetran.com/docs/connectors/applications/mailchimp#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_mailchimp)
  - [dbt Docs](https://fivetran.github.io/dbt_mailchimp/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_mailchimp/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_mailchimp/blob/main/CHANGELOG.md)

## What does this dbt package do?
This package enables you to transform recipient and activity tables into analytics-ready models and provide aggregate metrics about campaigns, automations, lists, members, and segments. It creates enriched models with metrics focused on email performance, member engagement, and campaign effectiveness.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_mailchimp
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [mailchimp__automations_activities](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__automations_activities) | Tracks individual user activities (opens, clicks, bounces) for automation emails with timestamp, IP, URL, and bounce type details to analyze automation engagement patterns and troubleshoot delivery issues. <br></br>**Example Analytics Questions:**<ul><li>Which automated emails are driving the most subscriber engagement (opens and clicks)?</li><li>Where are delivery issues occurring across our automation workflows?</li><li>What content and links resonate most with different audience segments in our automated emails?</li></ul>|
| [mailchimp__automation_emails](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__automation_emails) | Provides detailed automation email profiles with timing (created, started, sent), delay settings, tracking configurations, subject lines, status, and engagement metrics (sends, opens, clicks, unsubscribes) to optimize automation workflows and email performance. <br></br>**Example Analytics Questions:**<ul><li>Which emails in our automation sequences have the strongest performance?</li><li>How does email timing impact subscriber engagement and retention?</li><li>Are there specific workflow positions where subscribers tend to disengage?</li></ul>|
| [mailchimp__automations](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__automations) | Summarizes automation workflows with timing (created, started), status, trigger settings, list and segment targeting, and aggregate engagement metrics (sends, opens, clicks, unsubscribes) to measure automation effectiveness and ROI. <br></br>**Example Analytics Questions:**<ul><li>Which automation workflows generate the best ROI for our email marketing?</li><li>How quickly do our automations convert after being activated?</li><li>Which audience triggers and segments respond best to automated campaigns?</li></ul>|
| [mailchimp__campaign_activities](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__campaign_activities) | Chronicles individual user activities (opens, clicks, bounces) for campaign emails with send timing, response lag metrics (minutes, hours, days), IP addresses, URLs, and bounce types to analyze campaign engagement timing and patterns. <br></br>**Example Analytics Questions:**<ul><li>When are subscribers most likely to engage with our campaign emails?</li><li>Which campaigns and content drive the fastest response from our audience?</li><li>What delivery problems are affecting campaign performance?</li></ul>|
| [mailchimp__campaign_recipients](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__campaign_recipients) | Tracks campaign email sends at the recipient level with engagement metrics (opens, clicks), engagement flags (was_opened, was_clicked, was_unsubscribed), and time-to-open calculations to analyze individual recipient behavior and response timing. <br></br>**Example Analytics Questions:**<ul><li>How engaged are recipients with our campaigns across different audience segments?</li><li>How quickly do subscribers respond to our emails after receiving them?</li><li>Which campaigns successfully convert passive readers into active clickers?</li></ul>|
| [mailchimp__campaigns](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__campaigns) | Consolidates campaign profiles with timing, list/segment targeting, campaign type, content settings, A/B test configurations (test_size, wait_time, winner_criteria), and comprehensive engagement metrics (sends, opens, clicks, unsubscribes) to measure campaign performance and optimize future sends. <br></br>**Example Analytics Questions:**<ul><li>Which campaign types and strategies deliver the strongest engagement?</li><li>Are our A/B tests helping us improve campaign performance?</li><li>How does campaign preparation time impact our send schedule and results?</li></ul>|
| [mailchimp__lists](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__lists) | Provides comprehensive list profiles with contact details, subscription URLs, list rating, member counts, most recent signup timing, and aggregate campaign and automation metrics (sends, opens, clicks, unsubscribes) to evaluate list health and growth. <br></br>**Example Analytics Questions:**<ul><li>Which email lists have the most engaged and growing audiences?</li><li>How does list health and quality impact campaign and automation performance?</li><li>Are our automated emails performing as well as one-time campaigns for each list?</li></ul>|
| [mailchimp__members](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__members) | Consolidates member profiles with email details, subscription status, signup and opt-in timing, location data (country, timezone, latitude/longitude), member rating, VIP status, and engagement metrics (campaign and automation) to segment audiences and personalize communications. <br></br>**Example Analytics Questions:**<ul><li>Who are our most engaged subscribers and where are they located?</li><li>How do VIP members and high-value subscribers interact with our emails differently?</li><li>What's the subscriber journey from signup to becoming an engaged member?</li></ul>|
| [mailchimp__segments](https://fivetran.github.io/dbt_mailchimp/#!/model/model.mailchimp.mailchimp__segments) | Tracks segment profiles with list associations, member counts, segment type, creation and update timing, and aggregate campaign and automation metrics (sends, opens, clicks, unsubscribes) to measure segment performance and refine targeting strategies. <br></br>**Example Analytics Questions:**<ul><li>Which audience segments deliver the best campaign performance?</li><li>How do our targeted segments compare in engagement between campaigns and automations?</li><li>Which segments are growing or changing, and how does that affect their engagement?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Mailchimp connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_mailchimp/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following mailchimp package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/mailchimp
    version: [">=1.2.0", "<1.3.0"] # we recommend using ranges to capture non-breaking changes automatically
```
> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/mailchimp_source` in your `packages.yml` since this package has been deprecated.

#### Databricks dispatch configuration
If you are using a Databricks destination with this package, you must add the following (or a variation of the following) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Define database and schema variables

#### Option A: Single connection
By default, this package runs using your [destination](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile) and the `mailchimp` schema. If this is not where your Mailchimp data is (for example, if your Mailchimp schema is named `mailchimp_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  mailchimp:
    mailchimp_database: your_database_name
    mailchimp_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple Mailchimp connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the `mailchimp_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  mailchimp:
    mailchimp_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

##### Recommended: Incorporate unioned sources into DAG
> *If you are running the package through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore), the below step is necessary in order to synchronize model runs with your Mailchimp connections. Alternatively, you may choose to run the package through Fivetran [Quickstart](https://fivetran.com/docs/transformations/quickstart), which would create separate sets of models for each Mailchimp source rather than one set of unioned models.*

By default, this package defines one single-connection source, called `mailchimp`, which will be disabled if you are unioning multiple connections. This means that your DAG will not include your Mailchimp sources, though the package will run successfully.

To properly incorporate all of your Mailchimp connections into your project's DAG:
1. Define each of your sources in a `.yml` file in your project. Utilize the following template for the `source`-level configurations, and, **most importantly**, copy and paste the table and column-level definitions from the package's `src_mailchimp.yml` [file](https://github.com/fivetran/dbt_mailchimp/blob/main/models/staging/src_mailchimp.yml).

```yml
# a .yml file in your root project

version: 2

sources:
  - name: <name> # ex: Should match name in mailchimp_sources
    schema: <schema_name>
    database: <database_name>
    loader: fivetran
    config:
      loaded_at_field: _fivetran_synced
      freshness: # feel free to adjust to your liking
        warn_after: {count: 72, period: hour}
        error_after: {count: 168, period: hour}

    tables: # copy and paste from mailchimp/models/staging/src_mailchimp.yml - see https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/ for how to use anchors to only do so once
```

> **Note**: If there are source tables you do not have (see [Disable models for non-existent sources](#disable-models-for-non-existent-sources)), you may still include them, as long as you have set the right variables to `False`.

2. Set the `has_defined_sources` variable (scoped to the `mailchimp` package) to `True`, like such:
```yml
# dbt_project.yml
vars:
  mailchimp:
    has_defined_sources: true
```

### Disable models for non-existent sources
Your Mailchimp connection might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Mailchimp or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable: 

```yml
vars:
  mailchimp_using_automations: false # disable if you do not have the automation_email, automation_email, or automation_recipient_activity tables
  mailchimp_using_segments: false # disable if you do not have the segment table
  mailchimp_using_unsubscribes: false #disable if you do not have the unsubscribe table
```

## (Optional) Additional configurations
<details open><summary>Expand/collapse configurations</summary>

### Changing the Build Schema
By default this package will build the Mailchimp staging models within a schema titled (<target_schema> + `_stg_mailchimp`) and the Mailchimp final models within a schema titled (<target_schema> + `_mailchimp`) in your target database. If this is not where you would like your modeled Mailchimp data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
models:
    mailchimp:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_mailchimp/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    mailchimp_<default_source_table_name>_identifier: your_table_name 
```
</details>

## (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt/setup-guide#transformationsfordbtcoresetupguide).
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
```

<!--section="mailchimp_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/mailchimp/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_mailchimp/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_mailchimp/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).