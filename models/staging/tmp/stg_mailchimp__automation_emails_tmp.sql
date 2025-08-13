{{ config(enabled=var('mailchimp_using_automations', True)) }}

select * from {{ var('automation_email') }}
