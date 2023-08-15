drop table if exists dim_rule_content_temp;
create table dim_rule_content_temp
(
    token        varchar(300),
    label_type   varchar(300),
    operate_type varchar(300),
    data_subject varchar(20),
    create_time  timestamp,
    token_name   varchar(100),
    token_type   varchar(100),
    recent_code  varchar(30)
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    distributed by
(
    label_type
);
truncate table dim_rule_content_temp;
vacuum
dim_rule_content_temp;
drop table if exists dim_rank_token_temp;
create table dim_rank_token_temp
(
    token_id   varchar(512),
    asset_type varchar(10)
);
truncate table dim_rank_token_temp;
vacuum
dim_rank_token_temp;
----------------------------dim_lp.sql-----------------------------------------------
-----balance_grade  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_GRADE
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type)

select distinct lpt.pool                          as token,
                --平台+资产+交易类型
                '' || 'l' || ipt.id || '' || 'bg' as label_type,
                'T'                               as operate_type,
                'balance_grade'                      data_subject,
                lpt.symbol_wired                     token_name,
                'lp'                              as token_type
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                 "owner",
                --平台+资产+交易类型
                '' || 'l' || ipt.id || '' || 'bg'                        as                    "type",
                --平台+资产+交易类型
                '' || 'l' || ipt.id || '' || 'bg' || level_def_temp.code as                    "name",
                'SYSTEM'                                                                       "source",
                'PUBLIC'                                                                       visible_type,
                'TOTAL_PART'                                                                   strategy,
                lpt.factory_content || ' ' || symbol_wired || ' ' || level_def_temp.level_name "content",
                'SQL'                                                                          rule_type,
                '' || 'l' || ipt.id || '' || 'bg'                                              rule_group,
                'RESULT'                                                                       value_type,
                999999                                                                         run_order,
                now()                                                                          created_at,
                0                                                                              refresh_time,
                'DEFI'                                                                         wired_type,
                999                                                                            label_order,
                'WAITING'                                                                      sync_es_status
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_grade') level_def_temp on
    (1 = 1);
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
select distinct (lpt.symbol1 || '/' || lpt.symbol2) || '(' || SUBSTRING(lpt.pool, 1, 8) || ')' asset,
                lpt.factory_type                                                               project,
                ''                                                                             trade_type,
                level_def_temp.level                                                           balance,
                ''                                                                             volume,
                ''                                                                             activity,
                ''                                                                             hold_time,
                now()                                                                          created_at,
                '' || 'l' || ipt.id || '' || 'bg' || level_def_temp.code                       label_name,
                'token'                                                                        asset_type,
                'GRADE'                                                                        label_category,
                'ALL'                                                                          recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_grade') level_def_temp on
    (1 = 1);


-----balance_rank  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_RANK
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type)

select distinct lpt.pool                          as token,
                '' || 'l' || ipt.id || '' || 'br' as label_type,
                'T'                               as operate_type,
                'balance_rank'                       data_subject,
                lpt.symbol_wired                     token_name,
                'lp'                              as token_type
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                 "owner",
                '' || 'l' || ipt.id || '' || 'br'                                              "type",
                '' || 'l' || ipt.id || '' || 'br' || level_def_temp.code as                    "name",
                'SYSTEM'                                                                       "source",
                'PUBLIC'                                                                       visible_type,
                'TOTAL_PART'                                                                   strategy,
                lpt.factory_content || ' ' || symbol_wired || ' ' || level_def_temp.level_name "content",
                'SQL'                                                                          rule_type,
                '' || 'l' || ipt.id || '' || 'br'                                              rule_group,
                'RESULT'                                                                       value_type,
                999999                                                                         run_order,
                now()                                                                          created_at,
                0                                                                              refresh_time,
                'DEFI'                                                                         wired_type,
                999                                                                            label_order,
                'WAITING'                                                                      sync_es_status
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_rank') level_def_temp on
    (1 = 1);
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
select distinct (lpt.symbol1 || '/' || lpt.symbol2) || '(' || SUBSTRING(lpt.pool, 1, 8) || ')' asset,
                lpt.factory_type                                                               project,
                ''                                                                             trade_type,
                level_def_temp.level                                                           balance,
                ''                                                                             volume,
                ''                                                                             activity,
                ''                                                                             hold_time,
                now()                                                                          created_at,
                '' || 'l' || ipt.id || '' || 'br' || level_def_temp.code                       label_name,
                'token'                                                                        asset_type,
                'RANK'                                                                         label_category,
                'ALL'                                                                          recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_rank') level_def_temp on
    (1 = 1);

-----balance_top  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_TOP
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name, token_type)

