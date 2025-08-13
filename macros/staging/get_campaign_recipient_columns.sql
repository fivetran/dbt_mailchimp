{% macro get_campaign_recipient_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "combination_id", "datatype": dbt.type_int()},
    {"name": "list_id", "datatype": dbt.type_string()},
    {"name": "member_id", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}