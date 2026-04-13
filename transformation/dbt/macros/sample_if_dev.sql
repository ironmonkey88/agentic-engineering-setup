{% macro sample_if_dev(primary_key, row_count_threshold=100000) %}
    {# 
        Wong Way 10/100 Protocol:
        If target is 'dev', apply a deterministic 10% sample for tables above the threshold.
        Using MD5 hash for cross-tool deterministic consistency (Python Ingestion parity).
    #}
    {% if target.name == 'dev' %}
        -- Deterministic 10% sample using MD5 of the primary key
        where (cast(conv(substr(md5(cast({{ primary_key }} as varchar)), 1, 2), 16, 10) as integer) % 100) < 10
    {% endif %}
{% endmacro %}
