drop table if exists dim_project_token_type_temp;
create table dim_project_token_type_temp
(
    project         varchar(100),
    token           varchar(100),
    type            varchar(100),
    label_type      varchar(100),
    label_name      varchar(100),
    content         varchar(100),
    operate_type    varchar(100),
    seq_flag        varchar(100),
    data_subject    varchar(100),
    etl_update_time timestamp,
    project_name    varchar(100),
    token_name      varchar(100),
    recent_code     varchar(30),
    nft_type        varchar(30)
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    distributed by
(
    label_type
);
truncate table dim_project_token_type_temp;
vacuum
dim_project_token_type_temp;


drop table if exists dim_project_token_type_rank_temp;
create table dim_project_token_type_rank_temp
(
    token_id varchar(512),
    project  varchar(100)
);
truncate table dim_project_token_type_rank_temp;
vacuum
dim_project_token_type_rank_temp;

---------------------------------dim_dex_lp.sql---------------------------------------------
-----FIRST_MOVER_LP  Uniswap_v2_UNI/WETH_0xd3d2_HOLDING_TIME_FIRST_MOVER_LP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)

select distinct platform_detail_temp.platform     as                 project,
                lpt.pool                          as                 token,
                'lp'                              as                 type,
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'tf' as                 label_type,
                'T'                               as                 operate_type,
                lpt.factory_type || '_' || lpt.symbol_wired || '_lp' seq_flag,
                'FIRST_MOVER_LP'                                     data_subject,
                lpt.factory_type                                     project_name,
                lpt.symbol_wired                                     token_name
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
select distinct 'RelationTeam'                                                  "owner",
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'tf' as                            "type",
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'tf' as                            "name",
                'SYSTEM'                                                        "source",
                'PUBLIC'                                                        visible_type,
                'TOTAL_PART'                                                    strategy,
                lpt.factory_content || ' ' || symbol_wired || ' First Mover LP' "content",
                'SQL'                                                           rule_type,
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'tf'                               rule_group,
                'RESULT'                                                        value_type,
                999999                                                          run_order,
                now()                                                           created_at,
                0                                                               refresh_time,
                'DEFI'                                                          wired_type,
                999                                                             label_order,
                'WAITING'                                                       sync_es_status
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
                lpt.factory_content                                                            project,
                ''                                                                             trade_type,
                ''                                                                             balance,
                ''                                                                             volume,
                ''                                                                             activity,
                'FIRST_MOVER_LP'                                                               hold_time,
                now()                                                                          created_at,
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'tf'                                              label_name,
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
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);

-----HEAVY_LP  Uniswap_v2_UNI/WETH_0xd3d2_BALANCE_HEAVY_LP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)

select distinct platform_detail_temp.platform      as project,
                lpt.pool                           as token,
                'lp'                               as type,
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'bhl' as label_type,
                'T'                                as operate_type,
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'bhl'    seq_flag,
                'HEAVY_LP'                            data_subject,
                lpt.factory_type                      project_name,
                lpt.symbol_wired                      token_name
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
select distinct 'RelationTeam'                                            "owner",
                --平台+资产+交易类型
                '' || 'l' || lpt.id || '' || 'bhl' as                     "type",
                '' || 'l' || lpt.id || '' || 'bhl' as                     "name",
                'SYSTEM'                                                  "source",
                'PUBLIC'                                                  visible_type,
                'TOTAL_PART'                                              strategy,
                lpt.factory_content || ' ' || symbol_wired || ' Heavy LP' "content",
                'SQL'                                                     rule_type,
                '' || 'l' || lpt.id || '' || 'bhl'                        rule_group,
                'RESULT'                                                  value_type,
                999999                                                    run_order,
                now()                                                     created_at,
                0                                                         refresh_time,
                'DEFI'                                                    wired_type,
                999                                                       label_order,
                'WAITING'                                                 sync_es_status
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
                lpt.factory_content                                                            project,
                ''                                                                             trade_type,
                'HEAVY_LP'                                                                     balance,
                ''                                                                             volume,
                ''                                                                             activity,
                ''                                                                             hold_time,
                now()                                                                          created_at,
                '' || 'l' || lpt.id || '' || 'bhl'                                             label_name,
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
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);

-----FIRST_MOVER_STAKING Sushiswap_SYN/WETH_0x4a86_BALANCE_FIRST_MOVER_STAKING
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)

select distinct platform_detail_temp.platform     as project,
                lpt.pool                          as token,
                'lp'                              as type,
                '' || 'l' || lpt.id || '' || 'bf' as label_type,
                'T'                               as operate_type,
                '' || 'l' || lpt.id || '' || 'bf'    seq_flag,
                'FIRST_MOVER_STAKING'                data_subject,
                lpt.factory_type                     project_name,
                lpt.symbol_wired                     token_name
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
        and wlp."type" = 'LP' and wlp.factory_type in('Sushiswap')) lpt
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
select distinct 'RelationTeam'                                                       "owner",
                '' || 'l' || lpt.id || '' || 'bf' as                                 "type",
                '' || 'l' || lpt.id || '' || 'bf' as                                 "name",
                'SYSTEM'                                                             "source",
                'PUBLIC'                                                             visible_type,
                'TOTAL_PART'                                                         strategy,
                lpt.factory_content || ' ' || symbol_wired || ' First Mover Staking' "content",
                'SQL'                                                                rule_type,
                '' || 'l' || lpt.id || '' || 'bf'                                    rule_group,
                'RESULT'                                                             value_type,
                999999                                                               run_order,
                now()                                                                created_at,
                0                                                                    refresh_time,
                'DEFI'                                                               wired_type,
                999                                                                  label_order,
                'WAITING'                                                            sync_es_status
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
        and wlp."type" = 'LP' and wlp.factory_type in('Sushiswap')) lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);
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
                lpt.factory_content                                                            project,
                ''                                                                             trade_type,
                ''                                                                             balance,
                ''                                                                             volume,
                ''                                                                             activity,
                'FIRST_MOVER_STAKING'                                                          hold_time,
                now()                                                                          created_at,
                '' || 'l' || lpt.id || '' || 'bf'                                              label_name,
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
        and wlp."type" = 'LP' and wlp.factory_type in('Sushiswap')) lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);


-----HEAVY_LP_STAKER Sushiswap_SYN/WETH_0x4a86_BALANCE_HEAVY_LP_STAKER
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)

select distinct platform_detail_temp.platform      as project,
                lpt.pool                           as token,
                'lp'                               as type,
                '' || 'l' || lpt.id || '' || 'bhs' as label_type,
                'T'                                as operate_type,
                '' || 'l' || lpt.id || '' || 'bhs'    seq_flag,
                'HEAVY_LP_STAKER'                     data_subject,
                lpt.factory_type                      project_name,
                lpt.symbol_wired                      token_name
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
        and wlp."type" = 'LP' and wlp.factory_type in('Sushiswap')) lpt
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
select distinct 'RelationTeam'                                                   "owner",
                '' || 'l' || lpt.id || '' || 'bhs' as                            "type",
                '' || 'l' || lpt.id || '' || 'bhs' as                            "name",
                'SYSTEM'                                                         "source",
                'PUBLIC'                                                         visible_type,
                'TOTAL_PART'                                                     strategy,
                lpt.factory_content || ' ' || symbol_wired || ' Heavy LP Staker' "content",
                'SQL'                                                            rule_type,
                '' || 'l' || lpt.id || '' || 'bhs'                               rule_group,
                'RESULT'                                                         value_type,
                999999                                                           run_order,
                now()                                                            created_at,
                0                                                                refresh_time,
                'DEFI'                                                           wired_type,
                999                                                              label_order,
                'WAITING'                                                        sync_es_status
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
        and wlp."type" = 'LP' and wlp.factory_type='Sushiswap') lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);
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
                lpt.factory_content                                                            project,
                ''                                                                             trade_type,
                'HEAVY_LP_STAKER'                                                              balance,
                ''                                                                             volume,
                ''                                                                             activity,
                ''                                                                             hold_time,
                now()                                                                          created_at,
                '' || 'l' || lpt.id || '' || 'bhs'                                             label_name,
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
        and wlp."type" = 'LP' and wlp.factory_type in('Sushiswap')) lpt
         inner join platform_detail_temp on (lpt.factory_type = platform_detail_temp.platform_name);



--------------------------------------------------dim_mp_nft.sql----------------------------
--------count project+token
-- Blur_CryptoPunks_ALL_MP_NFT_ACTIVITY
-- Blur_CryptoPunks_Sale_MP_NFT_ACTIVITY
-- Blur_CryptoPunks_Buy_MP_NFT_ACTIVITY
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct nft_platform_temp.platform_name    project,
                nft_platform_temp.address          "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg'   seq_flag,
                'count'                            data_subject,
                mp_nft_platform_temp.platform_name project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg'                        as "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag is null
                         then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag = '1' then
                                replace(level_def_temp.level_name, ' ',
                                        ' ' || nft_trade_type_temp.nft_trade_type_name || ' ')
                            else level_def_temp.level_name end) || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then ''
                     when nft_trade_type_temp.nft_trade_type = 'ALL' then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end)     "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg'                           rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'NFT'                                                      wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                                                            asset,
                mp_nft_platform_temp.platform_name                                                   project,
                nft_trade_type_temp.nft_trade_type                                                   trade_type,
                ''                                                                                   balance,
                ''                                                                                   volume,
                level_def_temp.level                                                                 activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg' || level_def_temp.code                              label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'GRADE'                                                                              label_category,
                recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';


--------count PROJECT(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_ACTIVITY
-- ALL_ALL_Buy_MP_NFT_ACTIVITY
-- ALL_ALL_Sale_MP_NFT_ACTIVITY
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                                                                        project,
                'ALL'                                                                        "token",
                nft_trade_type_temp.nft_trade_type                                           "type",
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'cg' label_type,
                'T'                                                                          operate_type,
                recent_time_temp.recent_time_name ||
                (case when recent_time_temp.recent_time_name <> '' then '_' else '' end) ||
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'cg' seq_flag,
                'count'                                                                      data_subject,
                'ALL'                                                                        project_name,
                'ALL'                                                                        token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                                  "owner",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'cg' as "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code                                                          as "name",
                'SYSTEM'                                                                        "source",
                'PUBLIC'                                                                        visible_type,
                'TOTAL_PART'                                                                    strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP NFT ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag is null
                         then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag = '1' then
                                replace(level_def_temp.level_name, ' ',
                                        ' ' || nft_trade_type_temp.nft_trade_type_name || ' ')
                            else level_def_temp.level_name end) || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then ''
                     when nft_trade_type_temp.nft_trade_type = 'ALL' then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end)                          "content",
                'SQL'                                                                           rule_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'cg'    rule_group,
                'RESULT'                                                                        value_type,
                999999                                                                          run_order,
                now()                                                                           created_at,
                0                                                                               refresh_time,
                'NFT'                                                                           wired_type,
                999                                                                             label_order,
                'WAITING'                                                                       sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'ALL_NFT'                                              asset,
                'ALL'                                                  project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END        trade_type,
                ''                                                     balance,
                ''                                                     volume,
                level_def_temp.level                                   activity,
                ''                                                     hold_time,
                now()                                                  created_at,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code                                    label_name,
                'nft'                                                  asset_type,
                'GRADE'                                                label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';