select distinct lpt.pool                          as token,
                '' || 'l' || ipt.id || '' || 'bt' as label_type,
                'T'                               as operate_type,
                'balance_top'                        data_subject,
                lpt.symbol_wired                     token_name,
                'lp'                              as token_type
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                 "owner",
                '' || 'l' || ipt.id || '' || 'bt'                                              "type",
                '' || 'l' || ipt.id || '' || 'bt' || level_def_temp.code                       "name",
                'SYSTEM'                                                                       "source",
                'PUBLIC'                                                                       visible_type,
                'TOTAL_PART'                                                                   strategy,
                lpt.factory_content || ' ' || symbol_wired || ' ' || level_def_temp.level_name "content",
                'SQL'                                                                          rule_type,
                '' || 'l' || ipt.id || '' || 'bt'                                              rule_group,
                'RESULT'                                                                       value_type,
                999999                                                                         run_order,
                now()                                                                          created_at,
                0                                                                              refresh_time,
                'DEFI'                                                                         wired_type,
                999                                                                            label_order,
                'WAITING'                                                                      sync_es_status
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_top') level_def_temp on
    (1 = 1);
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
select distinct (lpt.symbol1 || '/' || lpt.symbol2) || '(' || SUBSTRING(lpt.pool, 1, 8) || ')' asset,
                lpt.factory_type                                                               project,
                ''                                                                             trade_type,
                level_def_temp.level                                                           balance,
                ''                                                                             volume,
                ''                                                                             activity,
                ''                                                                             hold_time,
                now()                                                                          created_at,
                '' || 'l' || ipt.id || '' || 'bt' || level_def_temp.code                       label_name,
                'token'                                                                        asset_type,
                'TOP'                                                                          label_category,
                'ALL'                                                                          recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_top') level_def_temp on
    (1 = 1);


-----count  Uniswap_v3_UNI/WETH_0x1d42_ACTIVITY
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type,
                            recent_code)

select distinct lpt.pool                                                   as token,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'cg' as label_type,
                'T'                                                        as operate_type,
                'count'                                                       data_subject,
                lpt.symbol_wired                                              token_name,
                'lp'                                                       as token_type,
                recent_time_temp.recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join recent_time_temp on (1 = 1)
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                    as "owner",
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'cg'                        as "type",
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                                          as "source",
                'PUBLIC'                                                                          as visible_type,
                'TOTAL_PART'                                                                      as strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || lpt.factory_content ||
                ' ' ||
                symbol_wired || ' ' || level_def_temp.level_name                                  as "content",
                'SQL'                                                                             as rule_type,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'cg'                        as rule_group,
                'RESULT'                                                                          as value_type,
                999999                                                                            as run_order,
                now()                                                                             as created_at,
                0                                                                                 as refresh_time,
                'DEFI'                                                                            as wired_type,
                999                                                                               as label_order,
                'WAITING'                                                                         as sync_es_status
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join recent_time_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1);
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
select distinct (lpt.symbol1 || '/' || lpt.symbol2) || '(' || SUBSTRING(lpt.pool, 1, 8) || ')'    asset,
                lpt.factory_type                                                                  project,
                ''                                                                                trade_type,
                ''                                                                                balance,
                ''                                                                                volume,
                level_def_temp.level                                                              activity,
                ''                                                                                hold_time,
                now()                                                                             created_at,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'cg' || level_def_temp.code label_name,
                'token'                                                                           asset_type,
                'GRADE'                                                                           label_category,
                recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join recent_time_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1);

-----volume_grade  Uniswap_v3_UNI/WETH_0x1d42_VOLUME_GRADE
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type,
                            recent_code)

select distinct lpt.pool                                                   as token,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vg' as label_type,
                'T'                                                        as operate_type,
                'volume_grade'                                             as data_subject,
                lpt.symbol_wired                                           as token_name,
                'lp'                                                       as token_type,
                recent_time_temp.recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                       "owner",
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vg'                        as "type",
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vg' || level_def_temp.code as "name",
                'SYSTEM'                                                                             "source",
                'PUBLIC'                                                                             visible_type,
                'TOTAL_PART'                                                                         strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || lpt.factory_content ||
                ' ' ||
                symbol_wired || ' ' || (case
                                            when level_def_temp.level = 'Million' or level_def_temp.level = 'Billion'
                                                then level_def_temp.level || ' '
                                            else '' end) || level_def_temp.level_name                "content",
                'SQL'                                                                                rule_type,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vg'                           rule_group,
                'RESULT'                                                                             value_type,
                999999                                                                               run_order,
                now()                                                                                created_at,
                0                                                                                    refresh_time,
                'DEFI'                                                                               wired_type,
                999                                                                                  label_order,
                'WAITING'                                                                            sync_es_status
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
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
select distinct (lpt.symbol1 || '/' || lpt.symbol2) || '(' || SUBSTRING(lpt.pool, 1, 8) || ')'    asset,
                lpt.factory_type                                                                  project,
                ''                                                                                trade_type,
                ''                                                                                balance,
                level_def_temp.level                                                              volume,
                ''                                                                                activity,
                ''                                                                                hold_time,
                now()                                                                             created_at,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vg' || level_def_temp.code label_name,
                'token'                                                                           asset_type,
                'GRADE'                                                                           label_category,
                recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1);

