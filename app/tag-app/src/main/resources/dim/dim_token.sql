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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as "type",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
   top_token_1000  t
    inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_grade') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;

INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_2247','ALL','ALL_ALL_ALL_BALANCE_GRADE','T','balance_grade','2023-06-20 00:27:36.873','ALL','token');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_L1','SYSTEM','PUBLIC','GRADE','Token Balance Lv1','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_L2','SYSTEM','PUBLIC','GRADE','Token Balance Lv2','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_L3','SYSTEM','PUBLIC','GRADE','Token Balance Lv3','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_L4','SYSTEM','PUBLIC','GRADE','Token Balance Lv4','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_L5','SYSTEM','PUBLIC','GRADE','Token Balance Lv5','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_L6','SYSTEM','PUBLIC','GRADE','Token Balance Lv6','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_Millionaire','SYSTEM','PUBLIC','GRADE','Token Millionaire','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_BALANCE_GRADE','ALL_ALL_ALL_BALANCE_GRADE_Billionaire','SYSTEM','PUBLIC','GRADE','Token Billionaire','',NULL,'SQL','ALL_ALL_ALL_BALANCE_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:09.227','2023-06-20 07:52:09.227',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING');


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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as "type",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    top_token_1000  t
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_rank') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;

INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_4496','ALL','ALL_ALL_ALL_BALANCE_RANK','T','balance_rank','2023-06-20 00:27:41.348','ALL','token');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
    ('RelationTeam','ALL_ALL_ALL_BALANCE_RANK','ALL_ALL_ALL_BALANCE_RANK_HIGH_BALANCE','SYSTEM','PUBLIC','GRADE','Token High Balance','',NULL,'SQL','ALL_ALL_ALL_BALANCE_RANK','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING');


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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as "type",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    top_token_1000  t
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_top') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;

INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_4495','ALL','ALL_ALL_ALL_BALANCE_TOP','T','balance_top','2023-06-20 00:27:41.348','ALL','token');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
    ('RelationTeam','ALL_ALL_ALL_BALANCE_TOP','ALL_ALL_ALL_BALANCE_TOP_WHALE','SYSTEM','PUBLIC','GRADE','Token Whale','',NULL,'SQL','ALL_ALL_ALL_BALANCE_TOP','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING');


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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as "type",
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    top_token_1000  t
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_count') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;

INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_6743','ALL','ALL_ALL_ALL_ACTIVITY','A','count','2023-06-20 00:27:45.374','ALL','token');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_L1','SYSTEM','PUBLIC','TOTAL_PART','Token Activity Lv1',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_L2','SYSTEM','PUBLIC','TOTAL_PART','Token Activity Lv2',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_L3','SYSTEM','PUBLIC','TOTAL_PART','Token Activity Lv3',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_L4','SYSTEM','PUBLIC','TOTAL_PART','Token Activity Lv4',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_L5','SYSTEM','PUBLIC','TOTAL_PART','Token Activity Lv5',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_L6','SYSTEM','PUBLIC','TOTAL_PART','Token Activity Lv6',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_High','SYSTEM','PUBLIC','TOTAL_PART','Token Highest Activity',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_Medium','SYSTEM','PUBLIC','TOTAL_PART','Token High Activity',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_ACTIVITY','ALL_ALL_ALL_ACTIVITY_Low','SYSTEM','PUBLIC','TOTAL_PART','Token Medium Activity',NULL,'','SQL','ALL_ALL_ALL_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:53:38.793','2023-06-20 07:53:38.793',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING');

--------------time_grade DOP(0x6bb612)_HOLDING_TIME_GRADE
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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as "type",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    top_token_1000  t
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_time_grade') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;

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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as "type",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    top_token_1000  t
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_time_special') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;


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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as "type",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol|| (case level_def.level='Million' or level_def.level='Billion' then ' '||level_def.level else '' end)||' '||level_def.level_name  "content",
    'SQL' rule_type,
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    top_token_1000  t
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_volume_grade') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;

INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_3371','ALL','ALL_ALL_ALL_VOLUME_GRADE','T','volume_grade','2023-06-20 00:27:38.850','ALL','token');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','Token Vol Lv1','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','Token Vol Lv2','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','Token Vol Lv3','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','Token Vol Lv4','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','Token Vol Lv5','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','Token Vol Lv6','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_Million','SYSTEM','PUBLIC','GRADE','Token Million Trader','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_GRADE','ALL_ALL_ALL_VOLUME_GRADE_Billion','SYSTEM','PUBLIC','GRADE','Token Billion Trader','',NULL,'SQL','ALL_ALL_ALL_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:52:17.298','2023-06-20 07:52:17.298',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING');

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

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as "type",
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    upper(t.symbol)||'_'||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    top_token_1000  t
        inner join (
        select
            *
        from
            level_def
        where
                type = 'token_volume_rank') level_def on
        (1 = 1)
where holders>=100 and removed<>'true' ;

INSERT INTO dim_rule_content (rule_code,"token",label_type,operate_type,data_subject,create_time,token_name,token_type) VALUES
    ('rule_7867','ALL','ALL_ALL_ALL_VOLUME_RANK','T','volume_rank','2023-06-20 00:27:47.836','ALL','token');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
('RelationTeam','ALL_ALL_ALL_VOLUME_RANK_LEGENDARY','ALL_ALL_ALL_VOLUME_RANK_LEGENDARY','SYSTEM','PUBLIC','GRADE','Token Legendary Trader','',NULL,'SQL','ALL_ALL_ALL_VOLUME_RANK_LEGENDARY','RESULT',NULL,999999,'2023-06-20 07:57:22.011','2023-06-20 07:57:22.011',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_RANK_ELITE','ALL_ALL_ALL_VOLUME_RANK_ELITE','SYSTEM','PUBLIC','GRADE','Token Elite Trader','',NULL,'SQL','ALL_ALL_ALL_VOLUME_RANK_ELITE','RESULT',NULL,999999,'2023-06-20 07:57:22.011','2023-06-20 07:57:22.011',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_RANK_HEAVY','ALL_ALL_ALL_VOLUME_RANK_HEAVY','SYSTEM','PUBLIC','GRADE','Token Heavy Trader','',NULL,'SQL','ALL_ALL_ALL_VOLUME_RANK_HEAVY','RESULT',NULL,999999,'2023-06-20 07:57:22.011','2023-06-20 07:57:22.011',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_VOLUME_RANK_MEDIUM','ALL_ALL_ALL_VOLUME_RANK_MEDIUM','SYSTEM','PUBLIC','GRADE','Token Medium Trader','',NULL,'SQL','ALL_ALL_ALL_VOLUME_RANK_MEDIUM','RESULT',NULL,999999,'2023-06-20 07:57:22.011','2023-06-20 07:57:22.011',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'DEFI',999,'WAITING');








