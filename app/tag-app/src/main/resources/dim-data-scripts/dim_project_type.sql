drop table if exists dim_project_type_temp;
create table dim_project_type_temp
(
    project         varchar(100),
    type            varchar(100),
    label_type      varchar(100),
    label_name      varchar(100),
    content         varchar(100),
    operate_type    varchar(100),
    seq_flag        varchar(100),
    data_subject    varchar(100),
    etl_update_time timestamp,
    token_name      varchar(100),
    recent_code     varchar(30)
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    distributed by
(
    label_type
);
truncate table dim_project_type_temp;
vacuum
dim_project_type_temp;

-----balance_grade  WEB3_RabbitHole_NFTRecipient_BALANCE_GRADE
insert
into dim_project_type_temp (project,
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            token_name)
select distinct web3_platform_temp.platform                                   project,
                web3_action_temp.trade_type                                   "type",
                --平台+资产+交易类型
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bg' label_type,
                'T'                                                           operate_type,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bg' seq_flag,
                'balance_grade'                                               data_subject,
                web3_platform_temp.platform_name                              token_name
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
WHERE web3_action_platform_temp.dim_type = '1';
insert
into public."label_temp" ("owner",
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
                          sync_es_status,
                          one_wired_type,
                          two_wired_type,time_type)
select distinct 'RelationTeam'                                                                          "owner",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bg'                        as "type",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bg' || level_def_temp.code as "name",
                'SYSTEM'                                                                                "source",
                'PUBLIC'                                                                                visible_type,
                'TOTAL_PART'                                                                            strategy,

                web3_platform_temp.platform_name_alis ||
                (case when web3_platform_temp.platform_name_alis = 'Web3' THEN '' ELSE ' ' end) ||
                (case
                     when web3_action_temp.trade_type = 'write' then ''
                     else 'NFT ' end) ||
                level_def_temp.level_name ||
                (case
                     when web3_action_temp.trade_type = 'write' then ' ' || web3_action_temp.trade_type_alis
                     else ' Collector' end)                                                             "content",
                'SQL'                                                                                   rule_type,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bg'                           rule_group,
                'RESULT'                                                                                value_type,
                999999                                                                                  run_order,
                now()                                                                                   created_at,
                0                                                                                       refresh_time,
                'WEB3'                                                                                  wired_type,
                999                                                                                     label_order,
                'WAITING'                                                                               sync_es_status,
                '{"pf": 1, "act": 1, "ast": 0}'                                                      as one_wired_type,
                'b'                                                                                  as two_wired_type,
                 'l'                     as time_type
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_balance_grade') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type = '1';
insert
into public.combination_temp (asset,
                              project,
                              trade_type,
                              balance,
                              volume,
                              activity,
                              hold_time,
                              created_at,
                              label_name,
                              asset_type,
                              label_category,
                              recent_time_code)
select distinct CASE
                    WHEN web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3'
                    ELSE web3_platform_temp.platform_name END                                        asset,
                ''                                                                                   project,
                web3_action_temp.trade_type                                                          trade_type,
                level_def_temp.level                                                                 balance,
                ''                                                                                   volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bg' || level_def_temp.code label_name,
                'web3'                                                                               asset_type,
                'GRADE'                                                                              label_category,
                'ALL'                                                                                recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_balance_grade') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type = '1';


-----balance_rank  WEB3_RabbitHole_NFTRecipient_BALANCE_RANK
insert
into dim_project_type_temp (project,
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            token_name)
select distinct web3_platform_temp.platform                                   project,
                web3_action_temp.trade_type                                   "type",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'br' label_type,
                'T'                                                           operate_type,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'br' seq_flag,
                'balance_rank'                                                data_subject,
                web3_platform_temp.platform_name                              token_name
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
WHERE web3_action_platform_temp.dim_type = '1';
insert
into public."label_temp" ("owner",
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
                          sync_es_status,
                          one_wired_type,
                          two_wired_type,time_type)
select distinct 'RelationTeam'                                                                          "owner",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'br'                        as "type",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'br' || level_def_temp.code as "name",
                'SYSTEM'                                                                                "source",
                'PUBLIC'                                                                                visible_type,
                'TOTAL_PART'                                                                            strategy,
                (case
                     when web3_platform_temp.platform_name_alis = 'Web3' THEN ''
                     ELSE web3_platform_temp.platform_name_alis || ' ' END) ||
                level_def_temp.level_name || ' ' ||
                (case
                     when web3_platform_temp.platform_name_alis = 'Web3' THEN web3_platform_temp.platform_name_alis
                     ELSE '' END) ||
                (case
                     when web3_action_temp.trade_type = 'write' then ''
                     else 'NFT ' end) ||
                (case
                     when web3_action_temp.trade_type = 'write' then ' ' || web3_action_temp.trade_type_alis
                     else ' Collector' end)                                                             "content",
                'SQL'                                                                                   rule_type,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'br'                           rule_group,
                'RESULT'                                                                                value_type,
                999999                                                                                  run_order,
                now()                                                                                   created_at,
                0                                                                                       refresh_time,
                'WEB3'                                                                                  wired_type,
                999                                                                                     label_order,
                'WAITING'                                                                               sync_es_status,
                '{"pf": 1, "act": 1, "ast": 0}'                                                      as one_wired_type,
                'b'                                                                                  as two_wired_type,
                 'l'                     as time_type
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_balance_rank') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type = '1';
insert
into public.combination_temp (asset,
                              project,
                              trade_type,
                              balance,
                              volume,
                              activity,
                              hold_time,
                              created_at,
                              label_name,
                              asset_type,
                              label_category,
                              recent_time_code)
select distinct CASE
                    WHEN web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3'
                    ELSE web3_platform_temp.platform_name END                                        asset,
                ''                                                                                   project,
                web3_action_temp.trade_type                                                          trade_type,
                level_def_temp.level                                                                 balance,
                ''                                                                                   volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'br' || level_def_temp.code label_name,
                'web3'                                                                               asset_type,
                'RANK'                                                                               label_category,
                'ALL'                                                                                recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_balance_rank') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type = '1';

-----balance_top  WEB3_RabbitHole_NFTRecipient_BALANCE_TOP
insert
into dim_project_type_temp (project,
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            token_name)
select distinct web3_platform_temp.platform                                   project,
                web3_action_temp.trade_type                                   "type",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bt' label_type,
                'T'                                                           operate_type,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bt' seq_flag,
                'balance_top'                                                 data_subject,
                web3_platform_temp.platform_name                              token_name
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
WHERE web3_action_platform_temp.dim_type = '1'
  and web3_action_temp.trade_type <> 'write';
insert
into public."label_temp" ("owner",
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
                          sync_es_status,
                          one_wired_type,
                          two_wired_type,time_type)
select distinct 'RelationTeam'                                                                          "owner",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bt'                        as "type",
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bt' || level_def_temp.code as "name",
                'SYSTEM'                                                                                "source",
                'PUBLIC'                                                                                visible_type,
                'TOTAL_PART'                                                                            strategy,
                web3_platform_temp.platform_name_alis ||
                (case when web3_platform_temp.platform_name_alis = 'Web3' THEN '' ELSE ' ' end)
                    || 'NFT ' || level_def_temp.level_name                                              "content",
                'SQL'                                                                                   rule_type,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bt'                           rule_group,
                'RESULT'                                                                                value_type,
                999999                                                                                  run_order,
                now()                                                                                   created_at,
                0                                                                                       refresh_time,
                'WEB3'                                                                                  wired_type,
                999                                                                                     label_order,
                'WAITING'                                                                               sync_es_status,
                '{"pf": 1, "act": 1, "ast": 0}'                                                      as one_wired_type,
                'b'                                                                                  as two_wired_type,
                'l'                     as time_type
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_balance_top') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type = '1'
  and web3_action_temp.trade_type <> 'write';

insert
into public.combination_temp (asset,
                              project,
                              trade_type,
                              balance,
                              volume,
                              activity,
                              hold_time,
                              created_at,
                              label_name,
                              asset_type,
                              label_category,
                              recent_time_code)
select distinct CASE
                    WHEN web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3'
                    ELSE web3_platform_temp.platform_name END                                        asset,
                ''                                                                                   project,
                web3_action_temp.trade_type                                                          trade_type,
                level_def_temp.level                                                                 balance,
                ''                                                                                   volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                'w' || web3_platform_temp.id || web3_action_temp.code || 'bt' || level_def_temp.code label_name,
                'web3'                                                                               asset_type,
                'TOP'                                                                                label_category,
                'ALL'                                                                                recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_balance_top') level_def_temp on
    (1 = 1)
WHERE web3_action_platform_temp.dim_type = '1'
  and web3_action_temp.trade_type <> 'write';

-----count  WEB3_RabbitHole_NFTRecipient_ACTIVITY
insert
into dim_project_type_temp (project,
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            token_name,
                            recent_code)
select distinct web3_platform_temp.platform                                                            project,
                web3_action_temp.trade_type                                                            "type",
                recent_time_temp.code || 'w' || web3_platform_temp.id || web3_action_temp.code || 'cg' label_type,
                'T'                                                                                    operate_type,
                recent_time_temp.code || 'w' || web3_platform_temp.id || web3_action_temp.code || 'cg' seq_flag,
                'count'                                                                                data_subject,
                web3_platform_temp.platform_name                                                       token_name,
                recent_time_temp.recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join recent_time_temp on (1 = 1);
insert
into public."label_temp" ("owner",
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
                          sync_es_status,
                          one_wired_type,
                          two_wired_type,time_type)
select distinct 'RelationTeam'                                                                            "owner",
                recent_time_temp.code || 'w' || web3_platform_temp.id || web3_action_temp.code || 'cg' as "type",
                recent_time_temp.code || 'w' || web3_platform_temp.id || web3_action_temp.code || 'cg' ||
                level_def_temp.code                                                                    as "name",
                'SYSTEM'                                                                                  "source",
                'PUBLIC'                                                                                  visible_type,
                'TOTAL_PART'                                                                              strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                web3_platform_temp.platform_name_alis || '  ' || level_def_temp.level_name ||
                case
                    when web3_action_temp.trade_type = 'ALL' then ''
                    else ' ' || web3_action_temp.trade_type_alis
                    end
                                                                                                          "content",
                'SQL'                                                                                     rule_type,
                recent_time_temp.code || 'w' || web3_platform_temp.id || web3_action_temp.code || 'cg'    rule_group,
                'RESULT'                                                                                  value_type,
                999999                                                                                    run_order,
                now()                                                                                     created_at,
                0                                                                                         refresh_time,
                'WEB3'                                                                                    wired_type,
                999                                                                                       label_order,
                'WAITING'                                                                                 sync_es_status,
                '{"pf": 1, "act": 1, "ast": 0}'                                                        as one_wired_type,
                'c'                                                                                    as two_wired_type,
                recent_time_temp.code_revent || 'l'                     as time_type
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1);
insert
into public.combination_temp (asset,
                              project,
                              trade_type,
                              balance,
                              volume,
                              activity,
                              hold_time,
                              created_at,
                              label_name,
                              asset_type,
                              label_category,
                              recent_time_code)
select distinct CASE
                    WHEN web3_platform_temp.platform_name = 'ALL' THEN 'ALL_WEB3'
                    ELSE web3_platform_temp.platform_name END asset,
                ''                                            project,
                web3_action_temp.trade_type                   trade_type,
                ''                                            balance,
                ''                                            volume,
                level_def_temp.level                          activity,
                ''                                            hold_time,
                now()                                         created_at,
                recent_time_temp.code || 'w' || web3_platform_temp.id || web3_action_temp.code || 'cg' ||
                level_def_temp.code                           label_name,
                'web3'                                        asset_type,
                'GRADE'                                       label_category,
                recent_time_code
from web3_action_platform_temp
         inner join web3_platform_temp on
    (web3_platform_temp.platform = web3_action_platform_temp.platform)
         inner join web3_action_temp on
    (web3_action_temp.trade_type = web3_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'web3_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1);
insert into tag_result(table_name, batch_date)
SELECT 'dim_project_type' as table_name, '${batchDate}' as batch_date;