--------count project(ALL)+token
-- ALL_CryptoPunks_ALL_MP_NFT_ACTIVITY
-- ALL_CryptoPunks_Buy_MP_NFT_ACTIVITY
-- ALL_CryptoPunks_Sale_MP_NFT_ACTIVITY
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                              project,
                nft_sync_address.address           "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' || nft_trade_type_temp.code ||
                'cg'                               label_type,
                'T'                                operate_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg'   seq_flag,
                'count'                            data_subject,
                'ALL'                              project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg'                        as "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP ' ||
                nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag is null
                         then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag = '1' then
                                replace(level_def_temp.level_name, ' ',
                                        ' ' || nft_trade_type_temp.nft_trade_type_name || ' ')
                            else level_def_temp.level_name end) || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then ''
                     when nft_trade_type_temp.nft_trade_type = 'ALL' then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end)     "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg'                           rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'NFT'                                                      wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                                                            asset,
                'ALL'                                                                                project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END                                      trade_type,
                ''                                                                                   balance,
                ''                                                                                   volume,
                level_def_temp.level                                                                 activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'cg' || level_def_temp.code                              label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'GRADE'                                                                              label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';


--------count project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_ACTIVITY
-- Blur_ALL_Buy_MP_NFT_ACTIVITY
-- Blur_ALL_Sale_MP_NFT_ACTIVITY
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code,
                                  nft_type)
select distinct (select nft_platform_temp.platform_name
                 from nft_platform_temp
                 where mp_nft_platform_temp.platform = nft_platform_temp.platform
                    limit 1)  project,
    'ALL' as  "token",
    nft_trade_type_temp.nft_trade_type "type",
    recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'cg'  label_type,
    'T' operate_type,
     recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'cg'  seq_flag,
    'count' data_subject,
    mp_nft_platform_temp.platform_name project_name,
    'ALL' token_name,
    recent_time_temp.recent_time_code,
    nft_type
from mp_nft_platform_temp
    inner join nft_trade_type_temp
on
    (1 = 1) inner join recent_time_temp on(1=1)
    INNER JOIN (select distinct platform,nft_trade_type,nft_type,nft_type_name from nft_action_platform_temp ) nft_action_platform_temp ON (mp_nft_platform_temp.platform= nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type=nft_action_platform_temp.nft_trade_type)
where
    nft_trade_type_temp.type = '1';

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
select distinct 'RelationTeam'                                         "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'cg'                as                                 "type",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code as                                 "name",
                'SYSTEM'                                               "source",
                'PUBLIC'                                               visible_type,
                'TOTAL_PART'                                           strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name ||
                ' ' || nft_action_platform_temp.nft_type_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag is null
                         then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag = '1' then
                                replace(level_def_temp.level_name, ' ',
                                        ' ' || nft_trade_type_temp.nft_trade_type_name || ' ')
                            else level_def_temp.level_name end) || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then ''
                     when nft_trade_type_temp.nft_trade_type = 'ALL' then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                  rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'cg'                                                   rule_group,
                'RESULT'                                               value_type,
                999999                                                 run_order,
                now()                                                  created_at,
                0                                                      refresh_time,
                'NFT'                                                  wired_type,
                999                                                    label_order,
                'WAITING'                                              sync_es_status
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

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
select distinct (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'ALL_NFT' else 'ALL_TOKEN' end) asset,
                mp_nft_platform_temp.platform_name                                                           project,
                nft_trade_type_temp.nft_trade_type                                                           trade_type,
                ''                                                                                           balance,
                ''                                                                                           volume,
                level_def_temp.level                                                                         activity,
                ''                                                                                           hold_time,
                now()                                                                                        created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code                                                                          label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end)         asset_type,
                'GRADE'                                                                                      label_category,
                recent_time_code
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

------volume_elite
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct nft_platform_temp.platform_name    project,
                nft_platform_temp.address          "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'   label_type,
                'T'                                operate_type,

                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'   seq_flag,
                'volume_elite'                     data_subject,
                mp_nft_platform_temp.platform_name project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                "owner",

                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'                        as    "type",
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've' || level_def_temp.code as    "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,

                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'                              rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                                                            asset,
                mp_nft_platform_temp.platform_name                                                   project,
                nft_trade_type_temp.nft_trade_type                                                   trade_type,
                ''                                                                                   balance,
                level_def_temp.level                                                                 volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,

                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've' || level_def_temp.code                              label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'ELITE'                                                                              label_category,
                recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';

--------volume_elite
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                              project,
                nft_sync_address.address           "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'   seq_flag,
                'volume_elite'                     data_subject,
                'ALL'                              project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'                        as    "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've' || level_def_temp.code as    "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP ' ||
                nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 've'                              rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                       asset,
                'ALL'                                           project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code ||
                've' level_def_temp.code  label_name, (case
                                                           when nft_action_platform_temp.nft_type = 'ERC721'
                                                               THEN 'nft'
                                                           else 'token' end) asset_type,
                'ELITE'                                         label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';


--------volume_elite project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_ELITE
-- Blur_ALL_Buy_MP_NFT_VOLUME_ELITE
-- Blur_ALL_Sale_MP_NFT_VOLUME_ELITE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code,
                                  nft_type)
select distinct (select nft_platform_temp.platform_name
                 from nft_platform_temp
                 where mp_nft_platform_temp.platform = nft_platform_temp.platform
                    limit 1)  project,
    'ALL'  "token",
    nft_trade_type_temp.nft_trade_type "type",
    recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 've'  label_type,
    'T' operate_type,
    recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 've' seq_flag,
    'volume_elite' data_subject,
    mp_nft_platform_temp.platform_name project_name,
    'ALL' token_name,
     recent_time_temp.recent_time_code,
    nft_type
from mp_nft_platform_temp
    inner join nft_trade_type_temp
on
    (1 = 1) inner join recent_time_temp on(1=1)
    INNER JOIN (select distinct platform,nft_trade_type,nft_type,nft_type_name from nft_action_platform_temp ) nft_action_platform_temp ON (mp_nft_platform_temp.platform= nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type=nft_action_platform_temp.nft_trade_type)
where
    nft_trade_type_temp.type = '1';

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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                've'                as                                        "type",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 've' ||
                level_def_temp.code as                                        "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_action_platform_temp.nft_type_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                've'                                                          rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

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
select distinct 'ALL_NFT'                                                                            asset,
                mp_nft_platform_temp.platform_name                                                   project,
                nft_trade_type_temp.nft_trade_type                                                   trade_type,
                ''                                                                                   balance,
                level_def_temp.level                                                                 volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 've' ||
                level_def_temp.code                                                                  label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'ELITE'                                                                              label_category,
                recent_time_code
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

--------volume_elite project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_ELITE
-- ALL_ALL_Buy_MP_NFT_VOLUME_ELITE
-- ALL_ALL_Sale_MP_NFT_VOLUME_ELITE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                                                                        project,
                'ALL'                                                                        "token",
                nft_trade_type_temp.nft_trade_type                                           "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 've' label_type,
                'T'                                                                          operate_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 've' seq_flag,
                'volume_elite'                                                               data_subject,
                'ALL'                                                                        project_name,
                'ALL'                                                                        token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                                  "owner",
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 've' as "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 've' ||
                level_def_temp.code                                                          as "name",
                'SYSTEM'                                                                        "source",
                'PUBLIC'                                                                        visible_type,
                'TOTAL_PART'                                                                    strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP NFT ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end)                   "content",
                'SQL'                                                                           rule_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 've'    rule_group,
                'RESULT'                                                                        value_type,
                999999                                                                          run_order,
                now()                                                                           created_at,
                0                                                                               refresh_time,
                'NFT'                                                                           wired_type,
                999                                                                             label_order,
                'WAITING'                                                                       sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'ALL_NFT'                                       asset,
                'ALL'                                           project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 've' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'ELITE'                                         label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';


--------volume_grade
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct nft_platform_temp.platform_name    project,
                nft_platform_temp.address          "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'   seq_flag,
                'volume_grade'                     data_subject,
                mp_nft_platform_temp.platform_name project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'                        as "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg' || level_def_temp.code as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                level_def_temp.level_name ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end)     "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'                           rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'NFT'                                                      wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                                                            asset,
                mp_nft_platform_temp.platform_name                                                   project,
                nft_trade_type_temp.nft_trade_type                                                   trade_type,
                ''                                                                                   balance,
                level_def_temp.level                                                                 volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg' || level_def_temp.code                              label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'GRADE'                                                                              label_category,
                recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';

--------volume_grade
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                              project,
                nft_sync_address.address           "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'   seq_flag,
                'volume_grade'                     data_subject,
                'ALL'                              project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'                        as "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg' || level_def_temp.code as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP ' ||
                nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                level_def_temp.level_name ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end)     "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg'                           rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'NFT'                                                      wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                                                            asset,
                'ALL'                                                                                project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END                                      trade_type,
                ''                                                                                   balance,
                level_def_temp.level                                                                 volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vg' || level_def_temp.code                              label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'GRADE'                                                                              label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';


--------volume_grade project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_GRADE
-- Blur_ALL_Buy_MP_NFT_VOLUME_GRADE
-- Blur_ALL_Sale_MP_NFT_VOLUME_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code,
                                  nft_type)
select distinct (select nft_platform_temp.platform_name
                 from nft_platform_temp
                 where mp_nft_platform_temp.platform = nft_platform_temp.platform
                    limit 1)  project,
    'ALL'  "token",
    nft_trade_type_temp.nft_trade_type "type",
   recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'vg'  label_type,
    'T' operate_type,
    recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'vg' seq_flag,
    'volume_grade' data_subject,
    mp_nft_platform_temp.platform_name project_name,
    'ALL' token_name,
    recent_time_temp.recent_time_code,
    nft_type
from mp_nft_platform_temp
    inner join nft_trade_type_temp
on
    (1 = 1) inner join recent_time_temp on(1=1)
    INNER JOIN (select distinct platform,nft_trade_type,nft_type,nft_type_name from nft_action_platform_temp ) nft_action_platform_temp ON (mp_nft_platform_temp.platform= nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type=nft_action_platform_temp.nft_trade_type)
where
    nft_trade_type_temp.type = '1';

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
select distinct 'RelationTeam'                                         "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'vg'                as                                 "type",
                recent_time_temp.recent_time_name ||
                (case when recent_time_temp.recent_time_name <> '' then '_' else '' end) ||
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code as                                 "name",
                'SYSTEM'                                               "source",
                'PUBLIC'                                               visible_type,
                'TOTAL_PART'                                           strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_action_platform_temp.nft_type_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                level_def_temp.level_name ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                  rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'vg'                                                   rule_group,
                'RESULT'                                               value_type,
                999999                                                 run_order,
                now()                                                  created_at,
                0                                                      refresh_time,
                'NFT'                                                  wired_type,
                999                                                    label_order,
                'WAITING'                                              sync_es_status
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

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
select distinct (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'ALL_NFT' else 'ALL_TOKEN' end) asset,
                mp_nft_platform_temp.platform_name                                                           project,
                nft_trade_type_temp.nft_trade_type                                                           trade_type,
                ''                                                                                           balance,
                level_def_temp.level                                                                         volume,
                ''                                                                                           activity,
                ''                                                                                           hold_time,
                now()                                                                                        created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code                                                                          label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end)         asset_type,
                'GRADE'                                                                                      label_category,
                recent_time_code
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