-----volume_rank  Uniswap_v3_UNI/WETH_0x1d42_VOLUME_RANK
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type,
                            recent_code)

select distinct lpt.pool                                                                          as token,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vr' || level_def_temp.code as label_type,
                'T'                                                                               as operate_type,
                'volume_rank'                                                                        data_subject,
                lpt.symbol_wired                                                                     token_name,
                'lp'                                                                              as token_type,
                recent_time_temp.recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                           "owner",
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vr'                        as     "type",
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vr' || level_def_temp.code as     "name",
                'SYSTEM'                                                                                 "source",
                'PUBLIC'                                                                                 visible_type,
                'TOTAL_PART'                                                                             strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || lpt.factory_content ||
                ' ' ||
                symbol_wired || ' ' || (case
                                            when level_def_temp.level = 'Million' or level_def_temp.level = 'Billion'
                                                then level_def_temp.level || ' '
                                            else '' end) || level_def_temp.level_name || ' ' || 'Trader' "content",
                'SQL'                                                                                    rule_type,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vr'                               rule_group,
                'RESULT'                                                                                 value_type,
                999999                                                                                   run_order,
                now()                                                                                    created_at,
                0                                                                                        refresh_time,
                'DEFI'                                                                                   wired_type,
                999                                                                                      label_order,
                'WAITING'                                                                                sync_es_status
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
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
select distinct (lpt.symbol1 || '/' || lpt.symbol2) || '(' || SUBSTRING(lpt.pool, 1, 8) || ')'    asset,
                lpt.factory_type                                                                  project,
                ''                                                                                trade_type,
                ''                                                                                balance,
                level_def_temp.level                                                              volume,
                ''                                                                                activity,
                ''                                                                                hold_time,
                now()                                                                             created_at,
                recent_time_temp.code || '' || 'l' || ipt.id || '' || 'vr' || level_def_temp.code label_name,
                'token'                                                                           asset_type,
                'RANK'                                                                            label_category,
                'ALL'                                                                             recent_time_code
from (select wlp.id,
             wlp.name,
             wlp.symbol_wired,
             wlp.address               as pool,
             wlp.factory,
             wlp.factory_type,
             wlp.factory_content,
             wlp.pool_id,
             wlp.symbols[1]            as symbol1,
             wlp.symbols[2]            as symbol2,
             wlp.type,
             wlp.tokens,
             wlp.decimals,
             wlp.price,
             wlp.tvl,
             wlp.fee                   as fee,
             SUBSTR(wlp.address, 1, 6) as poolPrefix,
             wlp.total_supply,
             wslp.factory              AS stakePool,
             wslp.factory_type         as stakeRouter
      from white_list_lp_temp wlp
               left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
      where wlp.tvl > 1000000
        and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1);

----------------------------------------dim_token.sql------------------------------------------
--------------balance_grade  ALL_DAI(0x6b1754)_ALL_BALANCE_GRADE
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type)
select distinct t.address                       as token,
                '' || 't' || t.id || '' || 'bg' as label_type,
                'T'                                operate_type,
                'balance_grade'                    data_subject,
                now()                           as create_time,
                t.symbol                        as token_name,
                'token'                         as token_type
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t;

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
                          sync_es_status)
select distinct 'RelationTeam'                                            "owner",
                '' || 't' || t.id || '' || 'bg'                        as "type",
                '' || 't' || t.id || '' || 'bg' || level_def_temp.code as "name",
                'SYSTEM'                                                  "source",
                'PUBLIC'                                                  visible_type,
                'TOTAL_PART'                                              strategy,
                t.symbol || ' ' || level_def_temp.level_name              "content",
                'SQL'                                                     rule_type,
                '' || 't' || t.id || '' || 'bg'                           rule_group,
                'RESULT'                                                  value_type,
                999999                                                    run_order,
                now()                                                     created_at,
                0                                                         refresh_time,
                'DEFI'                                                    wired_type,
                999                                                       label_order,
                'WAITING'                                                 sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_grade') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'   asset,
                ''                                                     project,
                ''                                                     trade_type,
                level_def_temp.level                                   balance,
                ''                                                     volume,
                ''                                                     activity,
                ''                                                     hold_time,
                now()                                                  created_at,
                '' || 't' || t.id || '' || 'bg' || level_def_temp.code label_name,
                'token'                                                asset_type,
                'GRADE'                                                label_category,
                'ALL'                                                  recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_grade') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';

--------balance_grade ALL_ALL_ALL_BALANCE_GRADE
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type)
select distinct 'ALL'                  "token",
                '' || '' || '' || 'bg' label_type,
                'T'                    operate_type,
                'balance_grade'        data_subject,
                'ALL'                  token_name,
                'token' as             token_type;
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
                          sync_es_status)
