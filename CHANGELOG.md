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
            version: [">=0.2.0", "<0.3.0"]
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