--------volume_grade project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_GRADE
-- ALL_ALL_Buy_MP_NFT_VOLUME_GRADE
-- ALL_ALL_Sale_MP_NFT_VOLUME_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                                                                        project,
                'ALL'                                                                        "token",
                nft_trade_type_temp.nft_trade_type                                           "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vg' label_type,
                'T'                                                                          operate_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vg' seq_flag,
                'volume_grade'                                                               data_subject,
                'ALL'                                                                        project_name,
                'ALL'                                                                        token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                                  "owner",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vg' as "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code                                                          as "name",
                'SYSTEM'                                                                        "source",
                'PUBLIC'                                                                        visible_type,
                'TOTAL_PART'                                                                    strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP NFT ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                level_def_temp.level_name ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end)                          "content",
                'SQL'                                                                           rule_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vg'    rule_group,
                'RESULT'                                                                        value_type,
                999999                                                                          run_order,
                now()                                                                           created_at,
                0                                                                               refresh_time,
                'NFT'                                                                           wired_type,
                999                                                                             label_order,
                'WAITING'                                                                       sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'ALL_NFT'                                       asset,
                'ALL'                                           project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'GRADE'                                         label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';

--------volume_rank
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct nft_platform_temp.platform_name    project,
                nft_platform_temp.address          "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr'   seq_flag,
                'volume_rank'                      data_subject,
                mp_nft_platform_temp.platform_name project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr'                        as    "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr' || level_def_temp.code as    "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr'                              rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                                                            asset,
                mp_nft_platform_temp.platform_name                                                   project,
                nft_trade_type_temp.nft_trade_type                                                   trade_type,
                ''                                                                                   balance,
                level_def_temp.level                                                                 volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr' || level_def_temp.code                              label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'RANK'                                                                               label_category,
                recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';

--------volume_rank
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                              project,
                nft_sync_address.address           "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr'   seq_flag,
                'volume_rank'                      data_subject,
                'ALL'                              project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr' as                           "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code              as                           "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP ' ||
                nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr'                              rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                       asset,
                'ALL'                                           project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                             label_name,
                (case
                     when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft'
                     else 'token' end)                          asset_type,
                'RANK'                                          label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';

--------volume_rank project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_RANK
-- Blur_ALL_Buy_MP_NFT_VOLUME_RANK
-- Blur_ALL_Sale_MP_NFT_VOLUME_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code,
                                  nft_type)
select distinct (select nft_platform_temp.platform_name
                 from nft_platform_temp
                 where mp_nft_platform_temp.platform = nft_platform_temp.platform
                    limit 1)  project,
   'ALL'  "token",
    nft_trade_type_temp.nft_trade_type "type",
    recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'vr'  label_type,
    'T' operate_type,
    recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'vr' seq_flag,
    'volume_rank' data_subject,
    mp_nft_platform_temp.platform_name project_name,
    'ALL' token_name,
     recent_time_temp.recent_time_code,
    nft_type
from mp_nft_platform_temp
    inner join nft_trade_type_temp
on
    (1 = 1) inner join recent_time_temp on(1=1)
    INNER JOIN (select distinct platform,nft_trade_type,nft_type,nft_type_name from nft_action_platform_temp ) nft_action_platform_temp ON (mp_nft_platform_temp.platform= nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type=nft_action_platform_temp.nft_trade_type)
where
    nft_trade_type_temp.type = '1';

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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'vr'                as                                        "type",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code as                                        "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_action_platform_temp.nft_type_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'vr'                                                          rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

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
select distinct (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'ALL_NFT' else 'ALL_TOKEN' end) asset,
                mp_nft_platform_temp.platform_name                                                           project,
                nft_trade_type_temp.nft_trade_type                                                           trade_type,
                ''                                                                                           balance,
                level_def_temp.level                                                                         volume,
                ''                                                                                           activity,
                ''                                                                                           hold_time,
                now()                                                                                        created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                                                                          label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end)         asset_type,
                'RANK'                                                                                       label_category,
                recent_time_code
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';


--------volume_rank project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_RANK
-- ALL_ALL_Buy_MP_NFT_VOLUME_RANK
-- ALL_ALL_Sale_MP_NFT_VOLUME_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                                                                        project,
                'ALL'                                                                        "token",
                nft_trade_type_temp.nft_trade_type                                           "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vr' label_type,
                'T'                                                                          operate_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vr' seq_flag,
                'volume_rank'                                                                data_subject,
                'ALL'                                                                        project_name,
                'ALL'                                                                        token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                                  "owner",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vr' as "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                                                          as "name",
                'SYSTEM'                                                                        "source",
                'PUBLIC'                                                                        visible_type,
                'TOTAL_PART'                                                                    strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP NFT ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end)                   "content",
                'SQL'                                                                           rule_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vr'    rule_group,
                'RESULT'                                                                        value_type,
                999999                                                                          run_order,
                now()                                                                           created_at,
                0                                                                               refresh_time,
                'NFT'                                                                           wired_type,
                999                                                                             label_order,
                'WAITING'                                                                       sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'ALL_NFT'                                       asset,
                'ALL'                                           project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'RANK'                                          label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';

--------volume_top
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct nft_platform_temp.platform_name    project,
                nft_platform_temp.address          "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt'   seq_flag,
                'volume_top'                       data_subject,
                mp_nft_platform_temp.platform_name project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt'                        as    "type",
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt' || level_def_temp.code as    "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt'                              rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                                                            asset,
                mp_nft_platform_temp.platform_name                                                   project,
                nft_trade_type_temp.nft_trade_type                                                   trade_type,
                ''                                                                                   balance,
                'TOP'                                                                                volume,
                ''                                                                                   activity,
                ''                                                                                   hold_time,
                now()                                                                                created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt' || level_def_temp.code                              label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end) asset_type,
                'TOP'                                                                                label_category,
                recent_time_code
from nft_sync_address
         inner join nft_platform_temp on
    (nft_sync_address.address = nft_platform_temp.address)
         inner join mp_nft_platform_temp on
    (mp_nft_platform_temp.platform = nft_platform_temp.platform)
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON (nft_platform_temp.platform = nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
    and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';

--------volume_top
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                              project,
                nft_sync_address.address           "token",
                nft_trade_type_temp.nft_trade_type "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt'   label_type,
                'T'                                operate_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt'   seq_flag,
                'volume_top'                       data_subject,
                'ALL'                              project_name,
                nft_sync_address.platform          token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt' as                           "type",
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code              as                           "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP ' ||
                nft_sync_address.platform || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt'                              rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';
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
select distinct nft_sync_address.platform                       asset,
                'ALL'                                           project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                'TOP'                                           volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || '' || ('n' || nft_sync_address.id) || 'm' ||
                nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                             label_name,
                (case
                     when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft'
                     else 'token' end)                          asset_type,
                'TOP'                                           label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '1';


--------volume_top project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_TOP
-- Blur_ALL_Buy_MP_NFT_VOLUME_TOP
-- Blur_ALL_Sale_MP_NFT_VOLUME_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code,
                                  nft_type)
select distinct (select nft_platform_temp.platform_name
                 from nft_platform_temp
                 where mp_nft_platform_temp.platform = nft_platform_temp.platform
                    limit 1)  project,
   'ALL'  "token",
    nft_trade_type_temp.nft_trade_type "type",
    recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'vt' label_type,
    'T' operate_type,
     recent_time_temp.code || mp_nft_platform_temp.id || ''  || 'm' ||nft_trade_type_temp.code || 'vt' seq_flag,
    'volume_top' data_subject,
    mp_nft_platform_temp.platform_name project_name,
    'ALL' token_name,
     recent_time_temp.recent_time_code,
    nft_type
from mp_nft_platform_temp
    inner join nft_trade_type_temp
on
    (1 = 1) inner join recent_time_temp on(1=1)
    INNER JOIN (select distinct platform,nft_trade_type,nft_type,nft_type_name from nft_action_platform_temp ) nft_action_platform_temp ON (mp_nft_platform_temp.platform= nft_action_platform_temp.platform
    and nft_trade_type_temp.nft_trade_type=nft_action_platform_temp.nft_trade_type)
where
    nft_trade_type_temp.type = '1';

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
select distinct 'RelationTeam'                                                "owner",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'vt'                as                                        "type",
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code as                                        "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                mp_nft_platform_temp.platform_name || ' ' || nft_action_platform_temp.nft_type_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                         rule_type,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code ||
                'vt'                                                          rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';

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
select distinct (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'ALL_NFT' else 'ALL_TOKEN' end) asset,
                mp_nft_platform_temp.platform_name                                                           project,
                nft_trade_type_temp.nft_trade_type                                                           trade_type,
                ''                                                                                           balance,
                'TOP'                                                                                        volume,
                ''                                                                                           activity,
                ''                                                                                           hold_time,
                now()                                                                                        created_at,
                recent_time_temp.code || mp_nft_platform_temp.id || '' || 'm' || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                                                                          label_name,
                (case when nft_action_platform_temp.nft_type = 'ERC721' THEN 'nft' else 'token' end)         asset_type,
                'TOP'                                                                                        label_category,
                recent_time_code
from mp_nft_platform_temp
         inner join nft_trade_type_temp on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN (select distinct platform, nft_trade_type, nft_type, nft_type_name
                     from nft_action_platform_temp) nft_action_platform_temp
                    ON (mp_nft_platform_temp.platform = nft_action_platform_temp.platform
                        and nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type)
where nft_trade_type_temp.type = '1';


--------volume_top project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_TOP
-- ALL_ALL_Buy_MP_NFT_VOLUME_TOP
-- ALL_ALL_Sale_MP_NFT_VOLUME_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct 'ALL'                                                                        project,
                'ALL'                                                                        "token",
                nft_trade_type_temp.nft_trade_type                                           "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vt' label_type,
                'T'                                                                          operate_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vt' seq_flag,
                'volume_top'                                                                 data_subject,
                'ALL'                                                                        project_name,
                'ALL'                                                                        token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'RelationTeam'                                                                  "owner",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vt' as "type",
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                                                          as "name",
                'SYSTEM'                                                                        "source",
                'PUBLIC'                                                                        visible_type,
                'TOTAL_PART'                                                                    strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'MP NFT ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end)                   "content",
                'SQL'                                                                           rule_type,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vt'    rule_group,
                'RESULT'                                                                        value_type,
                999999                                                                          run_order,
                now()                                                                           created_at,
                0                                                                               refresh_time,
                'NFT'                                                                           wired_type,
                999                                                                             label_order,
                'WAITING'                                                                       sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';
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
select distinct 'ALL_NFT'                                       asset,
                'ALL'                                           project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                'TOP'                                           volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || '' || '' || 'm' || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'TOP'                                           label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '1';



---------------------------------dim_dex_token.sql---------------------
---------------count 0x_USDC(0xa0b869)_ALL_ACTIVITY_DEX--------------------------
insert
into dim_project_token_type_temp(project,
                                 "token",
                                 "type",
                                 label_type,
                                 operate_type,
                                 seq_flag,
                                 data_subject,
                                 project_name,
                                 token_name,
                                 recent_code)

