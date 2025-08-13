{{ config(enabled=var('mailchimp_using_segments', True)) }}

select * from {{ var('segment_member') }}