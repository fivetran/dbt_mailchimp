{{ config(enabled=var('mailchimp_using_automations', True)) }}

with base as (

    select *
    from {{ ref('stg_mailchimp__automation_recipients_tmp')}}

), 

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_mailchimp__automation_recipients_tmp')),
                staging_columns=get_automation_recipient_columns()
            )
        }}
        {{ mailchimp.apply_source_relation() }}

    from base

), 


final as (

     select
        source_relation,
        member_id,
        automation_email_id,
        list_id
    from fields

),

 unique_key as (

    select
        *,
        {{ dbt_utils.generate_surrogate_key(['source_relation','member_id','automation_email_id']) }} as automation_recipient_id
    from final

)

select *
from unique_key