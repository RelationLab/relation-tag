drop table if exists dim_project_type;
create table dim_project_type
(
    project  varchar(100)
    ,type   varchar(100)
    ,label_type   varchar(100)
    ,label_name  varchar(100)
    ,content   varchar(100)
    ,operate_type   varchar(100)
    ,seq_flag varchar(100)
    ,data_subject varchar(100)
    ,etl_update_time timestamp
    ,token_name   varchar(100)
);
truncate table dim_project_type;
vacuum dim_project_type;

-----balance_grade  WEB3_RabbitHole_NFTRecipient_BALANCE_GRADE
insert
into
    dim_project_type (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name)
select
    web3_platform.platform project,
    web3_action.trade_type "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_GRADE' label_type,
    'T' operate_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name seq_flag,
    'balance_grade' data_subject,
    web3_platform.platform_name token_name
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
WHERE web3_action_platform.dim_type='1';
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
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_GRADE'  as "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_GRADE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    web3_platform.platform_name_alis||' NFT ' ||level_def.level_name||' Collector' "content",
    'SQL' rule_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'web3_balance_grade') level_def on
        (1 = 1)
WHERE web3_action_platform.dim_type='1';
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
    web3_platform.platform_name asset,
    ''  project,
    web3_action.trade_type trade_type,
    level_def.level  balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_GRADE_'|| level_def.level label_name,
    web3_platform.platform_name_alis||' NFT ' ||level_def.level_name||' Collector' "content",
    'web3' asset_type,
    'GRADE' label_category
from web3_action_platform
         inner join web3_platform on
    (web3_platform.platform = web3_action_platform.platform)
         inner join web3_action on
    (web3_action.trade_type = web3_action_platform.trade_type)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'web3_balance_grade') level_def on
    (1 = 1)
WHERE web3_action_platform.dim_type='1';


-----balance_rank  WEB3_RabbitHole_NFTRecipient_BALANCE_RANK
insert
into
    dim_project_type (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name)
select
    web3_platform.platform project,
    web3_action.trade_type "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_RANK' label_type,
    'T' operate_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name seq_flag,
    'balance_rank' data_subject,
    web3_platform.platform_name token_name
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
WHERE web3_action_platform.dim_type='1';
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
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_RANK'  as "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_RANK_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    web3_platform.platform_name_alis||' '||level_def.level_name||' NFT ' ||'Collector' "content",
    'SQL' rule_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'web3_balance_rank') level_def on
        (1 = 1)
WHERE web3_action_platform.dim_type='1';
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
    web3_platform.platform_name asset,
    ''  project,
    web3_action.trade_type trade_type,
    level_def.level  balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_RANK_'|| level_def.level label_name,
    web3_platform.platform_name_alis||' ' ||level_def.level_name||' NFT ' ||'Collector' "content",
    'web3' asset_type,
    'GRADE' label_category
from web3_action_platform
         inner join web3_platform on
    (web3_platform.platform = web3_action_platform.platform)
         inner join web3_action on
    (web3_action.trade_type = web3_action_platform.trade_type)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'web3_balance_rank') level_def on
    (1 = 1)
WHERE web3_action_platform.dim_type='1';

-----balance_top  WEB3_RabbitHole_NFTRecipient_BALANCE_TOP
insert
into
    dim_project_type (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name)
select
    web3_platform.platform project,
    web3_action.trade_type "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_TOP' label_type,
    'T' operate_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name seq_flag,
    'balance_top' data_subject,
    web3_platform.platform_name token_name
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
WHERE web3_action_platform.dim_type='1';
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
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_TOP'  as "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_TOP_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    web3_platform.platform_name_alis || ' ' || level_def.level_name || ' NFT'||' Collector' "content",
    'SQL' rule_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'web3_balance_top') level_def on
        (1 = 1)
WHERE web3_action_platform.dim_type='1';
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
    web3_platform.platform_name asset,
    ''  project,
    web3_action.trade_type trade_type,
    level_def.level  balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_BALANCE_TOP_'|| level_def.level label_name,
    web3_platform.platform_name_alis ||' '||level_def.level_name||' NFT'||' Collector' "content",
    'web3' asset_type,
    'GRADE' label_category
from web3_action_platform
         inner join web3_platform on
    (web3_platform.platform = web3_action_platform.platform)
         inner join web3_action on
    (web3_action.trade_type = web3_action_platform.trade_type)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'web3_balance_top') level_def on
    (1 = 1)
WHERE web3_action_platform.dim_type='1';

-----count  WEB3_RabbitHole_NFTRecipient_ACTIVITY
insert
into
    dim_project_type (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name)
select
    web3_platform.platform project,
    web3_action.trade_type "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_ACTIVITY' label_type,
    'T' operate_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name seq_flag,
    'count' data_subject,
    web3_platform.platform_name token_name
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
WHERE web3_action_platform.dim_type='1';
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
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_ACTIVITY'  as "type",
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_ACTIVITY_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    web3_platform.platform_name_alis||'  ' ||level_def.level_name "content",
    'SQL' rule_type,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform
        inner join web3_platform on
        (web3_platform.platform = web3_action_platform.platform)
        inner join web3_action on
        (web3_action.trade_type = web3_action_platform.trade_type)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'web3_count') level_def on
        (1 = 1)
WHERE web3_action_platform.dim_type='1';
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
    web3_platform.platform_name asset,
    ''  project,
    web3_action.trade_type trade_type,
    level_def.level  balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'WEB3_' ||web3_platform.platform_name || '_' || web3_action.trade_type_name || '_ACTIVITY_'|| level_def.level label_name,
    web3_platform.platform_name_alis||'  ' ||level_def.level_name "content",
    'web3' asset_type,
    'GRADE' label_category
from web3_action_platform
         inner join web3_platform on
    (web3_platform.platform = web3_action_platform.platform)
         inner join web3_action on
    (web3_action.trade_type = web3_action_platform.trade_type)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'web3_count') level_def on
    (1 = 1)
WHERE web3_action_platform.dim_type='1';
insert into tag_result(table_name,batch_date)  SELECT 'dim_project_type' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
