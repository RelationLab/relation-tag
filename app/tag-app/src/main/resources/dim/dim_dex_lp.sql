-----FIRST_MOVER_LP  Uniswap_v2_UNI/WETH_0xd3d2_HOLDING_TIME_FIRST_MOVER_LP
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)

select
    platform_detail.platform as project,
    lpt.pool as token,
    'lp' as type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_LP' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'FIRST_MOVER_LP' data_subject,
    lpt.factory_type project_name,
    lpt.symbol_wired token_name
from
    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_LP' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_LP' as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
     lpt.factory_content||' '||symbol_wired||' First Mover LP'  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_LP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    (select wlp.name,
    wlp.symbol_wired,
    wlp.address as pool,
    wlp.factory,
    wlp.factory_type,
    wlp.factory_content,
    wlp.pool_id,
    wlp.symbols[1] as symbol1,
    wlp.symbols[2] as symbol2,
    wlp.type,
    wlp.tokens,
    wlp.decimals,
    wlp.price,
    wlp.tvl,
    wlp.fee as fee,
    SUBSTR(wlp.address, 1, 6) as poolPrefix,
    wlp.total_supply,
    wslp.factory AS stakePool,
    wslp.factory_type as stakeRouter
from white_list_lp wlp
    left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
where wlp.tvl > 5000000
  and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
  and wlp."type" = 'LP') lpt
    inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    (lpt.symbol1||'/'||lpt.symbol2) asset,
    lpt.factory_content project,
    '' trade_type,
    '' balance,
    '' volume,
    '' activity,
    'FIRST_MOVER_LP' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_LP'  label_name,
    lpt.factory_content||' '||symbol_wired||' First Mover LP' "content",
    'token' asset_type,
    'TOP' label_category
from

    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
  and wlp."type" = 'LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);

-----HEAVY_LP  Uniswap_v2_UNI/WETH_0xd3d2_BALANCE_HEAVY_LP
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)

select
    platform_detail.platform as project,
    lpt.pool as token,
    'lp' as type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_HEAVY_LP' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'FIRST_MOVER_LP' data_subject,
    lpt.factory_type project_name,
    lpt.symbol_wired token_name
from
    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'HEAVY_LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_HEAVY_LP' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_HEAVY_LP' as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' Heavy LP'  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_HEAVY_LP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    (lpt.symbol1||'/'||lpt.symbol2) asset,
    lpt.factory_content project,
    '' trade_type,
    'HEAVY_LP' balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_HEAVY_LP'  label_name,
    lpt.factory_content||' '||symbol_wired||' Heavy LP' "content",
    'token' asset_type,
    'TOP' label_category
from
    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);

-----FIRST_MOVER_STAKING Sushiswap_SYN/WETH_0x4a86_BALANCE_FIRST_MOVER_STAKING
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)

select
    platform_detail.platform as project,
    lpt.pool as token,
    'lp' as type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_STAKING' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_stake' seq_flag,
    'FIRST_MOVER_STAKING' data_subject,
    lpt.factory_type project_name,
    lpt.symbol_wired token_name
from
    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'HEAVY_LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_STAKING' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_STAKING' as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' First Mover Staking'  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_STAKING' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP' and wlp.factory_type='Sushiswap' ) lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    (lpt.symbol1||'/'||lpt.symbol2) asset,
    lpt.factory_content project,
    '' trade_type,
    '' balance,
    '' volume,
    '' activity,
    'FIRST_MOVER_STAKING' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HOLDING_TIME_FIRST_MOVER_STAKING'  label_name,
    lpt.factory_content||' '||symbol_wired||' First Mover Staking' "content",
    'token' asset_type,
    'TOP' label_category
from
    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);


-----HEAVY_LP_STAKER Sushiswap_SYN/WETH_0x4a86_BALANCE_HEAVY_LP_STAKER
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)

select
    platform_detail.platform as project,
    lpt.pool as token,
    'lp' as type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HEAVY_LP_STAKER' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_stake' seq_flag,
    'HEAVY_LP_STAKER' data_subject,
    lpt.factory_type project_name,
    lpt.symbol_wired token_name
from
    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'HEAVY_LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HEAVY_LP_STAKER' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HEAVY_LP_STAKER' as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' Heavy LP Staker'  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HEAVY_LP_STAKER' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP' and wlp.factory_type='Sushiswap' ) lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);
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
    (lpt.symbol1||'/'||lpt.symbol2) asset,
    lpt.factory_content project,
    '' trade_type,
    '' balance,
    '' volume,
    '' activity,
    'HEAVY_LP_STAKER' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_HEAVY_LP_STAKER'  label_name,
    lpt.factory_content||' '||symbol_wired||' Heavy LP Staker' "content",
    'token' asset_type,
    'TOP' label_category
from
    (select wlp.name,
            wlp.symbol_wired,
            wlp.address as pool,
            wlp.factory,
            wlp.factory_type,
            wlp.factory_content,
            wlp.pool_id,
            wlp.symbols[1] as symbol1,
            wlp.symbols[2] as symbol2,
            wlp.type,
            wlp.tokens,
            wlp.decimals,
            wlp.price,
            wlp.tvl,
            wlp.fee as fee,
            SUBSTR(wlp.address, 1, 6) as poolPrefix,
            wlp.total_supply,
            wslp.factory AS stakePool,
            wslp.factory_type as stakeRouter
     from white_list_lp wlp
              left join white_list_lp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
     where wlp.tvl > 5000000
       and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP') lpt
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name);