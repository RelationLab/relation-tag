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
select 'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as label_type,
       'T' operate_type,
       'balance_grade' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as "type",
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''  volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE_'|| level_def.level label_name,
    t.symbol||' '||level_def.level_name   "content",
    'token' asset_type,
    'GRADE' label_category
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

--------balance_grade ALL_ALL_ALL_BALANCE_GRADE
insert
into
    dim_rule_content (
    "token",
    label_type,
    operate_type,
    data_subject,
    token_name)
select
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_GRADE' label_type,
    'T' operate_type,
    'balance_grade' data_subject,
    'ALL' token_name;
insert
into
    public.label_test ("owner",
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
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_GRADE'  as "type",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'Token '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_BALANCE_GRADE'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'defi_balance_grade' ;
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL_NFT'  asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_GRADE_' || level_def.level  label_name,
    'Token '||level_def.level_name  "content",
    'nft' asset_type,
    'GRADE' label_category
from level_def where type = 'defi_balance_grade' ;



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
select 'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as label_type,
       'T' operate_type,
       'balance_rank' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as "type",
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        level_def.level balance,
        ''  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK'|| level_def.level label_name,
        t.symbol||' '||level_def.level_name   "content",
        'token' asset_type,
        'RANK' label_category
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


--------balance_rank ALL_ALL_ALL_BALANCE_RANK
insert
into
    dim_rule_content (
    "token",
    label_type,
    operate_type,
    data_subject,
    token_name)
select
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_RANK' label_type,
    'T' operate_type,
    'balance_rank' data_subject,
    'ALL' token_name;
insert
into
    public.label_test ("owner",
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
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_RANK'  as "type",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'Token '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_BALANCE_RANK'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'defi_balance_rank' ;
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL_TOKEN'  asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_RANK_' || level_def.level  label_name,
    'Token '||level_def.level_name  "content",
    'token' asset_type,
    'RANK' label_category
from level_def where type = 'defi_balance_rank' ;


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
select 'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as label_type,
       'T' operate_type,
       'balance_top' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as "type",
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        level_def.level balance,
        ''  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP_'|| level_def.level label_name,
        t.symbol||' '||level_def.level_name   "content",
        'token' asset_type,
        'TOP' label_category
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


--------balance_top ALL_ALL_ALL_BALANCE_TOP
insert
into
    dim_rule_content (
    "token",
    label_type,
    operate_type,
    data_subject,
    token_name)
select
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_TOP' label_type,
    'T' operate_type,
    'balance_top' data_subject,
    'ALL' token_name;
insert
into
    public.label_test ("owner",
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
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_TOP'  as "type",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'Token '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_BALANCE_TOP'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'defi_balance_top' ;
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL_TOKEN'  asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_TOP_' || level_def.level  label_name,
    'Token '||level_def.level_name  "content",
    'token' asset_type,
    'TOP' label_category
from level_def where type = 'defi_balance_top' ;


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
select 'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as label_type,
       'T' operate_type,
       'count' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as "type",
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        ''  volume,
        level_def.level activity,
        '' hold_time,
        now() created_at,
        'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY_'|| level_def.level label_name,
        t.symbol||' '||level_def.level_name   "content",
        'token' asset_type,
        'GRADE' label_category
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

--------count ALL_ALL_ALL_ACTIVITY
insert
into
    dim_rule_content (
    "token",
    label_type,
    operate_type,
    data_subject,
    token_name)
select
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_ACTIVITY' label_type,
    'T' operate_type,
    'count' data_subject,
    'ALL' token_name;
insert
into
    public.label_test ("owner",
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
    'ALL_' ||'ALL_' ||'ALL' ||  '_ACTIVITY'  as "type",
    'ALL_' ||'ALL_' ||'ALL' ||  '_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'Token '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_ACTIVITY'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'defi_count' ;
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL_TOKEN'  asset,
    '' project,
    '' trade_type,
    '' balance,
    ''    volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||'ALL_' ||'ALL' ||  '_ACTIVITY_' || level_def.level  label_name,
    'Token '||level_def.level_name  "content",
    'token' asset_type,
    'GRADE' label_category
from level_def where type = 'defi_count' ;

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
select upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as rule_code,
       t.address as token,
       upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as label_type,
       'T' operate_type,
       'time_grade' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as "type",
    upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        ''  volume,
       '' activity,
        level_def.level hold_time,
        now() created_at,
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE_'|| level_def.level  label_name,
        t.symbol||' '||level_def.level_name   "content",
        'token' asset_type,
        'GRADE' label_category
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
select upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as rule_code,
       t.address as token,
       upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as label_type,
       'T' operate_type,
       'time_special' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as "type",
    upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        ''  volume,
        '' activity,
        level_def.level hold_time,
        now() created_at,
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL_'|| level_def.level  label_name,
        t.symbol||' '||level_def.level_name   "content",
        'token' asset_type,
        'SPECIAL' label_category
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
select 'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as label_type,
       'T' operate_type,
       'volume_grade' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as "type",
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol|| (case when level_def.level='Million' or level_def.level='Billion' then ' '||level_def.level else '' end)||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        level_def.level  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE_'|| level_def.level label_name,
        t.symbol|| (case when level_def.level='Million' or level_def.level='Billion' then ' '||level_def.level else '' end)||' '||level_def.level_name    "content",
        'token' asset_type,
        'GRADE' label_category
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

--------volume_grade ALL_ALL_ALL_VOLUME_GRADE
insert
into
    dim_rule_content (
    "token",
    label_type,
    operate_type,
    data_subject,
    token_name)
select
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_GRADE' label_type,
    'T' operate_type,
    'volume_grade' data_subject,
    'ALL' token_name;
insert
into
    public.label_test ("owner",
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
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_GRADE'  as "type",
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'Token '||(case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end)||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_VOLUME_GRADE'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'defi_volume_grade' ;
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL_TOKEN'  asset,
    '' project,
    '' trade_type,
    '' balance,
    level_def.level     volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_GRADE_' || level_def.level  label_name,
    'Token '||(case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end)||level_def.level_name  "content",
    'token' asset_type,
    'GRADE' label_category
from level_def where type = 'defi_volume_grade' ;

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
select 'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as rule_code,
       t.address as token,
       'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as label_type,
       'T' operate_type,
       'volume_rank' data_subject,
       now() as create_time,
       t.symbol as token_name,
       'token' as token_type
from (select * from top_token_1000 where holders>=100 and removed<>'true') t;

insert
into
    public.label_test ("owner",
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
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as "type",
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' rule_group,
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
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
        upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        level_def.level   volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||upper(t.symbol)||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK_'|| level_def.level label_name,
        t.symbol||' '||level_def.level_name    "content",
        'token' asset_type,
        'RANK' label_category
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


--------volume_rank ALL_ALL_ALL_VOLUME_RANK
insert
into
    dim_rule_content (
    "token",
    label_type,
    operate_type,
    data_subject,
    token_name)
select
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_RANK' label_type,
    'T' operate_type,
    'volume_rank' data_subject,
    'ALL' token_name;
insert
into
    public.label_test ("owner",
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
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_RANK'  as "type",
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'Token '||level_def.level_name||' Trader' "content",
    'SQL' rule_type,
    'ALL' ||  '_VOLUME_RANK'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'defi_volume_rank' ;
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL_TOKEN'  asset,
    '' project,
    '' trade_type,
    '' balance,
    level_def.level     volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_RANK_' || level_def.level  label_name,
    'Token '||level_def.level_name||' Trader' "content",
    'token' asset_type,
    'RANK' label_category
from level_def where type = 'defi_volume_rank' ;





