{% macro get_automation_email_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "archive_url", "datatype": dbt.type_string()},
    {"name": "authenticate", "datatype": "boolean"},
    {"name": "auto_footer", "datatype": "boolean"},
    {"name": "auto_tweet", "datatype": "boolean"},
    {"name": "automation_id", "datatype": dbt.type_string()},
    {"name": "clicktale", "datatype": dbt.type_int()},
    {"name": "content_type", "datatype": dbt.type_string()},
    {"name": "create_time", "datatype": dbt.type_timestamp()},
    {"name": "delay_action", "datatype": dbt.type_string()},
    {"name": "delay_action_description", "datatype": dbt.type_string()},
    {"name": "delay_amount", "datatype": dbt.type_int()},
    {"name": "delay_direction", "datatype": dbt.type_int()},
    {"name": "delay_full_description", "datatype": dbt.type_string()},
    {"name": "delay_type", "datatype": dbt.type_string()},
    {"name": "drag_and_drop", "datatype": "boolean"},
    {"name": "fb_comments", "datatype": "boolean"},
    {"name": "folder_id", "datatype": dbt.type_int()},
    {"name": "from_name", "datatype": dbt.type_string()},
    {"name": "google_analytics", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "inline_css", "datatype": "boolean"},
    {"name": "position", "datatype": dbt.type_int()},
    {"name": "reply_to", "datatype": dbt.type_string()},
    {"name": "send_time", "datatype": dbt.type_timestamp()},
    {"name": "start_time", "datatype": dbt.type_timestamp()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "subject_line", "datatype": dbt.type_string()},
    {"name": "template_id", "datatype": dbt.type_int()},
    {"name": "timewarp", "datatype": dbt.type_int()},
    {"name": "title", "datatype": dbt.type_string()},
    {"name": "to_name", "datatype": dbt.type_int()},
    {"name": "track_ecomm_360", "datatype": "boolean"},
    {"name": "track_goals", "datatype": "boolean"},
    {"name": "track_html_clicks", "datatype": "boolean"},
    {"name": "track_opens", "datatype": "boolean"},
    {"name": "track_text_clicks", "datatype": "boolean"},
    {"name": "use_conversation", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}