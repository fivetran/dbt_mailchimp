{% macro get_campaign_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "archive_url", "datatype": dbt.type_string()},
    {"name": "authenticate", "datatype": "boolean"},
    {"name": "auto_footer", "datatype": "boolean"},
    {"name": "auto_tweet", "datatype": "boolean"},
    {"name": "clicktale", "datatype": dbt.type_string()},
    {"name": "content_type", "datatype": dbt.type_string()},
    {"name": "create_time", "datatype": dbt.type_timestamp()},
    {"name": "drag_and_drop", "datatype": "boolean"},
    {"name": "fb_comments", "datatype": "boolean"},
    {"name": "folder_id", "datatype": dbt.type_int()},
    {"name": "from_name", "datatype": dbt.type_string()},
    {"name": "google_analytics", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "inline_css", "datatype": "boolean"},
    {"name": "list_id", "datatype": dbt.type_string()},
    {"name": "long_archive_url", "datatype": dbt.type_string()},
    {"name": "reply_to", "datatype": dbt.type_string()},
    {"name": "segment_id", "datatype": dbt.type_int()},
    {"name": "segment_text", "datatype": dbt.type_int()},
    {"name": "send_time", "datatype": dbt.type_timestamp()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "subject_line", "datatype": dbt.type_string()},
    {"name": "template_id", "datatype": dbt.type_int()},
    {"name": "test_size", "datatype": dbt.type_int()},
    {"name": "timewarp", "datatype": "boolean"},
    {"name": "title", "datatype": dbt.type_string()},
    {"name": "to_name", "datatype": dbt.type_string()},
    {"name": "track_ecomm_360", "datatype": "boolean"},
    {"name": "track_goals", "datatype": "boolean"},
    {"name": "track_html_clicks", "datatype": "boolean"},
    {"name": "track_opens", "datatype": "boolean"},
    {"name": "track_text_clicks", "datatype": "boolean"},
    {"name": "type", "datatype": dbt.type_string()},
    {"name": "use_conversation", "datatype": "boolean"},
    {"name": "wait_time", "datatype": dbt.type_int()},
    {"name": "winner_criteria", "datatype": dbt.type_int()},
    {"name": "winning_campaign_id", "datatype": dbt.type_int()},
    {"name": "winning_combination_id", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}