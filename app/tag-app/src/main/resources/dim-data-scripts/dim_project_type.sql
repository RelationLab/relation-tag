drop table if exists dim_project_type_temp;
create table dim_project_type_temp
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
    ,recent_code varchar(30)
);
truncate table dim_project_type_temp;
vacuum dim_project_type_temp;

-----balance_grade  WEB3_RabbitHole_NFTRecipient_BALANCE_GRADE
insert
into
    dim_project_type_temp (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name)
select distinct
    web3_platform_temp.platform project,
    web3_action_temp.trade_type "type",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_GRADE' label_type,
    'T' operate_type,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name seq_flag,
    'balance_grade' data_subject,
    web3_platform_temp.platform_name token_name
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
WHERE web3_action_platform_temp.dim_type='1';
insert
into
    public."label_temp" ("owner",
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
select distinct
    'RelationTeam' "owner",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_GRADE'  as "type",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_GRADE_' || level_def_temp.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    web3_platform_temp.platform_name_alis||' NFT ' ||level_def_temp.level_name||' Collector' "content",
    'SQL' rule_type,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'WEB3' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
        inner join (
        select
            *
        from
            level_def_temp
        where
                type = 'web3_balance_grade') level_def_temp on
        (1 = 1)
WHERE web3_action_platform_temp.dim_type='1';
insert
into
    public.combination_temp (asset,
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
                        label_category,
    recent_time_code)
select distinct
    CASE WHEN  web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3' ELSE web3_platform_temp.platform_name END asset,
    ''  project,
    web3_action_temp.trade_type trade_type,
    level_def_temp.level  balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_GRADE_'|| level_def_temp.level label_name,
    web3_platform_temp.platform_name_alis||' NFT ' ||level_def_temp.level_name||' Collector' "content",
    'web3' asset_type,
    'GRADE' label_category,
    'ALL' recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (
    select
        *
    from
        level_def_temp
    where
            type = 'web3_balance_grade') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type='1';


-----balance_rank  WEB3_RabbitHole_NFTRecipient_BALANCE_RANK
insert
into
    dim_project_type_temp (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name)
select distinct
    web3_platform_temp.platform project,
    web3_action_temp.trade_type "type",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_RANK' label_type,
    'T' operate_type,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name seq_flag,
    'balance_rank' data_subject,
    web3_platform_temp.platform_name token_name
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
WHERE web3_action_platform_temp.dim_type='1';
insert
into
    public."label_temp" ("owner",
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
select distinct
    'RelationTeam' "owner",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_RANK'  as "type",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_RANK_' || level_def_temp.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    web3_platform_temp.platform_name_alis||' '||level_def_temp.level_name||' NFT ' ||'Collector' "content",
    'SQL' rule_type,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'WEB3' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
        inner join (
        select
            *
        from
            level_def_temp
        where
                type = 'web3_balance_rank') level_def_temp on
        (1 = 1)
WHERE web3_action_platform_temp.dim_type='1';
insert
into
    public.combination_temp (asset,
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
                        label_category,
    recent_time_code)
select distinct
    CASE WHEN  web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3' ELSE web3_platform_temp.platform_name END asset,
    ''  project,
    web3_action_temp.trade_type trade_type,
    level_def_temp.level  balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_RANK_'|| level_def_temp.level label_name,
    web3_platform_temp.platform_name_alis||' ' ||level_def_temp.level_name||' NFT ' ||'Collector' "content",
    'web3' asset_type,
    'RANK' label_category,
    'ALL' recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (
    select
        *
    from
        level_def_temp
    where
            type = 'web3_balance_rank') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type='1';

-----balance_top  WEB3_RabbitHole_NFTRecipient_BALANCE_TOP
insert
into
    dim_project_type_temp (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name)
select distinct
    web3_platform_temp.platform project,
    web3_action_temp.trade_type "type",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_TOP' label_type,
    'T' operate_type,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name seq_flag,
    'balance_top' data_subject,
    web3_platform_temp.platform_name token_name
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
WHERE web3_action_platform_temp.dim_type='1';
insert
into
    public."label_temp" ("owner",
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
select distinct
    'RelationTeam' "owner",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_TOP'  as "type",
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_TOP_' || level_def_temp.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    web3_platform_temp.platform_name_alis || ' ' || level_def_temp.level_name || ' NFT'||' Collector' "content",
    'SQL' rule_type,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'WEB3' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
        inner join (
        select
            *
        from
            level_def_temp
        where
                type = 'web3_balance_top') level_def_temp on
        (1 = 1)
WHERE web3_action_platform_temp.dim_type='1';
insert
into
    public.combination_temp (asset,
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
                        label_category,
   recent_time_code)
select distinct
    CASE WHEN  web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3' ELSE web3_platform_temp.platform_name END asset,
    ''  project,
    web3_action_temp.trade_type trade_type,
    level_def_temp.level  balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_BALANCE_TOP_'|| level_def_temp.level label_name,
    web3_platform_temp.platform_name_alis ||' '||level_def_temp.level_name||' NFT'||' Collector' "content",
    'web3' asset_type,
    'TOP' label_category,
    'ALL' recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (
    select
        *
    from
        level_def_temp
    where
            type = 'web3_balance_top') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type='1';

-----count  WEB3_RabbitHole_NFTRecipient_ACTIVITY
insert
into
    dim_project_type_temp (project,
                      "type",
                      label_type,
                      operate_type,
                      seq_flag,
                      data_subject,
                      token_name,
                      recent_code)
select distinct
    web3_platform_temp.platform project,
    web3_action_temp.trade_type "type",
    recent_time_temp.recent_time_name||(case when recent_time_temp.recent_time_name<>'' then '_' else '' end) ||'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_ACTIVITY' label_type,
    'T' operate_type,
    recent_time_temp.recent_time_name||(case when recent_time_temp.recent_time_name<>'' then '_' else '' end) || 'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name seq_flag,
    'count' data_subject,
    web3_platform_temp.platform_name token_name,
    recent_time_temp.recent_time_code
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
        inner join recent_time_temp on(1=1) ;
insert
into
    public."label_temp" ("owner",
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
select distinct
    'RelationTeam' "owner",
    recent_time_temp.recent_time_name||(case when recent_time_temp.recent_time_name<>'' then '_' else '' end) ||'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_ACTIVITY'  as "type",
    recent_time_temp.recent_time_name||(case when recent_time_temp.recent_time_name<>'' then '_' else '' end) ||'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_ACTIVITY_' || level_def_temp.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    recent_time_temp.recent_time_content||(case when recent_time_temp.recent_time_content<>'' then ' ' else '' end) || web3_platform_temp.platform_name_alis||'  ' ||level_def_temp.level_name "content",
    'SQL' rule_type,
    recent_time_temp.recent_time_name||(case when recent_time_temp.recent_time_name<>'' then '_' else '' end) ||'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'WEB3' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    web3_action_platform_temp
        inner join web3_platform_temp on
        (web3_platform_temp.platform = web3_action_platform_temp.platform)
        inner join web3_action_temp on
        (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
        inner join (
        select
            *
        from
            level_def_temp
        where
                type = 'web3_count') level_def_temp on
        (1 = 1) inner join recent_time_temp on(1=1);
insert
into
    public.combination_temp (asset,
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
                        label_category,
                        recent_time_code)
select distinct
    CASE WHEN  web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3' ELSE web3_platform_temp.platform_name END asset,
    ''  project,
    web3_action_temp.trade_type trade_type,
    '' balance,
    '' volume,
    level_def_temp.level  activity,
    '' hold_time,
    now() created_at,
    recent_time_temp.recent_time_name||(case when recent_time_temp.recent_time_name<>'' then '_' else '' end) ||'WEB3_' ||web3_platform_temp.platform_name || '_' || web3_action_temp.trade_type_name || '_ACTIVITY_'|| level_def_temp.level label_name,
    recent_time_temp.recent_time_content||(case when recent_time_temp.recent_time_content<>'' then ' ' else '' end) ||web3_platform_temp.platform_name_alis||'  ' ||level_def_temp.level_name "content",
    'web3' asset_type,
    'GRADE' label_category,
    recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (
    select
        *
    from
        level_def_temp
    where
            type = 'web3_count') level_def_temp on
    (1 = 1) inner join recent_time_temp on(1=1);
insert into tag_result(table_name,batch_date)  SELECT 'dim_project_type' as table_name,'${batchDate}'  as batch_date;