select distinct token_platform_temp.platform as                                                          project,
                token_platform_temp.address  as                                                          token,
                trade_type.trade_type        as                                                          type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'cg'      as                                                          label_type,
                'T'                          as                                                          operate_type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'cg'                                                                  seq_flag,
                'count'                                                                                  data_subject,
                platform_temp.platform_name                                                              project_name,
                top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' token_name,
                recent_time_temp.recent_time_code
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp
                    on (token_platform_temp.address = top_token_1000_temp.address)
         INNER JOIN trade_type ON (top_token_1000_temp.asset_type = 'token' or
                                   (top_token_1000_temp.asset_type = 'lp' and trade_type.trade_type = 'stakelp'))
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'                                                                    "owner",
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg'                        as "type",
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                                          "source",
                'PUBLIC'                                                                          visible_type,
                'TOTAL_PART'                                                                      strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_temp.platform_name || ' ' ||
                top_token_1000_temp.symbol || ' ' ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                level_def_temp.level_name                                                         "content",
                'SQL'                                                                             rule_type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg'                           rule_group,
                'RESULT'                                                                          value_type,
                999999                                                                            run_order,
                now()                                                                             created_at,
                0                                                                                 refresh_time,
                'DEFI'                                                                            wired_type,
                999                                                                               label_order,
                'WAITING'                                                                         sync_es_status
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         inner join trade_type on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on (1 = 1)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' asset,
                platform_temp.platform_name                                                              project,
                trade_type.trade_type                                                                    trade_type,
                ''                                                                                       balance,
                ''                                                                                       volume,
                level_def_temp.level                                                                     activity,
                ''                                                                                       hold_time,
                now()                                                                                    created_at,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg' || level_def_temp.code           label_name,
                'token'                                                                                  asset_type,
                'GRADE'                                                                                  label_category,
                recent_time_code
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         inner join trade_type on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on (1 = 1)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

---------------count ALL_USDC(0xa0b869)_ALL_ACTIVITY_DEX--------------------------
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_large_category.platform_large_code             as project,
                top_token_1000_temp.address                             as token,
                trade_type.trade_type                                   as type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg' as label_type,
                'T'                                                     as operate_type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg'    seq_flag,
                'count'                                                    data_subject,
                'ALL'                                                      project_name,
                top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) ||
                ')'                                                        token_name,
                recent_time_temp.recent_time_code
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'                                                                    "owner",
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg'                        as "type",
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                                          "source",
                'PUBLIC'                                                                          visible_type,
                'TOTAL_PART'                                                                      strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_large_category.platform_large_name || ' ' ||
                top_token_1000_temp.symbol || ' '
                    || (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end)
                    || level_def_temp.level_name                                                  "content",
                'SQL'                                                                             rule_type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg'                           rule_group,
                'RESULT'                                                                          value_type,
                999999                                                                            run_order,
                now()                                                                             created_at,
                0                                                                                 refresh_time,
                'DEFI'                                                                            wired_type,
                999                                                                               label_order,
                'WAITING'                                                                         sync_es_status
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' asset,
                platform_large_category.platform_large_code                                              project,
                trade_type.trade_type                                                                    trade_type,
                ''                                                                                       balance,
                ''                                                                                       volume,
                level_def_temp.level                                                                     activity,
                ''                                                                                       hold_time,
                now()                                                                                    created_at,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'cg' || level_def_temp.code           label_name,
                'token'                                                                                  asset_type,
                'GRADE'                                                                                  label_category,
                recent_time_code
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

---------------count 1inch_ALL_ALL_ACTIVITY_DEX
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)

select distinct platform_temp.platform                                  as project,
                'ALL'                                                   as token,
                trade_type.trade_type                                   as type,
                recent_time_temp.code || '' || platform_temp.id || 't' ||
                platform_large_category.code || trade_type.code || 'cg' as label_type,
                'T'                                                     as operate_type,
                recent_time_temp.code || '' || platform_temp.id || 't' ||
                platform_large_category.code || trade_type.code || 'cg'    seq_flag,
                'count'                                                    data_subject,
                platform_temp.platform_name                                project_name,
                'ALL'                                                      token_name,
                recent_time_temp.recent_time_code
from platform_temp
         inner join trade_type on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || platform_temp.id || 't' ||
                platform_large_category.code || trade_type.code || 'cg' as "type",
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || '' || platform_temp.id || 't' ||
                platform_large_category.code || trade_type.code || 'cg' ||
                level_def_temp.code                                     as name,
                'SYSTEM'                                                as "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_temp.platform_name || ' '
                    || (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end)
                    || level_def_temp.level_name                           "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || platform_temp.id || 't' ||
                platform_large_category.code || trade_type.code || 'cg'    rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'DEFI'                                                     wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from platform_temp
         inner join trade_type on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
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
select distinct 'ALL_TOKEN'                 asset,
                platform_temp.platform_name project,
                trade_type.trade_type       trade_type,
                ''                          balance,
                ''                          volume,
                level_def_temp.level        activity,
                ''                          hold_time,
                now()                       created_at,
                recent_time_temp.code || '' || platform_temp.id || 't' ||
                platform_large_category.code || trade_type.code || 'cg' ||
                level_def_temp.code         label_name,
                'token'                     asset_type,
                'GRADE'                     label_category,
                recent_time_code
from platform_temp
         inner join trade_type on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
---------------count ALL_ALL_ALL_ACTIVITY_DEX
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_large_category.platform_large_code             as project,
                'ALL'                                                   as token,
                trade_type.trade_type                                   as type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'cg' as label_type,
                'T'                                                     as operate_type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'cg'    seq_flag,
                'count'                                                    data_subject,
                'ALL'                                                      project_name,
                'ALL'                                                      token_name,
                recent_time_temp.recent_time_code
from trade_type
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

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
select distinct 'RelationTeam'                                                                    "owner",
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'cg'                        as "type",
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'cg' || level_def_temp.code as "name",
                'SYSTEM'                                                                          "source",
                'PUBLIC'                                                                          visible_type,
                'TOTAL_PART'                                                                      strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_large_category.platform_large_name || ' ' ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                level_def_temp.level_name                                                         "content",
                'SQL'                                                                             rule_type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'cg'                           rule_group,
                'RESULT'                                                                          value_type,
                999999                                                                            run_order,
                now()                                                                             created_at,
                0                                                                                 refresh_time,
                'DEFI'                                                                            wired_type,
                999                                                                               label_order,
                'WAITING'                                                                         sync_es_status
from trade_type
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'ALL_TOKEN'                                                                    asset,
                platform_large_category.platform_large_code                                    project,
                trade_type.trade_type                                                          trade_type,
                ''                                                                             balance,
                ''                                                                             volume,
                level_def_temp.level                                                           activity,
                ''                                                                             hold_time,
                now()                                                                          created_at,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'cg' || level_def_temp.code label_name,
                'token'                                                                        asset_type,
                'GRADE'                                                                        label_category,
                recent_time_code
from trade_type
         inner join (select *
                     from level_def_temp
                     where type = 'defi_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

---------------volume_grade 0x_USDC(0xa0b869)_ALL_VOLUME_DEX_GRADE--------------------------
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)