select distinct 'RelationTeam'                                   "owner",
                '' || '' || '' || 'bg'                        as "type",
                '' || '' || '' || 'bg' || level_def_temp.code as "name",
                'SYSTEM'                                         "source",
                'PUBLIC'                                         visible_type,
                'TOTAL_PART'                                     strategy,
                'Token ' || level_def_temp.level_name            "content",
                'SQL'                                            rule_type,
                '' || '' || '' || 'bg'                           rule_group,
                'RESULT'                                         value_type,
                999999                                           run_order,
                now()                                            created_at,
                0                                                refresh_time,
                'DEFI'                                           wired_type,
                999                                              label_order,
                'WAITING'                                        sync_es_status
from level_def_temp
where type = 'defi_balance_grade';
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
select distinct 'ALL_TOKEN'                                   asset,
                ''                                            project,
                ''                                            trade_type,
                level_def_temp.level                          balance,
                ''                                            volume,
                ''                                            activity,
                ''                                            hold_time,
                now()                                         created_at,
                '' || '' || '' || 'bg' || level_def_temp.code label_name,
                'token'                                       asset_type,
                'GRADE'                                       label_category,
                'ALL'                                         recent_time_code
from level_def_temp
where type = 'defi_balance_grade';


--------------balance_rank  ALL_DAI(0x6b1754)_ALL_BALANCE_RANK
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type)
select distinct t.address                       as token,
                '' || 't' || t.id || '' || 'br' as label_type,
                'T'                                operate_type,
                'balance_rank'                     data_subject,
                now()                           as create_time,
                t.symbol                        as token_name,
                'token'                         as token_type
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t;

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
                          sync_es_status)
select distinct 'RelationTeam'                                            "owner",
                '' || 't' || t.id || '' || 'br'                        as "type",
                '' || 't' || t.id || '' || 'br' || level_def_temp.code as "name",
                'SYSTEM'                                                  "source",
                'PUBLIC'                                                  visible_type,
                'TOTAL_PART'                                              strategy,
                t.symbol || ' ' || level_def_temp.level_name              "content",
                'SQL'                                                     rule_type,
                '' || 't' || t.id || '' || 'br'                           rule_group,
                'RESULT'                                                  value_type,
                999999                                                    run_order,
                now()                                                     created_at,
                0                                                         refresh_time,
                'DEFI'                                                    wired_type,
                999                                                       label_order,
                'WAITING'                                                 sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_rank') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'   asset,
                ''                                                     project,
                ''                                                     trade_type,
                level_def_temp.level                                   balance,
                ''                                                     volume,
                ''                                                     activity,
                ''                                                     hold_time,
                now()                                                  created_at,
                '' || 't' || t.id || '' || 'br' || level_def_temp.code label_name,
                'token'                                                asset_type,
                'RANK'                                                 label_category,
                'ALL'                                                  recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_rank') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';


--------balance_rank ALL_ALL_ALL_BALANCE_RANK
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name, token_type)
select distinct 'ALL'                  "token",
                '' || '' || '' || 'br' label_type,
                'T'                    operate_type,
                'balance_rank'         data_subject,
                'ALL'                  token_name,
                'token' as             token_type;
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
                          sync_es_status)
select distinct 'RelationTeam'                                   "owner",
                '' || '' || '' || 'br'                        as "type",
                '' || '' || '' || 'br' || level_def_temp.code as "name",
                'SYSTEM'                                         "source",
                'PUBLIC'                                         visible_type,
                'TOTAL_PART'                                     strategy,
                'Token ' || level_def_temp.level_name            "content",
                'SQL'                                            rule_type,
                '' || '' || '' || 'br'                           rule_group,
                'RESULT'                                         value_type,
                999999                                           run_order,
                now()                                            created_at,
                0                                                refresh_time,
                'DEFI'                                           wired_type,
                999                                              label_order,
                'WAITING'                                        sync_es_status
from level_def_temp
where type = 'defi_balance_rank';
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
select distinct 'ALL_TOKEN'                                   asset,
                ''                                            project,
                ''                                            trade_type,
                level_def_temp.level                          balance,
                ''                                            volume,
                ''                                            activity,
                ''                                            hold_time,
                now()                                         created_at,
                '' || '' || '' || 'br' || level_def_temp.code label_name,
                'token'                                       asset_type,
                'RANK'                                        label_category,
                'ALL'                                         recent_time_code
from level_def_temp
where type = 'defi_balance_rank';


--------------balance_top  ALL_DAI(0x6b1754)_ALL_BALANCE_TOP
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type)
select distinct t.address                       as token,
                '' || 't' || t.id || '' || 'bt' as label_type,
                'T'                                operate_type,
                'balance_top'                      data_subject,
                now()                           as create_time,
                t.symbol                        as token_name,
                'token'                         as token_type
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t;

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
                          sync_es_status)
