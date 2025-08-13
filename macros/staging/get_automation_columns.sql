{% macro get_automation_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "create_time", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "list_id", "datatype": dbt.type_string()},
    {"name": "segment_id", "datatype": dbt.type_int()},
    {"name": "segment_text", "datatype": dbt.type_int()},
    {"name": "start_time", "datatype": dbt.type_timestamp()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "title", "datatype": dbt.type_string()},
    {"name": "trigger_settings", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}