select distinct token_platform_temp.platform as                                                          project,
                token_platform_temp.address  as                                                          token,
                trade_type.trade_type        as                                                          type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vg'      as                                                          label_type,
                'T'                          as                                                          operate_type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vg'                                                                  seq_flag,
                'volume_grade'                                                                           data_subject,
                platform_temp.platform_name                                                              project_name,
                top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' token_name,
                recent_time_temp.recent_time_code
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         INNER JOIN trade_type ON (top_token_1000_temp.asset_type = 'token' or
                                   (top_token_1000_temp.asset_type = 'lp' and trade_type.trade_type = 'stakelp'))
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'             "owner",
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vg' as "type",
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vg' ||
                level_def_temp.code     as "name",
                'SYSTEM'                   "source",
                'PUBLIC'                   visible_type,
                'TOTAL_PART'               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_temp.platform_name || ' ' ||
                top_token_1000_temp.symbol || ' ' ||
                (case
                     when level_def_temp.level = 'Million' or level_def_temp.level = 'Billion'
                         then level_def_temp.level || ' '
                     else '' end) ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                level_def_temp.level_name  "content",
                'SQL'                      rule_type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vg'    rule_group,
                'RESULT'                   value_type,
                999999                     run_order,
                now()                      created_at,
                0                          refresh_time,
                'DEFI'                     wired_type,
                999                        label_order,
                'WAITING'                  sync_es_status
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         INNER JOIN trade_type ON (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' asset,
                platform_temp.platform_name                                                              project,
                trade_type.trade_type                                                                    trade_type,
                ''                                                                                       balance,
                level_def_temp.level                                                                     volume,
                ''                                                                                       activity,
                ''                                                                                       hold_time,
                now()                                                                                    created_at,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vg' ||
                level_def_temp.code                                                                      label_name,
                'token'                                                                                  asset_type,
                'GRADE'                                                                                  label_category,
                recent_time_code
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         INNER JOIN trade_type ON (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

---------------volume_grade ALL_USDC(0xa0b869)_ALL_VOLUME_DEX_GRADE--------------------------
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_large_category.platform_large_code             as                               project,
                top_token_1000_temp.address                             as                               token,
                trade_type.trade_type                                   as                               type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vg' as                               label_type,
                'T'                                                     as                               operate_type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vg'                                  seq_flag,
                'volume_grade'                                                                           data_subject,
                'ALL'                                                                                    project_name,
                top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' token_name,
                recent_time_temp.recent_time_code
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'                                                                    "owner",
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vg'                        as "type",
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vg' || level_def_temp.code as "name",
                'SYSTEM'                                                                          "source",
                'PUBLIC'                                                                          visible_type,
                'TOTAL_PART'                                                                      strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_large_category.platform_large_name || ' ' ||
                top_token_1000_temp.symbol || ' ' ||
                (case
                     when trade_type.trade_type = 'ALL' and
                          (level_def_temp.level = 'Million' or level_def_temp.level = 'Billion')
                         then level_def_temp.level || ' '
                     else '' end) ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                (case
                     when trade_type.trade_type <> 'ALL' and
                          (level_def_temp.level = 'Million' or level_def_temp.level = 'Billion')
                         then level_def_temp.level || ' '
                     else '' end) ||
                level_def_temp.level_name                                                         "content",
                'SQL'                                                                             rule_type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vg'                           rule_group,
                'RESULT'                                                                          value_type,
                999999                                                                            run_order,
                now()                                                                             created_at,
                0                                                                                 refresh_time,
                'DEFI'                                                                            wired_type,
                999                                                                               label_order,
                'WAITING'                                                                         sync_es_status
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' asset,
                platform_large_category.platform_large_code                                              project,
                trade_type.trade_type                                                                    trade_type,
                ''                                                                                       balance,
                level_def_temp.level                                                                     volume,
                ''                                                                                       activity,
                ''                                                                                       hold_time,
                now()                                                                                    created_at,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vg' || level_def_temp.code           label_name,
                'token'                                                                                  asset_type,
                'GRADE'                                                                                  label_category,
                recent_time_code
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

---------------volume_grade 1inch_ALL_ALL_VOLUME_DEX_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_temp.platform                                  as project,
                'ALL'                                                   as token,
                trade_type.trade_type                                   as type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vg' as label_type,
                'T'                                                     as operate_type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vg'    seq_flag,
                'volume_grade'                                             data_subject,
                platform_temp.platform_name                                project_name,
                'ALL'                                                      token_name,
                recent_time_temp.recent_time_code
from platform_temp
         inner join trade_type on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vg' as "type",
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vg' ||
                level_def_temp.code                                     as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_temp.platform_name || ' ' ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                (CASE
                     WHEN level_def_temp.level = 'Million' or level_def_temp.level = 'Billion'
                         THEN level_def_temp.level || ' '
                     else '' end) ||
                level_def_temp.level_name                                  "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vg'    rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'DEFI'                                                     wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from platform_temp
         inner join trade_type on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
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
select distinct 'ALL_TOKEN'                 asset,
                platform_temp.platform_name project,
                trade_type.trade_type       trade_type,
                ''                          balance,
                level_def_temp.level        volume,
                ''                          activity,
                ''                          hold_time,
                now()                       created_at,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vg' ||
                level_def_temp.code         label_name,
                'token'                     asset_type,
                'GRADE'                     label_category,
                recent_time_code
from platform_temp
         inner join trade_type on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';

---------------volume_grade ALL_ALL_ALL_VOLUME_DEX_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_large_category.platform_large_code             as project,
                'ALL'                                                   as token,
                trade_type.trade_type                                   as type,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vg' as label_type,
                'T'                                                     as operate_type,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vg'    seq_flag,
                'volume_grade'                                             data_subject,
                'ALL'                                                      project_name,
                'ALL'                                                      token_name,
                recent_time_temp.recent_time_code
from trade_type
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vg' as "type",
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vg' ||
                level_def_temp.code                                     as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_large_category.platform_large_name || ' ' ||
                (CASE
                     WHEN trade_type.trade_type = 'ALL' and
                          (level_def_temp.level = 'Million' or level_def_temp.level = 'Billion')
                         THEN level_def_temp.level || ' '
                     else '' end) ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                (CASE
                     WHEN trade_type.trade_type <> 'ALL' and
                          (level_def_temp.level = 'Million' or level_def_temp.level = 'Billion')
                         THEN level_def_temp.level || ' '
                     else '' end) ||
                level_def_temp.level_name                                  "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vg'    rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'DEFI'                                                     wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from trade_type
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'ALL_TOKEN'                                 asset,
                platform_large_category.platform_large_code project,
                trade_type.trade_type                       trade_type,
                ''                                          balance,
                level_def_temp.level                        volume,
                ''                                          activity,
                ''                                          hold_time,
                now()                                       created_at,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vg' ||
                level_def_temp.code                         label_name,
                'token'                                     asset_type,
                'GRADE'                                     label_category,
                recent_time_code
from trade_type
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

---------------volume_rank 0x_USDC(0xa0b869)_ALL_VOLUME_DEX_RANK--------------------------
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)

select distinct token_platform_temp.platform as                                                          project,
                token_platform_temp.address  as                                                          token,
                trade_type.trade_type        as                                                          type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vr'      as                                                          label_type,
                'T'                          as                                                          operate_type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vr'                                                                  seq_flag,
                'volume_rank'                                                                            data_subject,
                platform_temp.platform_name                                                              project_name,
                top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' token_name,
                recent_time_temp.recent_time_code
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         INNER JOIN trade_type ON (top_token_1000_temp.asset_type = 'token' or
                                   (top_token_1000_temp.asset_type = 'lp' and trade_type.trade_type = 'stakelp'))
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'             "owner",
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vr' as "type",
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vr' ||
                level_def_temp.code     as "name",
                'SYSTEM'                   "source",
                'PUBLIC'                   visible_type,
                'TOTAL_PART'               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_temp.platform_name || ' ' ||
                top_token_1000_temp.symbol || ' ' ||
                level_def_temp.level_name || ' ' ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                'Trader'                   "content",
                'SQL'                      rule_type,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vr'    rule_group,
                'RESULT'                   value_type,
                999999                     run_order,
                now()                      created_at,
                0                          refresh_time,
                'DEFI'                     wired_type,
                999                        label_order,
                'WAITING'                  sync_es_status
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

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
select distinct top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' asset,
                platform_temp.platform_name                                                              project,
                trade_type.trade_type                                                                    trade_type,
                ''                                                                                       balance,
                level_def_temp.level                                                                     volume,
                ''                                                                                       activity,
                ''                                                                                       hold_time,
                now()                                                                                    created_at,
                recent_time_temp.code || platform_temp.id || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code ||
                trade_type.code || 'vr' || level_def_temp.code                                           label_name,
                'token'                                                                                  asset_type,
                'RANK'                                                                                   label_category,
                recent_time_code
from token_platform_temp
         inner join platform_temp on
    (token_platform_temp.platform = platform_temp.platform)
         inner join (select address,
                            symbol,
                            'token' as asset_type
                     from top_token_1000_temp
                     where holders >= 100
                       and removed <> 'true'
                     union all
                     select wlp.address,
                            wlp.symbol_wired as symbol,
                            'lp'             as asset_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp on
                                 wlp.address = wslp.address
                             and wlp.type = 'LP'
                             and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and string_to_array(wlp.symbol_wired, '/') && array['ETH',
                        'WETH',
                        'UNI',
                        'AAVE',
                        '1INCH',
                        'MANA',
                        'AXS',
                        'SAND']
                    and wlp."type" = 'LP') top_token_1000_temp on
    (token_platform_temp.address = top_token_1000_temp.address)
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp
                    on (token_platform_temp.platform = dex_action_platform_temp.platform and
                        trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);


---------------volume_rank ALL_USDC(0xa0b869)_ALL_VOLUME_DEX_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_large_category.platform_large_code             as                               project,
                top_token_1000_temp.address                             as                               token,
                trade_type.trade_type                                   as                               type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vr' as                               label_type,
                'T'                                                     as                               operate_type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vr'                                  seq_flag,
                'volume_rank'                                                                            data_subject,
                'ALL'                                                                                    project_name,
                top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' token_name,
                recent_time_temp.recent_time_code
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vr' as "type",
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vr' ||
                level_def_temp.code                                     as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_large_category.platform_large_name || ' ' ||
                top_token_1000_temp.symbol || ' ' ||
                (case when trade_type.trade_type = 'ALL' then level_def_temp.level || ' ' else '' end) ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                (case when trade_type.trade_type <> 'ALL' then '' || level_def_temp.level || ' ' else '' end) ||
                level_def_temp.level_name                                  "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vr'    rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'DEFI'                                                     wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct top_token_1000_temp.symbol || '(' || SUBSTRING(top_token_1000_temp.address, 1, 8) || ')' asset,
                platform_large_category.platform_large_code                                              project,
                trade_type.trade_type                                                                    trade_type,
                ''                                                                                       balance,
                level_def_temp.level                                                                     volume,
                ''                                                                                       activity,
                ''                                                                                       hold_time,
                now()                                                                                    created_at,
                recent_time_temp.code || '' || ('t' || top_token_1000_temp.id) ||
                platform_large_category.code || trade_type.code || 'vr' ||
                level_def_temp.code                                                                      label_name,
                'token'                                                                                  asset_type,
                'RANK'                                                                                   label_category,
                recent_time_code
from (select *
      from top_token_1000_temp
      where holders >= 100
        and removed <> 'true') top_token_1000_temp
         INNER JOIN trade_type ON (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join token_platform_temp on (top_token_1000_temp.address = token_platform_temp.address)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 token_platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_temp on (token_platform_temp.platform = platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);

---------------volume_rank 1inch_ALL_ALL_VOLUME_DEX_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_temp.platform                                  as project,
                'ALL'                                                   as token,
                trade_type.trade_type                                   as type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vr' as label_type,
                'T'                                                     as operate_type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vr'    seq_flag,
                'volume_rank'                                              data_subject,
                platform_temp.platform_name                                project_name,
                'ALL'                                                      token_name,
                recent_time_temp.recent_time_code
from platform_temp
         inner join trade_type on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vr' as "type",
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vr' ||
                level_def_temp.code                                     as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_temp.platform_name || ' ' ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                level_def_temp.level_name || ' ' ||
                'Trader'                                                   "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vr'    rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'DEFI'                                                     wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from platform_temp
         inner join trade_type on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
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
select distinct 'ALL_TOKEN'                 asset,
                platform_temp.platform_name project,
                trade_type.trade_type       trade_type,
                ''                          balance,
                level_def_temp.level        volume,
                ''                          activity,
                ''                          hold_time,
                now()                       created_at,
                recent_time_temp.code || '' || platform_temp.id || '' ||
                platform_large_category.code || trade_type.code || 'vr' ||
                level_def_temp.code         label_name,
                'token'                     asset_type,
                'RANK'                      label_category,
                recent_time_code
from platform_temp
         inner join trade_type on
    (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type and
                                                 platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code)
where platform_temp.token_all_flag = '1';
---------------volume_rank ALL_ALL_ALL_VOLUME_DEX_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct platform_large_category.platform_large_code             as project,
                'ALL'                                                   as token,
                trade_type.trade_type                                   as type,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vr' as label_type,
                'T'                                                     as operate_type,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vr'    seq_flag,
                'volume_rank'                                              data_subject,
                'ALL'                                                      project_name,
                'ALL'                                                      token_name,
                recent_time_temp.recent_time_code
from trade_type
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'RelationTeam'                                             "owner",
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vr' as "type",
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vr' ||
                level_def_temp.code                                     as "name",
                'SYSTEM'                                                   "source",
                'PUBLIC'                                                   visible_type,
                'TOTAL_PART'                                               strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                platform_large_category.platform_large_name || ' ' ||
                level_def_temp.level_name || ' ' ||
                (CASE WHEN trade_type.trade_type = 'ALL' THEN '' else trade_type.trade_type_name || ' ' end) ||
                'Trader'                                                   "content",
                'SQL'                                                      rule_type,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vr'    rule_group,
                'RESULT'                                                   value_type,
                999999                                                     run_order,
                now()                                                      created_at,
                0                                                          refresh_time,
                'DEFI'                                                     wired_type,
                999                                                        label_order,
                'WAITING'                                                  sync_es_status
from trade_type
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);
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
select distinct 'ALL_TOKEN'                                 asset,
                platform_large_category.platform_large_code project,
                trade_type.trade_type                       trade_type,
                ''                                          balance,
                level_def_temp.level                        volume,
                ''                                          activity,
                ''                                          hold_time,
                now()                                       created_at,
                recent_time_temp.code || '' || '' ||
                platform_large_category.code || trade_type.code || 'vr' ||
                level_def_temp.code                         label_name,
                'token'                                     asset_type,
                'RANK'                                      label_category,
                recent_time_code
from trade_type
         inner join (select *
                     from level_def_temp
                     where type = 'defi_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         inner join dex_action_platform_temp on (trade_type.trade_type = dex_action_platform_temp.trade_type)
         inner join platform_temp on (platform_temp.platform = dex_action_platform_temp.platform)
         inner join platform_large_category
                    on (platform_temp.platform_large_code = platform_large_category.platform_large_code);


----------------------------------dim_nft.sql--------------------------------------
--------------------NFT---------有211 但维度表有合并的204个而已------------------
--------balance_grade CryptoPunks_NFT_BALANCE_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''                                   project,
                address                              "token",
                ''                                   "type",
                ('n' || nft_sync_address.id) || 'bg' label_type,
                'T'                                  operate_type,
                nft_sync_address.name_for_label      seq_flag,
                'balance_grade'                      data_subject,
                null                                 project_name,
                nft_sync_address.platform            token_name
from public.nft_sync_address
where type <> 'ERC1155';

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
select distinct 'RelationTeam'                                                 "owner",
                ('n' || nft_sync_address.id) || 'bg'                        as "type",
                ('n' || nft_sync_address.id) || 'bg' || level_def_temp.code as "name",
                'SYSTEM'                                                       "source",
                'PUBLIC'                                                       visible_type,
                'TOTAL_PART'                                                   strategy,
                nft_sync_address.platform || ' ' || level_def_temp.level_name  "content",
                'SQL'                                                          rule_type,
                ('n' || nft_sync_address.id) || 'bg'                           rule_group,
                'RESULT'                                                       value_type,
                999999                                                         run_order,
                now()                                                          created_at,
                0                                                              refresh_time,
                'NFT'                                                          wired_type,
                999                                                            label_order,
                'WAITING'                                                      sync_es_status
from public.nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_balance_grade') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';
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
select distinct nft_sync_address.platform                                   asset,
                ''                                                          project,
                ''                                                          trade_type,
                level_def_temp.level                                        balance,
                ''                                                          volume,
                ''                                                          activity,
                ''                                                          hold_time,
                now()                                                       created_at,
                ('n' || nft_sync_address.id) || 'bg' || level_def_temp.code label_name,
                'nft'                                                       asset_type,
                'GRADE'                                                     label_category,
                'ALL'                                                       recent_time_code
from public.nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_balance_grade') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';


--------balance_grade ALL_NFT_BALANCE_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''              project,
                'ALL'           "token",
                ''              "type",
                'n' || 'bg'     label_type,
                'T'             operate_type,
                'ALL'           seq_flag,
                'balance_grade' data_subject,
                ''              project_name,
                'ALL'           token_name;
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
select distinct 'RelationTeam'                        "owner",
                'n' || 'bg'                        as "type",
                'n' || 'bg' || level_def_temp.code as "name",
                'SYSTEM'                              "source",
                'PUBLIC'                              visible_type,
                'TOTAL_PART'                          strategy,
                'NFT ' || level_def_temp.level_name   "content",
                'SQL'                                 rule_type,
                'n' || 'bg'                           rule_group,
                'RESULT'                              value_type,
                999999                                run_order,
                now()                                 created_at,
                0                                     refresh_time,
                'NFT'                                 wired_type,
                999                                   label_order,
                'WAITING'                             sync_es_status
from level_def_temp
where type = 'nft_balance_grade';
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
select distinct 'ALL_NFT'                          asset,
                ''                                 project,
                ''                                 trade_type,
                level_def_temp.level               balance,
                ''                                 volume,
                ''                                 activity,
                ''                                 hold_time,
                now()                              created_at,
                'n' || 'bg' || level_def_temp.code label_name,
                'nft'                              asset_type,
                'GRADE'                            label_category,
                'ALL'                              recent_time_code
from level_def_temp
where type = 'nft_balance_grade';


--------balance_rank CryptoPunks_NFT_BALANCE_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''                                   project,
                address                              "token",
                ''                                   "type",
                ('n' || nft_sync_address.id) || 'br' label_type,
                'T'                                  operate_type,
                nft_sync_address.name_for_label      seq_flag,
                'balance_rank'                       data_subject,
                null                                 project_name,
                nft_sync_address.platform            token_name
from public.nft_sync_address
where type <> 'ERC1155';

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
select distinct 'RelationTeam'                                                 "owner",
                ('n' || nft_sync_address.id) || 'br'                        as "type",
                ('n' || nft_sync_address.id) || 'br' || level_def_temp.code as "name",
                'SYSTEM'                                                       "source",
                'PUBLIC'                                                       visible_type,
                'TOTAL_PART'                                                   strategy,
                nft_sync_address.platform || ' ' || level_def_temp.level_name  "content",
                'SQL'                                                          rule_type,
                ('n' || nft_sync_address.id) || 'br'                           rule_group,
                'RESULT'                                                       value_type,
                999999                                                         run_order,
                now()                                                          created_at,
                0                                                              refresh_time,
                'NFT'                                                          wired_type,
                999                                                            label_order,
                'WAITING'                                                      sync_es_status
from public.nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_balance_rank') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';
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
select distinct nft_sync_address.platform                                   asset,
                ''                                                          project,
                ''                                                          trade_type,
                level_def_temp.level                                        balance,
                ''                                                          volume,
                ''                                                          activity,
                ''                                                          hold_time,
                now()                                                       created_at,
                ('n' || nft_sync_address.id) || 'br' || level_def_temp.code label_name,
                'nft'                                                       asset_type,
                'RANK'                                                      label_category,
                'ALL'                                                       recent_time_code
from public.nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_balance_rank') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';

--------balance_rank ALL_NFT_BALANCE_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''             project,
                'ALL'          "token",
                ''             "type",
                'n' || 'br'    label_type,
                'T'            operate_type,
                'ALL'          seq_flag,
                'balance_rank' data_subject,
                ''             project_name,
                'ALL'          token_name;
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
select distinct 'RelationTeam'                        "owner",
                'n' || 'br'                        as "type",
                'n' || 'br' || level_def_temp.code as "name",
                'SYSTEM'                              "source",
                'PUBLIC'                              visible_type,
                'TOTAL_PART'                          strategy,
                'NFT ' || level_def_temp.level_name   "content",
                'SQL'                                 rule_type,
                'n' || 'br'                           rule_group,
                'RESULT'                              value_type,
                999999                                run_order,
                now()                                 created_at,
                0                                     refresh_time,
                'NFT'                                 wired_type,
                999                                   label_order,
                'WAITING'                             sync_es_status
from level_def_temp
where type = 'nft_balance_rank';
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
select distinct 'ALL_NFT'                          asset,
                ''                                 project,
                ''                                 trade_type,
                level_def_temp.level               balance,
                ''                                 volume,
                ''                                 activity,
                ''                                 hold_time,
                now()                              created_at,
                'n' || 'br' || level_def_temp.code label_name,
                'nft'                              asset_type,
                'RANK'                             label_category,
                'ALL'                              recent_time_code
from level_def_temp
where type = 'nft_balance_rank';

--------balance_top CryptoPunks_NFT_BALANCE_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''                                   project,
                address                              "token",
                ''                                   "type",
                ('n' || nft_sync_address.id) || 'bt' label_type,
                'T'                                  operate_type,
                nft_sync_address.name_for_label      seq_flag,
                'balance_top'                        data_subject,
                null                                 project_name,
                nft_sync_address.platform            token_name
from public.nft_sync_address
where type <> 'ERC1155';

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
select distinct 'RelationTeam'                                                 "owner",
                ('n' || nft_sync_address.id) || 'bt'                        as "type",
                ('n' || nft_sync_address.id) || 'bt' || level_def_temp.code as "name",
                'SYSTEM'                                                       "source",
                'PUBLIC'                                                       visible_type,
                'TOTAL_PART'                                                   strategy,
                nft_sync_address.platform || ' ' || level_def_temp.level_name  "content",
                'SQL'                                                          rule_type,
                ('n' || nft_sync_address.id) || 'bt'                           rule_group,
                'RESULT'                                                       value_type,
                999999                                                         run_order,
                now()                                                          created_at,
                0                                                              refresh_time,
                'NFT'                                                          wired_type,
                999                                                            label_order,
                'WAITING'                                                      sync_es_status
from public.nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_balance_top') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';
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
select distinct nft_sync_address.platform                                   asset,
                ''                                                          project,
                ''                                                          trade_type,
                level_def_temp.level                                        balance,
                ''                                                          volume,
                ''                                                          activity,
                ''                                                          hold_time,
                now()                                                       created_at,
                ('n' || nft_sync_address.id) || 'bt' || level_def_temp.code label_name,
                'nft'                                                       asset_type,
                'TOP'                                                       label_category,
                'ALL'                                                       recent_time_code
from public.nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_balance_top') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';


--------balance_top ALL_NFT_BALANCE_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''            project,
                'ALL'         "token",
                ''            "type",
                'n' || 'bt'   label_type,
                'T'           operate_type,
                'ALL'         seq_flag,
                'balance_top' data_subject,
                ''            project_name,
                'ALL'         token_name;
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
select distinct 'RelationTeam'                        "owner",
                'n' || 'bt'                        as "type",
                'n' || 'bt' || level_def_temp.code as "name",
                'SYSTEM'                              "source",
                'PUBLIC'                              visible_type,
                'TOTAL_PART'                          strategy,
                'NFT ' || level_def_temp.level_name   "content",
                'SQL'                                 rule_type,
                'n' || 'bt'                           rule_group,
                'RESULT'                              value_type,
                999999                                run_order,
                now()                                 created_at,
                0                                     refresh_time,
                'NFT'                                 wired_type,
                999                                   label_order,
                'WAITING'                             sync_es_status
from level_def_temp
where type = 'nft_balance_top';
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
select distinct 'ALL_NFT'                           asset,
                ''                                  project,
                ''                                  trade_type,
                level_def_temp.level                balance,
                ''                                  volume,
                ''                                  activity,
                ''                                  hold_time,
                now()                               created_at,
                'n' || 'bt' || level_def_temp.code  label_name,
                'nft'                               asset_type,
                'TOP'                               label_category,
                'ALL'                               recent_time_code
from level_def_temp
where type = 'nft_balance_top';

--------count ALL_CryptoPunks_ALL_NFT_ACTIVITY
-- ALL_CryptoPunks_Transfer_NFT_ACTIVITY
-- ALL_CryptoPunks_Mint_NFT_ACTIVITY
-- ALL_CryptoPunks_Sale_NFT_ACTIVITY
-- ALL_CryptoPunks_Burn_NFT_ACTIVITY
-- ALL_CryptoPunks_Buy_NFT_ACTIVITY
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                                                        project,
                nft_sync_address.address                                                                  "token",
                nft_trade_type_temp.nft_trade_type                                                        "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'cg' label_type,
                'T'                                                                                       operate_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'cg' seq_flag,
                'count'                                                                                   data_subject,
                'ALL'                                                                                     project_name,
                nft_sync_address.platform                                                                 token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                                               "owner",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'cg' as "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code                                                                       as "name",
                'SYSTEM'                                                                                     "source",
                'PUBLIC'                                                                                     visible_type,
                'TOTAL_PART'                                                                                 strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                nft_sync_address.platform ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag is null
                         then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag = '1' then
                                replace(level_def_temp.level_name, ' ',
                                        ' ' || nft_trade_type_temp.nft_trade_type_name || ' ')
                            else level_def_temp.level_name end) || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then ''
                     when nft_trade_type_temp.nft_trade_type = 'ALL' then ''
                     else nft_trade_type_temp.nft_trade_type_name end)                                       "content",
                'SQL'                                                                                        rule_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'cg'    rule_group,
                'RESULT'                                                                                     value_type,
                999999                                                                                       run_order,
                now()                                                                                        created_at,
                0                                                                                            refresh_time,
                'NFT'                                                                                        wired_type,
                999                                                                                          label_order,
                'WAITING'                                                                                    sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct nft_sync_address.platform                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                ''                                              volume,
                level_def_temp.level                            activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'GRADE'                                         label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';