select distinct 'RelationTeam'                                            "owner",
                '' || 't' || t.id || '' || 'bt'                        as "type",
                '' || 't' || t.id || '' || 'bt' || level_def_temp.code as "name",
                'SYSTEM'                                                  "source",
                'PUBLIC'                                                  visible_type,
                'TOTAL_PART'                                              strategy,
                t.symbol || ' ' || level_def_temp.level_name              "content",
                'SQL'                                                     rule_type,
                '' || 't' || t.id || '' || 'bt' || level_def_temp.code    rule_group,
                'RESULT'                                                  value_type,
                999999                                                    run_order,
                now()                                                     created_at,
                0                                                         refresh_time,
                'DEFI'                                                    wired_type,
                999                                                       label_order,
                'WAITING'                                                 sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_top') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'   asset,
                ''                                                     project,
                ''                                                     trade_type,
                level_def_temp.level                                   balance,
                ''                                                     volume,
                ''                                                     activity,
                ''                                                     hold_time,
                now()                                                  created_at,
                '' || 't' || t.id || '' || 'bt' || level_def_temp.code label_name,
                'token'                                                asset_type,
                'TOP'                                                  label_category,
                'ALL'                                                  recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_balance_top') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';


--------balance_top ALL_ALL_ALL_BALANCE_TOP
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name, token_type)
select distinct 'ALL'                  "token",
                '' || '' || '' || 'bt' label_type,
                'T'                    operate_type,
                'balance_top'          data_subject,
                'ALL'                  token_name,
                'token' as             token_type;
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
                          sync_es_status)
select distinct 'RelationTeam'                                   "owner",
                '' || '' || '' || 'bt'                        as "type",
                '' || '' || '' || 'bt' || level_def_temp.code as "name",
                'SYSTEM'                                         "source",
                'PUBLIC'                                         visible_type,
                'TOTAL_PART'                                     strategy,
                'Token ' || level_def_temp.level_name            "content",
                'SQL'                                            rule_type,
                '' || '' || '' || 'bt'                           rule_group,
                'RESULT'                                         value_type,
                999999                                           run_order,
                now()                                            created_at,
                0                                                refresh_time,
                'DEFI'                                           wired_type,
                999                                              label_order,
                'WAITING'                                        sync_es_status
from level_def_temp
where type = 'defi_balance_top';
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
select distinct 'ALL_TOKEN'                                   asset,
                ''                                            project,
                ''                                            trade_type,
                level_def_temp.level                          balance,
                ''                                            volume,
                ''                                            activity,
                ''                                            hold_time,
                now()                                         created_at,
                '' || '' || '' || 'bt' || level_def_temp.code label_name,
                'token'                                       asset_type,
                'TOP'                                         label_category,
                'ALL'                                         recent_time_code
from level_def_temp
where type = 'defi_balance_top';


--------------count  ALL_DAI(0x6b1754)_ALL_ACTIVITY
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type,
                           recent_code)
select distinct t.address                                                as token,
                recent_time_temp.code || '' || 't' || t.id || '' || 'cg' as label_type,
                'T'                                                         operate_type,
                'count'                                                     data_subject,
                now()                                                    as create_time,
                t.symbol                                                 as token_name,
                'token'                                                  as token_type,
                recent_time_temp.recent_time_code
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                     "owner",
                recent_time_temp.code || '' || 't' || t.id || '' || 'cg'                        as "type",
                recent_time_temp.code || '' || 't' || t.id || '' || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                                           "source",
                'PUBLIC'                                                                           visible_type,
                'TOTAL_PART'                                                                       strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || t.symbol || ' ' ||
                level_def_temp.level_name                                                          "content",
                'SQL'                                                                              rule_type,
                recent_time_temp.code || '' || 't' || t.id || '' || 'cg'                           rule_group,
                'RESULT'                                                                           value_type,
                999999                                                                             run_order,
                now()                                                                              created_at,
                0                                                                                  refresh_time,
                'DEFI'                                                                             wired_type,
                999                                                                                label_order,
                'WAITING'                                                                          sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'                            asset,
                ''                                                                              project,
                ''                                                                              trade_type,
                ''                                                                              balance,
                ''                                                                              volume,
                level_def_temp.level                                                            activity,
                ''                                                                              hold_time,
                now()                                                                           created_at,
                recent_time_temp.code || '' || 't' || t.id || '' || 'cg' || level_def_temp.code label_name,
                'token'                                                                         asset_type,
                'GRADE'                                                                         label_category,
                recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where holders >= 100
  and removed <> 'true';

--------count ALL_ALL_ALL_ACTIVITY
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type,
                            recent_code)
select distinct 'ALL'                                           "token",
                recent_time_temp.code || '' || '' || '' || 'cg' label_type,
                'T'                                             operate_type,
                'count'                                         data_subject,
                'ALL'                                           token_name,
                'token' as                                      token_type,
                recent_time_temp.recent_time_code
from recent_time_temp;

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
                          sync_es_status)
