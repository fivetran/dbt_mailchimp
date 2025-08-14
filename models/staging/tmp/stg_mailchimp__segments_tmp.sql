{{ config(enabled=var('mailchimp_using_segments', True)) }}

select * from {{ var('mailchimp_segment') }}