--------count ALL_ALL_ALL_NFT_ACTIVITY
-- ALL_ALL_Transfer_NFT_ACTIVITY
-- ALL_ALL_Mint_NFT_ACTIVITY
-- ALL_ALL_Sale_NFT_ACTIVITY
-- ALL_ALL_Burn_NFT_ACTIVITY
-- ALL_ALL_Buy_NFT_ACTIVITY
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                               project,
                'ALL'                                                            "token",
                nft_trade_type_temp.nft_trade_type                               "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'cg' label_type,
                'T'                                                              operate_type,
                recent_time_temp.recent_time_name ||
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'cg' seq_flag,
                'count'                                                          data_subject,
                ''                                                               project_name,
                'ALL'                                                            token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                      "owner",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'cg' as "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code                                              as "name",
                'SYSTEM'                                                            "source",
                'PUBLIC'                                                            visible_type,
                'TOTAL_PART'                                                        strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) || 'NFT ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag is null
                         then
                             (case
                                  when nft_trade_type_temp.nft_trade_type_name = 'Bid' or
                                       nft_trade_type_temp.nft_trade_type_name = 'Lend'
                                      then 'Blur:'
                                  else '' end) || nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' and level_def_temp.special_flag = '1' then
                                replace(level_def_temp.level_name, ' ', ' ' ||
                                                                        (case
                                                                             when nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Bid' or
                                                                                  nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Lend'
                                                                                 then 'Blur:'
                                                                             else '' end) ||
                                                                        nft_trade_type_temp.nft_trade_type_name || ' ')
                            else level_def_temp.level_name end) || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then ''
                     when nft_trade_type_temp.nft_trade_type = 'ALL' then ''
                     else nft_trade_type_temp.nft_trade_type_name end)              "content",
                'SQL'                                                               rule_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'cg'    rule_group,
                'RESULT'                                                            value_type,
                999999                                                              run_order,
                now()                                                               created_at,
                0                                                                   refresh_time,
                'NFT'                                                               wired_type,
                999                                                                 label_order,
                'WAITING'                                                           sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'ALL_NFT'                                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                ''                                              volume,
                level_def_temp.level                            activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'cg' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'GRADE'                                         label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_count') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';

