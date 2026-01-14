# dbt_mailchimp v1.3.0

[PR #59](https://github.com/fivetran/dbt_mailchimp/pull/59) includes the following updates:

## Documentation
- Updates README with standardized Fivetran formatting

## Under the Hood
- In the `quickstart.yml` file:
  - Adds `table_variables` for relevant sources to prevent missing sources from blocking downstream Quickstart models.
  - Adds `supported_vars` for Quickstart UI customization,

# dbt_mailchimp v1.2.0

[PR #58](https://github.com/fivetran/dbt_mailchimp/pull/58) includes the following updates:

## Features
  - Increases the required dbt version upper limit to v3.0.0

# dbt_mailchimp v1.1.0
[PR #57](https://github.com/fivetran/dbt_mailchimp/pull/57) includes the following updates:

## Schema/Data Change
**7 total changes • 0 possible breaking changes**

| Data Model(s) | Change type | Old | New | Notes |
| ------------- | ----------- | ----| --- | ----- |
| All models | New column | | `source_relation` | Identifies the source connection when using multiple Mailchimp connections |
| `stg_mailchimp__automation_activities`<br>`mailchimp__automation_activities` | Updated surrogate key | `activity_id` = `action_type` + `automation_email_id` + `member_id` + `activity_timestamp` | `activity_id` = `source_relation` + `action_type` + `automation_email_id` + `member_id` + `activity_timestamp` | Updated to include `source_relation` |
| `stg_mailchimp__automation_recipients` | Updated surrogate key | `automation_recipient_id` = `member_id` + `automation_email_id` | `automation_recipient_id` = `source_relation` + `member_id` + `automation_email_id` | Updated to include `source_relation` |
| `stg_mailchimp__campaign_activities`<br>`mailchimp__campaign_activities` | Updated surrogate key | `activity_id` = `action_type` + `campaign_id` + `member_id` + `activity_timestamp` | `activity_id` = `source_relation` + `action_type` + `campaign_id` + `member_id` + `activity_timestamp` | Updated to include `source_relation` |
| `stg_mailchimp__campaign_activities`<br>`mailchimp__campaign_activities` | Updated surrogate key | `email_id` = `campaign_id` + `member_id` | `email_id` = `source_relation` + `campaign_id` + `member_id` | Updated to include `source_relation` |
| `stg_mailchimp__campaign_recipients`<br>`mailchimp__campaign_recipients` | Updated surrogate key | `email_id` = `campaign_id` + `member_id` | `email_id` = `source_relation` + `campaign_id` + `member_id` | Updated to include `source_relation` |
| `stg_mailchimp__unsubscribes` | Updated surrogate key | `unsubscribe_id` = `member_id` + `list_id` + `unsubscribe_timestamp` | `unsubscribe_id` = `source_relation` + `member_id` + `list_id` + `unsubscribe_timestamp` | Updated to include `source_relation` |

## Feature Update
- **Union Data Functionality**: This release supports running the package on multiple Mailchimp source connections. See the [README](https://github.com/fivetran/dbt_mailchimp/tree/main?tab=readme-ov-file#step-3-define-database-and-schema-variables) for details on how to leverage this feature.

## Tests Update
- Removes uniqueness tests for primary keys. The new unioning feature requires combination-of-column tests to consider the new `source_relation` column in addition to the existing primary key, but this is not supported across dbt versions.
  - Note that surrogate keys are unaffected and retain their uniqueness tests.  
- Primary key tests will be reintroduced once a version-agnostic solution is available.

# dbt_mailchimp v1.0.0

[PR #55](https://github.com/fivetran/dbt_mailchimp/pull/55) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/mailchimp_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/mailchimp_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/mailchimp_source` package will also need to be removed or updated to reference this package.
  - Update any mailchimp_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_mailchimp/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_mailchimp v0.12.0

[PR #52](https://github.com/fivetran/dbt_mailchimp/pull/52) includes the following updates:

## Breaking Change for dbt Core < 1.9.6

> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([Mailchimp Source v0.8.0](https://github.com/fivetran/dbt_mailchimp_source/releases/tag/v0.8.0)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `mailchimp` in file
`models/src_mailchimp.yml`. The `freshness` top-level property should be moved
into the `config` of `mailchimp`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Mailchimp freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `mailchimp` package. Pin your dependency on v0.11.0 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `mailchimp` source and apply freshness via the previous release top-level property route. This will require you to copy and paste the entirety of the previous release `src_mailchimp.yml` file and add an `overrides: mailchimp_source` property.

## Under the Hood
- Updates to ensure integration tests use latest version of dbt.

# dbt_mailchimp v0.11.0
[PR #51](https://github.com/fivetran/dbt_mailchimp/pull/51) includes the following updates.

## Schema Changes

**1 total change • 1 possible breaking change**
| **Model/Column** | **Change type** | **Old materialization** | **New materialization** | **Notes** |
| ---------------- | --------------- | ------------ | ------------ | --------- |
| [*_tmp](https://github.com/fivetran/dbt_mailchimp_source/tree/main/models/tmp) Models | New Materialization | Table  | View | Fixed the materialization config in the `dbt_project.yml` to ensure staging `*_tmp` models are materialized as views rather than tables. **This is a breaking change and will require a `dbt run --full-refresh`.** ([Source #25](https://github.com/fivetran/dbt_mailchimp_source/pull/25)) |

## Under the Hood
- Updated the triggers for the `auto-release` workflow.
- Added the `generate-docs` workflow.

# dbt_mailchimp v0.10.1

## Documentation
- Added Quickstart model counts to README. ([#47](https://github.com/fivetran/dbt_mailchimp/pull/47))
- Corrected references to connectors and connections in the README. ([#47](https://github.com/fivetran/dbt_mailchimp/pull/47))

## Under the Hood
- Prepends `materialized` configs in the package's `dbt_project.yml` file with `+` to improve compatibility with the newer versions of dbt-core starting with v1.10.0. ([PR #48](https://github.com/fivetran/dbt_mailchimp/pull/48))
- Updates the package maintainer pull request template. ([PR #49](https://github.com/fivetran/dbt_mailchimp/pull/49))

## Contributors
- [@b-per](https://github.com/b-per) ([PR #48](https://github.com/fivetran/dbt_mailchimp/pull/48))

# dbt_mailchimp v0.10.0
[PR #46](https://github.com/fivetran/dbt_mailchimp/pull/46) includes the following updates:

## Breaking Changes
- Added the ability to disable the `unsubscribe` source by setting the `mailchimp_using_unsubscribes` variable in your `dbt_project.yml`. 
  - For details on configuring this variable, refer to the [README](https://github.com/fivetran/dbt_mailchimp/blob/main/README.md#step-4-disable-models-for-non-existent-sources).
  - Disabling the `unsubscribe` source will disable any `*unsubscribe*` fields in the following models and their upstream dependencies:
    - `mailchimp__automation_emails`
    - `mailchimp__automations`
    - `mailchimp__campaign_recipients`
    - `mailchimp__campaigns`
    - `mailchimp__lists`
    - `mailchimp__members`
    - `mailchimp__segments`

## Under the Hood (Maintainers only)
- Added `mailchimp_using_unsubscribes` to `quickstart.yml`.
- Added consistency tests for all end models.ß

# dbt_mailchimp v0.9.0
[PR #40](https://github.com/fivetran/dbt_mailchimp/pull/40) includes the following updates:
## Bugfix
- The original `mailchimp__members` only tested uniqueness on member_id, however the same member can belong on multiple lists. Therefore this update adds `list_id` as a dimension in `mailchimp__members`, in addition to the existing `member_id`. 

## Under the Hood
- Swaps the order of CTE's joined in the `int_mailchimp__automation_activities_by_*` models to first use a CTE where fields will be known to exist.
- Updates the seed data used in integration testing to include a new record for an existing `member_id` with a new `list_id`.

## Note
- While this is not a breaking change, the updates are fairly complex (we switched around a few joins and the order of fields in a few coalesce statements, so you may see updated records if, for example, the records were showing up as null before). 

# dbt_mailchimp v0.8.0
## 🎉 Feature Update
- Databricks compatibility! ([#37](https://github.com/fivetran/dbt_mailchimp/pull/37))
- Small updates to documentation. ([#37](https://github.com/fivetran/dbt_mailchimp/pull/37))

 ## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#34](https://github.com/fivetran/dbt_mailchimp/pull/34))
- Updated the pull request [templates](/.github). ([#34](https://github.com/fivetran/dbt_mailchimp/pull/34))

# dbt_mailchimp v0.7.0
[PR #30](https://github.com/fivetran/dbt_mailchimp/pull/30) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `dbt_utils.surrogate_key` has also been updated to `dbt_utils.generate_surrogate_key`. Since the method for creating surrogate keys differ, we suggest all users do a `full-refresh` for the most accurate data. For more information, please refer to dbt-utils [release notes](https://github.com/dbt-labs/dbt-utils/releases) for this update.
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
## 🎉 Documentation and Feature Updates 🎉:
- Updated README documentation for easier navigation and dbt package setup.

# dbt_mailchimp v0.6.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_mailchimp_source`. Additionally, the latest `dbt_mailchimp_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.


# dbt_mailchimp v0.5.0

## 🚨 Breaking Changes
- Updating mailchimp transforms to reflect breaking change updates from mailchimp source (v0.1.0 -> v0.2.0) package. 

# dbt_mailchimp v0.4.0

## 🚨 Breaking Changes
- Updating the mailchimp transforms package to current standards. These changes include the following: ([#23](https://github.com/fivetran/dbt_mailchimp/pull/23))
  - Updating intermediate and final model names to reflect dbt best practices. For example, 
    - Old: `mailchimp_automation_emails` 
    - New: `mailchimp__automation_emails` (A two-underscore suffix to align with best naming practices)

  - Removing the base models; these have been placed in the dbt_mailchimp_source package and are now prefixed by "stg". 
   - The dbt_mailchimp_source package is natively a dependency for this package, as stated in the packages.yml file. There is nothing needing to be done by the user.
        ```yaml
        packages:
          - package: fivetran/dbt_mailchimp_source 
            version: [">=0.1.0", "<0.2.0"]
        ```

## Bug Fixes
- n/a

## Features
- Added Circle CI testing
- Added integration testing
- Created dbt_mailchimp_source package
- Added list info to segment data (for example, adding `list_name` to `mailchimp__segments`) 
- Updated variable 'segment' to 'mailchimp_segment' to differentiate between similar variable in dbt-lab's Segment package (refer to [this feature request](https://github.com/fivetran/dbt_mailchimp/issues/20])

## Under the Hood
- Added Postgres compatability 
