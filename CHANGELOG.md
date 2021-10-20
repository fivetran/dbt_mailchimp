# dbt_mailchimp v0.4.0

## 🚨 Breaking Changes
- Updating the mailchimp transforms package to current standards. ([#23](https://github.com/fivetran/dbt_mailchimp/pull/23))
  - These changes include 
    - Removing the base models; these have been placed in the dbt_mailchimp_source package and are now prefixed by "stg". 
    - Updating intermediate and final model names to reflect dbt best practices.

## Bug Fixes
- n/a

## Features
- Added Circle CI testing
- Added integration testing
- Created dbt_mailchimp_source package
- Added list info to segment data (for example, `list_name` to `mailchimp__segments`) 

## Under the Hood
- n/a