--------time_grade CryptoPunks_NFT_TIME_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''                                   project,
                address                              "token",
                ''                                   "type",
                ('n' || nft_sync_address.id) || 'tg' label_type,
                'T'                                  operate_type,
                nft_sync_address.name_for_label      seq_flag,
                'time_grade'                         data_subject,
                null                                 project_name,
                nft_sync_address.platform            token_name
from public.nft_sync_address
where nft_sync_address.type <> 'ERC1155';
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
select distinct 'RelationTeam'                                                 "owner",
                ('n' || nft_sync_address.id) || 'tg'                        as "type",
                ('n' || nft_sync_address.id) || 'tg' || level_def_temp.code as "name",
                'SYSTEM'                                                       "source",
                'PUBLIC'                                                       visible_type,
                'TOTAL_PART'                                                   strategy,
                nft_sync_address.platform || ' ' || level_def_temp.level_name  "content",
                'SQL'                                                          rule_type,
                ('n' || nft_sync_address.id) || 'tg'                           rule_group,
                'RESULT'                                                       value_type,
                999999                                                         run_order,
                now()                                                          created_at,
                0                                                              refresh_time,
                'NFT'                                                          wired_type,
                999                                                            label_order,
                'WAITING'                                                      sync_es_status
from nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_time_grade') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';
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
select distinct nft_sync_address.platform                                   asset,
                ''                                                          project,
                ''                                                          trade_type,
                ''                                                          balance,
                ''                                                          volume,
                ''                                                          activity,
                level_def_temp.level                                        hold_time,
                now()                                                       created_at,
                ('n' || nft_sync_address.id) || 'tg' || level_def_temp.code label_name,
                'nft'                                                       asset_type,
                'GRADE'                                                     label_category,
                'ALL'                                                       recent_time_code
from nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_time_grade') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';

--------time_rank CryptoPunks_NFT_TIME_SMART_NFT_EARLY_ADOPTER
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''                                   project,
                address                              "token",
                ''                                   "type",
                ('n' || nft_sync_address.id) || 'ea' label_type,
                'T'                                  operate_type,
                nft_sync_address.name_for_label      seq_flag,
                'time_rank'                          data_subject,
                null                                 project_name,
                nft_sync_address.platform            token_name
from public.nft_sync_address
where nft_sync_address.type <> 'ERC1155';
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
select distinct 'RelationTeam'                                                "owner",
                ('n' || nft_sync_address.id) || 'ea' as                       "type",
                ('n' || nft_sync_address.id) || 'ea' as                       "name",
                'SYSTEM'                                                      "source",
                'PUBLIC'                                                      visible_type,
                'TOTAL_PART'                                                  strategy,
                nft_sync_address.platform || ' ' || level_def_temp.level_name "content",
                'SQL'                                                         rule_type,
                ('n' || nft_sync_address.id) || 'ea'                          rule_group,
                'RESULT'                                                      value_type,
                999999                                                        run_order,
                now()                                                         created_at,
                0                                                             refresh_time,
                'NFT'                                                         wired_type,
                999                                                           label_order,
                'WAITING'                                                     sync_es_status
from nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_time_rank') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';
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
select distinct nft_sync_address.platform            asset,
                ''                                   project,
                ''                                   trade_type,
                ''                                   balance,
                ''                                   volume,
                ''                                   activity,
                'SMART_NFT_EARLY_ADOPTER'            hold_time,
                now()                                created_at,
                ('n' || nft_sync_address.id) || 'ea' label_name,
                'nft'                                asset_type,
                'RANK'                               label_category,
                'ALL'                                recent_time_code
from nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_time_rank') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';

--------time_special CryptoPunks_NFT_TIME_SPECIAL
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''                                   project,
                address                              "token",
                ''                                   "type",
                ('n' || nft_sync_address.id) || 'ts' label_type,
                'T'                                  operate_type,
                nft_sync_address.name_for_label      seq_flag,
                'time_special'                       data_subject,
                null                                 project_name,
                nft_sync_address.platform            token_name
from public.nft_sync_address
where nft_sync_address.type <> 'ERC1155';
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
select distinct 'RelationTeam'                                                 "owner",
                ('n' || nft_sync_address.id) || 'ts'                        as "type",
                ('n' || nft_sync_address.id) || 'ts' || level_def_temp.code as "name",
                'SYSTEM'                                                       "source",
                'PUBLIC'                                                       visible_type,
                'TOTAL_PART'                                                   strategy,
                nft_sync_address.platform || ' ' || level_def_temp.level_name  "content",
                'SQL'                                                          rule_type,
                ('n' || nft_sync_address.id) || 'ts'                           rule_group,
                'RESULT'                                                       value_type,
                999999                                                         run_order,
                now()                                                          created_at,
                0                                                              refresh_time,
                'NFT'                                                          wired_type,
                999                                                            label_order,
                'WAITING'                                                      sync_es_status
from nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_time_special') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';

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
select distinct nft_sync_address.platform                                   asset,
                ''                                                          project,
                ''                                                          trade_type,
                ''                                                          balance,
                ''                                                          volume,
                ''                                                          activity,
                level_def_temp.level                                        hold_time,
                now()                                                       created_at,
                ('n' || nft_sync_address.id) || 'ts' || level_def_temp.code label_name,
                'nft'                                                       asset_type,
                'SPECIAL'                                                   label_category,
                'ALL'                                                       recent_time_code
from nft_sync_address
         inner join (select *
                     from level_def_temp
                     where type = 'nft_time_special') level_def_temp on
    (1 = 1)
where nft_sync_address.type <> 'ERC1155';

--------volume_elite ALL_CryptoPunks_ALL_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Mint_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Sale_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Burn_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Buy_NFT_VOLUME_ELITE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                                                        project,
                nft_sync_address.address                                                                  "token",
                nft_trade_type_temp.nft_trade_type                                                        "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 've' label_type,
                'T'                                                                                       operate_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 've' seq_flag,
                'volume_elite'                                                                            data_subject,
                'ALL'                                                                                     project_name,
                nft_sync_address.platform                                                                 token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                                               "owner",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 've' as "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 've' ||
                level_def_temp.code                                                                       as "name",
                'SYSTEM'                                                                                     "source",
                'PUBLIC'                                                                                     visible_type,
                'TOTAL_PART'                                                                                 strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                nft_sync_address.platform ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end)                                "content",
                'SQL'                                                                                        rule_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 've'    rule_group,
                'RESULT'                                                                                     value_type,
                999999                                                                                       run_order,
                now()                                                                                        created_at,
                0                                                                                            refresh_time,
                'NFT'                                                                                        wired_type,
                999                                                                                          label_order,
                'WAITING'                                                                                    sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct nft_sync_address.platform                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 've' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'ELITE'                                         label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';


--------volume_elite ALL_ALL_ALL_NFT_VOLUME_ELITE
-- ALL_ALL_Transfer_NFT_VOLUME_ELITE
-- ALL_ALL_Mint_NFT_VOLUME_ELITE
-- ALL_ALL_Sale_NFT_VOLUME_ELITE
-- ALL_ALL_Burn_NFT_VOLUME_ELITE
-- ALL_ALL_Buy_NFT_VOLUME_ELITE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                               project,
                'ALL'                                                            "token",
                nft_trade_type_temp.nft_trade_type                               "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 've' label_type,
                'T'                                                              operate_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 've' seq_flag,
                'volume_elite'                                                   data_subject,
                ''                                                               project_name,
                'ALL'                                                            token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                              "owner",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 've' as         "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 've' ||
                level_def_temp.code                                              as         "name",
                'SYSTEM'                                                                    "source",
                'PUBLIC'                                                                    visible_type,
                'TOTAL_PART'                                                                strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                'NFT ' ||
                level_def_temp.level_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then (case
                                                                             when nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Bid' or
                                                                                  nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Lend'
                                                                                 then 'Blur:'
                                                                             else '' end) ||
                                                                        nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else (case
                               when nft_trade_type_temp.nft_trade_type_name = 'Bid' or
                                    nft_trade_type_temp.nft_trade_type_name = 'Lend'
                                   then 'Blur:'
                               else '' end) || nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                                       rule_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 've'            rule_group,
                'RESULT'                                                                    value_type,
                999999                                                                      run_order,
                now()                                                                       created_at,
                0                                                                           refresh_time,
                'NFT'                                                                       wired_type,
                999                                                                         label_order,
                'WAITING'                                                                   sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'ALL_NFT'                                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 've' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'ELITE'                                         label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_elite') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';

