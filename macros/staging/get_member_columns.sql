{% macro get_member_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "country_code", "datatype": dbt.type_string()},
    {"name": "dstoff", "datatype": dbt.type_float()},
    {"name": "email_address", "datatype": dbt.type_string()},
    {"name": "email_client", "datatype": dbt.type_string()},
    {"name": "email_type", "datatype": dbt.type_string()},
    {"name": "gmtoff", "datatype": dbt.type_float()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "ip_opt", "datatype": dbt.type_string()},
    {"name": "ip_signup", "datatype": dbt.type_string()},
    {"name": "language", "datatype": dbt.type_string()},
    {"name": "last_changed", "datatype": dbt.type_timestamp()},
    {"name": "latitude", "datatype": dbt.type_float()},
    {"name": "list_id", "datatype": dbt.type_string()},
    {"name": "longitude", "datatype": dbt.type_float()},
    {"name": "member_rating", "datatype": dbt.type_int()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "timestamp_opt", "datatype": dbt.type_timestamp()},
    {"name": "timestamp_signup", "datatype": dbt.type_timestamp()},
    {"name": "timezone", "datatype": dbt.type_string()},
    {"name": "unique_email_id", "datatype": dbt.type_string()},
    {"name": "vip", "datatype": "boolean"}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('mailchimp__members_pass_through_columns')) }}


{{ return(columns) }}

{% endmacro %}