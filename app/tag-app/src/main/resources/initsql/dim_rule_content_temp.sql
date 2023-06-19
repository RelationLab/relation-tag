insert
into
    dim_rule_content(rule_code,
                     token,
                     label_type,
                     operate_type,
                     data_subject,
                     create_time,
                     token_name,
                     token_type)
select upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as rule_code,
       t.address as token,
       upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as label_type,
       'T' operate_type,
       'time_grade' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from top_token_1000 t;