select distinct 'RelationTeam'                                                            "owner",
                recent_time_temp.code || '' || '' || '' || 'cg'                        as "type",
                recent_time_temp.code || '' || '' || '' || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                                  "source",
                'PUBLIC'                                                                  visible_type,
                'TOTAL_PART'                                                              strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'Token ' ||
                level_def_temp.level_name                                                 "content",
                'SQL'                                                                     rule_type,
                recent_time_temp.code || '' || '' || '' || 'cg' || level_def_temp.code    rule_group,
                'RESULT'                                                                  value_type,
                999999                                                                    run_order,
                now()                                                                     created_at,
                0                                                                         refresh_time,
                'DEFI'                                                                    wired_type,
                999                                                                       label_order,
                'WAITING'                                                                 sync_es_status
from level_def_temp
         inner join recent_time_temp on (1 = 1)
where type = 'defi_count';
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
select distinct 'ALL_TOKEN'                                                            asset,
                ''                                                                     project,
                ''                                                                     trade_type,
                ''                                                                     balance,
                ''                                                                     volume,
                level_def_temp.level                                                   activity,
                ''                                                                     hold_time,
                now()                                                                  created_at,
                recent_time_temp.code || '' || '' || '' || 'cg' || level_def_temp.code label_name,
                'token'                                                                asset_type,
                'GRADE'                                                                label_category,
                recent_time_code
from level_def_temp
         inner join recent_time_temp on (1 = 1)
where type = 'defi_count';

--------------time_grade DOP(0x6bb612)_HOLDING_TIME_GRADE
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type)
select distinct t.address                       as token,
                '' || 't' || t.id || '' || 'tg' as label_type,
                'T'                                operate_type,
                'time_grade'                       data_subject,
                now()                           as create_time,
                t.symbol                        as token_name,
                'token'                         as token_type
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t;

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
                          sync_es_status)
select distinct 'RelationTeam'                                            "owner",
                '' || 't' || t.id || '' || 'tg'                           "type",
                '' || 't' || t.id || '' || 'tg' || level_def_temp.code as "name",
                'SYSTEM'                                                  "source",
                'PUBLIC'                                                  visible_type,
                'TOTAL_PART'                                              strategy,
                t.symbol || ' ' || level_def_temp.level_name              "content",
                'SQL'                                                     rule_type,
                '' || 't' || t.id || '' || 'tg'                           rule_group,
                'RESULT'                                                  value_type,
                999999                                                    run_order,
                now()                                                     created_at,
                0                                                         refresh_time,
                'DEFI'                                                    wired_type,
                999                                                       label_order,
                'WAITING'                                                 sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_time_grade') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'   asset,
                ''                                                     project,
                ''                                                     trade_type,
                ''                                                     balance,
                ''                                                     volume,
                ''                                                     activity,
                level_def_temp.level                                   hold_time,
                now()                                                  created_at,
                '' || 't' || t.id || '' || 'tg' || level_def_temp.code label_name,
                'token'                                                asset_type,
                'GRADE'                                                label_category,
                'ALL'                                                  recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_time_grade') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';

--------------time_special  DAI(0x6b1754)_HOLDING_TIME_SPECIAL
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type)
select distinct t.address                       as token,
                '' || 't' || t.id || '' || 'ts' as label_type,
                'T'                                operate_type,
                'time_special'                     data_subject,
                now()                           as create_time,
                t.symbol                        as token_name,
                'token'                         as token_type
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t;

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
                          sync_es_status)
select distinct 'RelationTeam'                                            "owner",
                '' || 't' || t.id || '' || 'ts'                        as "type",
                '' || 't' || t.id || '' || 'ts' || level_def_temp.code as "name",
                'SYSTEM'                                                  "source",
                'PUBLIC'                                                  visible_type,
                'TOTAL_PART'                                              strategy,
                t.symbol || ' ' || level_def_temp.level_name              "content",
                'SQL'                                                     rule_type,
                '' || 't' || t.id || '' || 'ts'                           rule_group,
                'RESULT'                                                  value_type,
                999999                                                    run_order,
                now()                                                     created_at,
                0                                                         refresh_time,
                'DEFI'                                                    wired_type,
                999                                                       label_order,
                'WAITING'                                                 sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_time_special') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'   asset,
                ''                                                     project,
                ''                                                     trade_type,
                ''                                                     balance,
                ''                                                     volume,
                ''                                                     activity,
                level_def_temp.level                                   hold_time,
                now()                                                  created_at,
                '' || 't' || t.id || '' || 'ts' || level_def_temp.code label_name,
                'token'                                                asset_type,
                'SPECIAL'                                              label_category,
                'ALL'                                                  recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_time_special') level_def_temp on
    (1 = 1)
where holders >= 100
  and removed <> 'true';

--------------volume_grade  ALL_DAI(0x6b1754)_ALL_VOLUME_GRADE
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type,
                           recent_code)
