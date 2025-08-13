{% macro get_list_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "beamer_address", "datatype": dbt.type_string()},
    {"name": "contact_address_1", "datatype": dbt.type_string()},
    {"name": "contact_address_2", "datatype": dbt.type_int()},
    {"name": "contact_city", "datatype": dbt.type_string()},
    {"name": "contact_company", "datatype": dbt.type_string()},
    {"name": "contact_country", "datatype": dbt.type_string()},
    {"name": "contact_state", "datatype": dbt.type_string()},
    {"name": "contact_zip", "datatype": dbt.type_string()},
    {"name": "date_created", "datatype": dbt.type_timestamp()},
    {"name": "default_from_email", "datatype": dbt.type_string()},
    {"name": "default_from_name", "datatype": dbt.type_string()},
    {"name": "default_language", "datatype": dbt.type_string()},
    {"name": "default_subject", "datatype": dbt.type_int()},
    {"name": "email_type_option", "datatype": "boolean"},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "list_rating", "datatype": dbt.type_float()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "notify_on_subscribe", "datatype": dbt.type_int()},
    {"name": "notify_on_unsubscribe", "datatype": dbt.type_int()},
    {"name": "permission_reminder", "datatype": dbt.type_string()},
    {"name": "subscribe_url_long", "datatype": dbt.type_string()},
    {"name": "subscribe_url_short", "datatype": dbt.type_string()},
    {"name": "use_archive_bar", "datatype": "boolean"},
    {"name": "visibility", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}