--------volume_grade ALL_CryptoPunks_ALL_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Mint_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Sale_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Burn_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Buy_NFT_VOLUME_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                                                        project,
                nft_sync_address.address                                                                  "token",
                nft_trade_type_temp.nft_trade_type                                                        "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vg' label_type,
                'T'                                                                                       operate_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vg' seq_flag,
                'volume_grade'                                                                            data_subject,
                'ALL'                                                                                     project_name,
                nft_sync_address.platform                                                                 token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                                               "owner",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vg' as "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code                                                                       as "name",
                'SYSTEM'                                                                                     "source",
                'PUBLIC'                                                                                     visible_type,
                'TOTAL_PART'                                                                                 strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                nft_sync_address.platform ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                level_def_temp.level_name ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then ''
                     when nft_trade_type_temp.nft_trade_type = 'ALL' then 'Trader'
                     else nft_trade_type_temp.nft_trade_type_name end)                                       "content",
                'SQL'                                                                                        rule_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vg'    rule_group,
                'RESULT'                                                                                     value_type,
                999999                                                                                       run_order,
                now()                                                                                        created_at,
                0                                                                                            refresh_time,
                'NFT'                                                                                        wired_type,
                999                                                                                          label_order,
                'WAITING'                                                                                    sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct nft_sync_address.platform                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'GRADE'                                         label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';


--------volume_grade ALL_ALL_ALL_NFT_VOLUME_GRADE
-- ALL_ALL_Transfer_NFT_VOLUME_GRADE
-- ALL_ALL_Mint_NFT_VOLUME_GRADE
-- ALL_ALL_Sale_NFT_VOLUME_GRADE
-- ALL_ALL_Burn_NFT_VOLUME_GRADE
-- ALL_ALL_Buy_NFT_VOLUME_GRADE
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                               project,
                'ALL'                                                            "token",
                nft_trade_type_temp.nft_trade_type                               "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vg' label_type,
                'T'                                                              operate_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vg' seq_flag,
                'volume_grade'                                                   data_subject,
                ''                                                               project_name,
                'ALL'                                                            token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                              "owner",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vg' as         "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code                                              as         "name",
                'SYSTEM'                                                                    "source",
                'PUBLIC'                                                                    visible_type,
                'TOTAL_PART'                                                                strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                'NFT ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then (case
                                                                             when nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Bid' or
                                                                                  nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Lend'
                                                                                 then 'Blur:'
                                                                             else '' end) ||
                                                                        nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                level_def_temp.level_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else (case
                               when nft_trade_type_temp.nft_trade_type_name = 'Bid' or
                                    nft_trade_type_temp.nft_trade_type_name = 'Lend'
                                   then 'Blur:'
                               else '' end) || nft_trade_type_temp.nft_trade_type_name end) "content",
                'SQL'                                                                       rule_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vg'            rule_group,
                'RESULT'                                                                    value_type,
                999999                                                                      run_order,
                now()                                                                       created_at,
                0                                                                           refresh_time,
                'NFT'                                                                       wired_type,
                999                                                                         label_order,
                'WAITING'                                                                   sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'ALL_NFT'                                                         asset,
                ''                                                                project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END                   trade_type,
                ''                                                                balance,
                level_def_temp.level                                              volume,
                ''                                                                activity,
                ''                                                                hold_time,
                now()                                                             created_at,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vg' ||
                level_def_temp.code                                               label_name,
                'nft'                                                             asset_type,
                'GRADE'                                                           label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_grade') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';

--------volume_rank ALL_CryptoPunks_ALL_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Mint_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Sale_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Burn_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Buy_NFT_VOLUME_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name)
select distinct ''                                                                                        project,
                nft_sync_address.address                                                                  "token",
                nft_trade_type_temp.nft_trade_type                                                        "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vr' label_type,
                'T'                                                                                       operate_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vr' seq_flag,
                'volume_rank'                                                                             data_subject,
                'ALL'                                                                                     project_name,
                nft_sync_address.platform                                                                 token_name
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                                               "owner",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vr' as "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                                                                       as "name",
                'SYSTEM'                                                                                     "source",
                'PUBLIC'                                                                                     visible_type,
                'TOTAL_PART'                                                                                 strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                nft_sync_address.platform ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end)                                "content",
                'SQL'                                                                                        rule_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vr'    rule_group,
                'RESULT'                                                                                     value_type,
                999999                                                                                       run_order,
                now()                                                                                        created_at,
                0                                                                                            refresh_time,
                'NFT'                                                                                        wired_type,
                999                                                                                          label_order,
                'WAITING'                                                                                    sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct nft_sync_address.platform                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'RANK'                                          label_category,
                'ALL'                                           recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';

--------volume_rank ALL_ALL_ALL_NFT_VOLUME_RANK
-- ALL_ALL_Transfer_NFT_VOLUME_RANK
-- ALL_ALL_Mint_NFT_VOLUME_RANK
-- ALL_ALL_Sale_NFT_VOLUME_RANK
-- ALL_ALL_Burn_NFT_VOLUME_RANK
-- ALL_ALL_Buy_NFT_VOLUME_RANK
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                               project,
                'ALL'                                                            "token",
                nft_trade_type_temp.nft_trade_type                               "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vr' label_type,
                'T'                                                              operate_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vr' seq_flag,
                'volume_rank'                                                    data_subject,
                ''                                                               project_name,
                'ALL'                                                            token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                      "owner",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vr' as "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                                              as "name",
                'SYSTEM'                                                            "source",
                'PUBLIC'                                                            visible_type,
                'TOTAL_PART'                                                        strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                'NFT ' ||
                level_def_temp.level_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then (case
                                                                             when nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Bid' or
                                                                                  nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Lend'
                                                                                 then 'Blur:'
                                                                             else '' end) ||
                                                                        nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else (case
                               when nft_trade_type_temp.nft_trade_type_name = 'Bid' or
                                    nft_trade_type_temp.nft_trade_type_name = 'Lend'
                                   then 'Blur:'
                               else '' end) ||
                          nft_trade_type_temp.nft_trade_type_name end)              "content",
                'SQL'                                                               rule_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vr'    rule_group,
                'RESULT'                                                            value_type,
                999999                                                              run_order,
                now()                                                               created_at,
                0                                                                   refresh_time,
                'NFT'                                                               wired_type,
                999                                                                 label_order,
                'WAITING'                                                           sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'ALL_NFT'                                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vr' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'RANK'                                          label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_rank') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';

--------volume_top ALL_CryptoPunks_ALL_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Mint_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Sale_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Burn_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Buy_NFT_VOLUME_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                                                        project,
                nft_sync_address.address                                                                  "token",
                nft_trade_type_temp.nft_trade_type                                                        "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vt' label_type,
                'T'                                                                                       operate_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vt' seq_flag,
                'volume_top'                                                                              data_subject,
                'ALL'                                                                                     project_name,
                nft_sync_address.platform                                                                 token_name,
                recent_time_temp.recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                                               "owner",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vt' as "type",
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                                                                       as "name",
                'SYSTEM'                                                                                     "source",
                'PUBLIC'                                                                                     visible_type,
                'TOTAL_PART'                                                                                 strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                nft_sync_address.platform ||
                ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token'
                         then level_def_temp.level_name || ' ' || nft_trade_type_temp.nft_trade_type_name || ' '
                     else level_def_temp.level_name || ' ' end)
                    || (case
                            when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                                then 'Trader'
                            else nft_trade_type_temp.nft_trade_type_name end)                                "content",
                'SQL'                                                                                        rule_type,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vt'    rule_group,
                'RESULT'                                                                                     value_type,
                999999                                                                                       run_order,
                now()                                                                                        created_at,
                0                                                                                            refresh_time,
                'NFT'                                                                                        wired_type,
                999                                                                                          label_order,
                'WAITING'                                                                                    sync_es_status
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';
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
select distinct nft_sync_address.platform                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || ('n' || nft_sync_address.id) || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'TOP'                                           label_category,
                recent_time_code
from nft_sync_address
         inner join nft_trade_type_temp on (1 = 1)
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
         INNER JOIN nft_action_platform_temp ON
    (nft_trade_type_temp.nft_trade_type = nft_action_platform_temp.nft_trade_type
        and nft_action_platform_temp.token = nft_sync_address.address)
where nft_sync_address.type <> 'ERC1155'
  and nft_trade_type_temp.type = '0';

--------volume_top ALL_ALL_ALL_NFT_VOLUME_TOP
-- ALL_ALL_Transfer_NFT_VOLUME_TOP
-- ALL_ALL_Mint_NFT_VOLUME_TOP
-- ALL_ALL_Sale_NFT_VOLUME_TOP
-- ALL_ALL_Burn_NFT_VOLUME_TOP
-- ALL_ALL_Buy_NFT_VOLUME_TOP
insert
into dim_project_token_type_temp (project,
                                  "token",
                                  "type",
                                  label_type,
                                  operate_type,
                                  seq_flag,
                                  data_subject,
                                  project_name,
                                  token_name,
                                  recent_code)
select distinct ''                                                               project,
                'ALL'                                                            "token",
                nft_trade_type_temp.nft_trade_type                               "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vt' label_type,
                'T'                                                              operate_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vt' seq_flag,
                'volume_top'                                                     data_subject,
                ''                                                               project_name,
                'ALL'                                                            token_name,
                recent_time_temp.recent_time_code
from nft_trade_type_temp
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'RelationTeam'                                                      "owner",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vt' as "type",
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                                              as "name",
                'SYSTEM'                                                            "source",
                'PUBLIC'                                                            visible_type,
                'TOTAL_PART'                                                        strategy,
                recent_time_temp.recent_time_content ||
                (case when recent_time_temp.recent_time_content <> '' then ' ' else '' end) ||
                'NFT ' ||
                level_def_temp.level_name || ' ' ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' then (case
                                                                             when nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Bid' or
                                                                                  nft_trade_type_temp.nft_trade_type_name =
                                                                                  'Lend'
                                                                                 then 'Blur:'
                                                                             else '' end) ||
                                                                        nft_trade_type_temp.nft_trade_type_name || ' '
                     else '' end) ||
                (case
                     when nft_trade_type_temp.asset_type = 'token' or nft_trade_type_temp.nft_trade_type = 'ALL'
                         then 'Trader'
                     else (case
                               when nft_trade_type_temp.nft_trade_type_name = 'Bid' or
                                    nft_trade_type_temp.nft_trade_type_name = 'Lend'
                                   then 'Blur:'
                               else '' end) ||
                          nft_trade_type_temp.nft_trade_type_name end)              "content",
                'SQL'                                                               rule_type,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vt'    rule_group,
                'RESULT'                                                            value_type,
                999999                                                              run_order,
                now()                                                               created_at,
                0                                                                   refresh_time,
                'NFT'                                                               wired_type,
                999                                                                 label_order,
                'WAITING'                                                           sync_es_status
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';
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
select distinct 'ALL_NFT'                                       asset,
                ''                                              project,
                case
                    when nft_trade_type_temp.nft_trade_type = 'ALL' THEN ''
                    ELSE nft_trade_type_temp.nft_trade_type END trade_type,
                ''                                              balance,
                level_def_temp.level                            volume,
                ''                                              activity,
                ''                                              hold_time,
                now()                                           created_at,
                recent_time_temp.code || 'n' || nft_trade_type_temp.code || 'vt' ||
                level_def_temp.code                             label_name,
                'nft'                                           asset_type,
                'TOP'                                           label_category,
                recent_time_code
from nft_trade_type_temp
         inner join (select *
                     from level_def_temp
                     where type = 'nft_volume_top') level_def_temp on
    (1 = 1)
         inner join recent_time_temp on (1 = 1)
where nft_trade_type_temp.type = '0';

insert into dim_project_token_type_rank_temp(token_id, project)
select distinct token, project
from dim_project_token_type_temp;
insert into tag_result(table_name, batch_date)
SELECT 'dim_project_token_type' as table_name, '${batchDate}' as batch_date;
