{% macro get_campaign_recipient_activity_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "action", "datatype": dbt.type_string()},
    {"name": "bounce_type", "datatype": dbt.type_int()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "combination_id", "datatype": dbt.type_int()},
    {"name": "ip", "datatype": dbt.type_string()},
    {"name": "list_id", "datatype": dbt.type_string()},
    {"name": "member_id", "datatype": dbt.type_string()},
    {"name": "timestamp", "datatype": dbt.type_timestamp()},
    {"name": "url", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}