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