select distinct t.address                                                as token,
                recent_time_temp.code || '' || 't' || t.id || '' || 'vg' as label_type,
                'T'                                                         operate_type,
                'volume_grade'                                              data_subject,
                now()                                                    as create_time,
                t.symbol                                                 as token_name,
                'token'                                                  as token_type,
                recent_time_temp.recent_time_code
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                     "owner",
                recent_time_temp.code || '' || 't' || t.id || '' || 'vg'                        as "type",
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || '' || 't' || t.id || '' || 'vg' || level_def_temp.code as "name",
                'SYSTEM'                                                                           "source",
                'PUBLIC'                                                                           visible_type,
                'TOTAL_PART'                                                                       strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || t.symbol || (case
                                                                                                                when level_def_temp.level = 'Million' or level_def_temp.level = 'Billion'
                                                                                                                    then ' ' || level_def_temp.level
                                                                                                                else '' end) ||
                ' ' || level_def_temp.level_name                                                   "content",
                'SQL'                                                                              rule_type,
                recent_time_temp.code || '' || 't' || t.id || '' || 'vg'                           rule_group,
                'RESULT'                                                                           value_type,
                999999                                                                             run_order,
                now()                                                                              created_at,
                0                                                                                  refresh_time,
                'DEFI'                                                                             wired_type,
                999                                                                                label_order,
                'WAITING'                                                                          sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'                            asset,
                ''                                                                              project,
                ''                                                                              trade_type,
                ''                                                                              balance,
                level_def_temp.level                                                            volume,
                ''                                                                              activity,
                ''                                                                              hold_time,
                now()                                                                           created_at,
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || '' || 't' || t.id || '' || 'vg' || level_def_temp.code label_name,
                'token'                                                                         asset_type,
                'GRADE'                                                                         label_category,
                recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where holders >= 100
  and removed <> 'true';

--------volume_grade ALL_ALL_ALL_VOLUME_GRADE
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type,
                            recent_code)
select distinct 'ALL'                                           "token",
                recent_time_temp.code || '' || '' || '' || 'vg' label_type,
                'T'                                             operate_type,
                'volume_grade'                                  data_subject,
                'ALL'                                           token_name,
                'token' as                                      token_type,
                recent_time_temp.recent_time_code
from recent_time_temp;
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
                          sync_es_status)
select distinct 'RelationTeam'                                                            "owner",
                recent_time_temp.code || '' || '' || '' || 'vg'                        as "type",
                recent_time_temp.code || '' || '' || '' || 'vg' || level_def_temp.code as "name",
                'SYSTEM'                                                                  "source",
                'PUBLIC'                                                                  visible_type,
                'TOTAL_PART'                                                              strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'Token ' || (case
                                                                                                                when level_def_temp.level = 'Million' or level_def_temp.level = 'Billion'
                                                                                                                    then level_def_temp.level || ' '
                                                                                                                else '' end) ||
                level_def_temp.level_name                                                 "content",
                'SQL'                                                                     rule_type,
                recent_time_temp.code || '' || '' || '' || 'vg'                           rule_group,
                'RESULT'                                                                  value_type,
                999999                                                                    run_order,
                now()                                                                     created_at,
                0                                                                         refresh_time,
                'DEFI'                                                                    wired_type,
                999                                                                       label_order,
                'WAITING'                                                                 sync_es_status
from level_def_temp
         inner join recent_time_temp on (1 = 1)
where type = 'defi_volume_grade';
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
select distinct 'ALL_TOKEN'                                                            asset,
                ''                                                                     project,
                ''                                                                     trade_type,
                ''                                                                     balance,
                level_def_temp.level                                                   volume,
                ''                                                                     activity,
                ''                                                                     hold_time,
                now()                                                                  created_at,
                recent_time_temp.code || '' || '' || '' || 'vg' || level_def_temp.code label_name,
                'token'                                                                asset_type,
                'GRADE'                                                                label_category,
                recent_time_code
from level_def_temp
         inner join recent_time_temp on (1 = 1)
where type = 'defi_volume_grade';

--------------volume_rank  ALL_DAI(0x6b1754)_ALL_VOLUME_RANK
insert
into dim_rule_content_temp(token,
                           label_type,
                           operate_type,
                           data_subject,
                           create_time,
                           token_name,
                           token_type,
                           recent_code)
select distinct t.address                                                as token,
                recent_time_temp.code || '' || 't' || t.id || '' || 'vr' as label_type,
                'T'                                                         operate_type,
                'volume_rank'                                               data_subject,
                now()                                                    as create_time,
                t.symbol                                                 as token_name,
                'token'                                                  as token_type,
                recent_time_temp.recent_time_code
from (select * from top_token_1000_temp where holders >= 100 and removed <> 'true') t
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
                          sync_es_status)
