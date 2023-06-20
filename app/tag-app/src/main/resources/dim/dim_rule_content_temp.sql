--------------balance_grade  ALL_DAI(0x6b1754)_ALL_BALANCE_GRADE
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
select 'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as label_type,
       'T' operate_type,
       'balance_grade' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;
INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_2247','ALL','ALL_ALL_ALL_BALANCE_GRADE','T','balance_grade','2023-06-20 00:27:36.873','ALL','token');


--------------balance_rank  ALL_DAI(0x6b1754)_ALL_BALANCE_RANK
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
select 'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as label_type,
       'T' operate_type,
       'balance_rank' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;
INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_4496','ALL','ALL_ALL_ALL_BALANCE_RANK','T','balance_rank','2023-06-20 00:27:41.348','ALL','token');


--------------balance_top  ALL_DAI(0x6b1754)_ALL_BALANCE_TOP
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
select 'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as label_type,
       'T' operate_type,
       'balance_top' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;
INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_4495','ALL','ALL_ALL_ALL_BALANCE_TOP','T','balance_top','2023-06-20 00:27:41.348','ALL','token');

--------------count  ALL_DAI(0x6b1754)_ALL_ACTIVITY
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
select 'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as label_type,
       'T' operate_type,
       'count' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;
INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_6743','ALL','ALL_ALL_ALL_ACTIVITY','A','count','2023-06-20 00:27:45.374','ALL','token');

--------------time_grade
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
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

--------------time_special  DAI(0x6b1754)_HOLDING_TIME_SPECIAL
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
select upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as rule_code,
       t.address as token,
       upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as label_type,
       'T' operate_type,
       'time_special' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;


--------------volume_grade  ALL_DAI(0x6b1754)_ALL_VOLUME_GRADE
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
select 'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as label_type,
       'T' operate_type,
       'volume_grade' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;
INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_3371','ALL','ALL_ALL_ALL_VOLUME_GRADE','T','volume_grade','2023-06-20 00:27:38.850','ALL','token');

--------------volume_rank  ALL_DAI(0x6b1754)_ALL_VOLUME_RANK
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
select 'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as label_type,
       'T' operate_type,
       'volume_rank' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;
INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_7867','ALL','ALL_ALL_ALL_VOLUME_RANK','T','volume_rank','2023-06-20 00:27:47.836','ALL','token');







