{{ config(enabled=var('mailchimp_using_unsubscribes', True)) }}

select * from {{ var('unsubscribe') }}