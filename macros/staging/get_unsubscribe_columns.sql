{% macro get_unsubscribe_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "list_id", "datatype": dbt.type_string()},
    {"name": "member_id", "datatype": dbt.type_string()},
    {"name": "reason", "datatype": dbt.type_int()},
    {"name": "timestamp", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}