select distinct 'RelationTeam'                                                                     "owner",
                recent_time_temp.code || '' || 't' || t.id || '' || 'vr'                        as "type",
                recent_time_temp.code || '' || 't' || t.id || '' || 'vr' || level_def_temp.code as "name",
                'SYSTEM'                                                                           "source",
                'PUBLIC'                                                                           visible_type,
                'TOTAL_PART'                                                                       strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || t.symbol || ' ' ||
                level_def_temp.level_name || ' ' || 'Trader'                                       "content",
                'SQL'                                                                              rule_type,
                recent_time_temp.code || '' || 't' || t.id || '' || 'vr'                           rule_group,
                'RESULT'                                                                           value_type,
                999999                                                                             run_order,
                now()                                                                              created_at,
                0                                                                                  refresh_time,
                'DEFI'                                                                             wired_type,
                999                                                                                label_order,
                'WAITING'                                                                          sync_es_status
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where holders >= 100
  and removed <> 'true';
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
select distinct t.symbol || '(' || SUBSTRING(t.address, 1, 8) || ')'                            asset,
                ''                                                                              project,
                ''                                                                              trade_type,
                ''                                                                              balance,
                level_def_temp.level                                                            volume,
                ''                                                                              activity,
                ''                                                                              hold_time,
                now()                                                                           created_at,
                recent_time_temp.code || '' || 't' || t.id || '' || 'vr' || level_def_temp.code label_name,
                'token'                                                                         asset_type,
                'RANK'                                                                          label_category,
                recent_time_code
from top_token_1000_temp t
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where holders >= 100
  and removed <> 'true';


--------volume_rank ALL_ALL_ALL_VOLUME_RANK
insert
into dim_rule_content_temp ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,
                            token_type,
                            recent_code)
select distinct 'ALL'                                           "token",
                recent_time_temp.code || '' || '' || '' || 'vr' label_type,
                'T'                                             operate_type,
                'volume_rank'                                   data_subject,
                'ALL'                                           token_name,
                'token' as                                      token_type,
                recent_time_temp.recent_time_code
from recent_time_temp;
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
                          sync_es_status)
select distinct 'RelationTeam'                                                            "owner",
                recent_time_temp.code || '' || '' || '' || 'vr'                        as "type",
                recent_time_temp.code || '' || '' || '' || 'vr' || level_def_temp.code as "name",
                'SYSTEM'                                                                  "source",
                'PUBLIC'                                                                  visible_type,
                'TOTAL_PART'                                                              strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'Token ' ||
                level_def_temp.level_name || ' ' || 'Trader'                              "content",
                'SQL'                                                                     rule_type,
                recent_time_temp.code || '' || '' || '' || 'vr'                           rule_group,
                'RESULT'                                                                  value_type,
                999999                                                                    run_order,
                now()                                                                     created_at,
                0                                                                         refresh_time,
                'DEFI'                                                                    wired_type,
                999                                                                       label_order,
                'WAITING'                                                                 sync_es_status
from level_def_temp
         inner join recent_time_temp on (1 = 1)
where type = 'defi_volume_rank';
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
select distinct 'ALL_TOKEN'                                                            asset,
                ''                                                                     project,
                ''                                                                     trade_type,
                ''                                                                     balance,
                level_def_temp.level                                                   volume,
                ''                                                                     activity,
                ''                                                                     hold_time,
                now()                                                                  created_at,
                recent_time_temp.code || '' || '' || '' || 'vr' || level_def_temp.code label_name,
                'token'                                                                asset_type,
                'RANK'                                                                 label_category,
                'ALL'                                                                  recent_time_code
from level_def_temp
         inner join recent_time_temp on (1 = 1)
where type = 'defi_volume_rank';

insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'ctw',---crowd_token_whale
        '',
        '',
        'ALL');
insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'cnw',----crowd_nft_whale
        '',
        '',
        'ALL');


insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'cau',----crowd_active_users
        '',
        '',
        'ALL');
insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'cdau',----crowd_defi_active_users
        '',
        '',
        'ALL');

insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'cnau',---crowd_nft_active_users
        '',
        '',
        'ALL');
insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'cwau',-----crowd_web3_active_users
        '',
        '',
        'ALL');


insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'clth',----crowd_long_term_holder
        '',
        '',
        'ALL');
insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'cdhd',------crowd_defi_high_demander
        '',
        '',
        'ALL');


insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'cnhd',-----crowd_nft_high_demander
        '',
        '',
        'ALL');
insert
into combination_temp (asset,
                       project,
                       trade_type,
                       balance,
                       volume,
                       activity,
                       hold_time,
                       created_at,
                       updated_at,
                       removed,
                       label_name,
                       asset_type,
                       label_category,
                       recent_time_code)
values ('',
        '',
        '',
        '',
        '',
        '',
        '',
        '2023-07-09 11:02:30.723',
        '2023-07-09 11:02:30.723',
        false,
        'ce',----crowd_elite
        '',
        '',
        'ALL');
insert into dim_rank_token_temp
select distinct token, token_type
from dim_rule_content_temp;
insert into tag_result(table_name, batch_date)
SELECT 'dim_rule_content' as table_name, '${batchDate}' as batch_date;