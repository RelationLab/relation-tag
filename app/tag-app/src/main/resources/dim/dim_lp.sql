-----balance_grade  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_GRADE
insert
into
    dim_rule_content ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,token_type)

select
    lpt.pool as token,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_GRADE' as label_type,
    'T' as operate_type,
    'balance_grade' data_subject,
    lpt.symbol_wired token_name,
    'lp' as token_type
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_GRADE' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_GRADE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_GRADE' rule_group,
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_grade') level_def on
        (1 = 1);
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
    lpt.factory_type project,
    '' trade_type,
    level_def.level balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_GRADE_'||level_def.level  label_name,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name "content",
    'token' asset_type,
    'GRADE' label_category
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_grade') level_def on
        (1 = 1);


-----balance_rank  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_RANK
insert
into
    dim_rule_content ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,token_type)

select
    lpt.pool as token,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_RANK' as label_type,
    'T' as operate_type,
    'balance_rank' data_subject,
    lpt.symbol_wired token_name,
    'lp' as token_type
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_RANK' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_RANK_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_RANK' rule_group,
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_rank') level_def on
        (1 = 1);
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
    lpt.factory_type project,
    '' trade_type,
    level_def.level balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_RANK_'||level_def.level  label_name,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'token' asset_type,
    'RANK' label_category
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_rank') level_def on
        (1 = 1);

-----balance_top  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_TOP
insert
into
    dim_rule_content ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,token_type)

select
    lpt.pool as token,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_TOP' as label_type,
    'T' as operate_type,
    'balance_top' data_subject,
    lpt.symbol_wired token_name,
    'lp' as token_type
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_TOP' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_TOP_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_TOP' rule_group,
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_top') level_def on
        (1 = 1);
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
    lpt.factory_type project,
    '' trade_type,
    level_def.level balance,
    '' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_BALANCE_TOP_'||level_def.level  label_name,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_balance_top') level_def on
        (1 = 1);


-----count  Uniswap_v3_UNI/WETH_0x1d42_ACTIVITY
insert
into
    dim_rule_content ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,token_type)

select
    lpt.pool as token,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_ACTIVITY' as label_type,
    'T' as operate_type,
    'count' data_subject,
    lpt.symbol_wired token_name,
    'lp' as token_type
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_ACTIVITY' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_ACTIVITY_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_ACTIVITY' rule_group,
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_count') level_def on
        (1 = 1);
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
    lpt.factory_type project,
    '' trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_ACTIVITY_'||level_def.level  label_name,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'token' asset_type,
    'GRADE' label_category
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_count') level_def on
        (1 = 1);

-----volume_grade  Uniswap_v3_UNI/WETH_0x1d42_VOLUME_GRADE
insert
into
    dim_rule_content ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,token_type)

select
    lpt.pool as token,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_GRADE' as label_type,
    'T' as operate_type,
    'volume_grade' data_subject,
    lpt.symbol_wired token_name,
    'lp' as token_type
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_GRADE' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_GRADE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_GRADE' rule_group,
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_volume_grade') level_def on
        (1 = 1);
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
    lpt.factory_type project,
    '' trade_type,
    '' balance,
    level_def.level  volume,
    '' activity,
    '' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_GRADE_'||level_def.level label_name,
    lpt.factory_content||' '||symbol_wired|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||level_def.level_name   "content",
    'token' asset_type,
    'GRADE' label_category
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_volume_grade') level_def on
        (1 = 1);

-----volume_rank  Uniswap_v3_UNI/WETH_0x1d42_VOLUME_RANK
insert
into
    dim_rule_content ("token",
                            label_type,
                            operate_type,
                            data_subject,
                            token_name,token_type)

select
    lpt.pool as token,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_RANK' as label_type,
    'T' as operate_type,
    'volume_rank' data_subject,
    lpt.symbol_wired token_name,
    'lp' as token_type
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_RANK' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_RANK_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_RANK' rule_group,
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'token_volume_rank') level_def on
        (1 = 1);
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
    lpt.factory_type project,
    '' trade_type,
    '' balance,
    level_def.level  volume,
    '' activity,
    '' hold_time,
    now() created_at,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')'|| '_VOLUME_RANK_'||level_def.level  label_name,
    lpt.factory_content||' '||symbol_wired|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||level_def.level_name   "content",
    'token' asset_type,
    'RANK' label_category
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
        inner join platform_detail on(lpt.factory_type=platform_detail.platform_name)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'token_volume_rank') level_def on
        (1 = 1);