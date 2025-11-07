{{ config(enabled=var('mailchimp_using_automations', True)) }}

{{
    mailchimp.mailchimp_union_connections(
        connection_dictionary='mailchimp_sources',
        single_source_name='mailchimp',
        single_table_name='automation'
    )
}}

