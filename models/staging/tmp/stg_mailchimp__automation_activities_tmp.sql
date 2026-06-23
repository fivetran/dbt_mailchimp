{{ config(enabled=var('mailchimp_using_automations', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='mailchimp_sources',
        single_source_name='mailchimp',
        single_table_name='automation_recipient_activity'
    )
}}
