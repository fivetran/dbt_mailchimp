{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'mailchimp') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('mailchimp_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("mailchimp_database", target.database) }}' || '.'|| '{{ var("mailchimp_schema", "mailchimp") }}' as source_relation
{% endif %}

{%- endmacro %}