drop table if exists dim_rule_content;
create table dim_rule_content
(
    rule_code    varchar(50),
    token        varchar(300),
    label_type   varchar(300),
    operate_type varchar(300),
    data_subject varchar(20),
    create_time  timestamp,
    token_name   varchar(100),

    token_type   varchar(100)
);
truncate table dim_rule_content;
vacuum dim_rule_content;
drop table if exists dim_rank_token;
create table dim_rank_token
(
    token_id   varchar(512),
    asset_type varchar(10)
);
truncate table dim_rank_token;
vacuum dim_rank_token;
----------------------------dim_lp.sql-----------------------------------------------
-----balance_grade  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_GRADE
insert
into
    dim_rule_content ("token",
                      label_type,
                      operate_type,
                      data_subject,
                      token_name,token_type)

select distinct
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
     where wlp.tvl > 1000000
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
select distinct
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
     where wlp.tvl > 1000000
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
select distinct
        (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')' asset,
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
     where wlp.tvl > 1000000
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

select distinct
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
     where wlp.tvl > 1000000
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
select distinct
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
     where wlp.tvl > 1000000
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
select distinct
        (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')' asset,
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
     where wlp.tvl > 1000000
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

select distinct
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
     where wlp.tvl > 1000000
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
select distinct
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
     where wlp.tvl > 1000000
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
select distinct
        (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')' asset,
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
     where wlp.tvl > 1000000
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

select distinct
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
     where wlp.tvl > 1000000
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
select distinct
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
     where wlp.tvl > 1000000
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
select distinct
        (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')' asset,
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
     where wlp.tvl > 1000000
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

select distinct
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
     where wlp.tvl > 1000000
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
select distinct
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
     where wlp.tvl > 1000000
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
select distinct
        (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')' asset,
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
     where wlp.tvl > 1000000
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

select distinct
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
     where wlp.tvl > 1000000
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
select distinct
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
     where wlp.tvl > 1000000
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
select distinct
        (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')' asset,
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
     where wlp.tvl > 1000000
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

----------------------------------------dim_token.sql------------------------------------------
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
select distinct 'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as rule_code,
                t.address as token,
                'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as label_type,
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
select distinct
    'RelationTeam' "owner",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' as "type",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        level_def.level balance,
        ''  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_GRADE_'|| level_def.level label_name,
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
    token_name,
    token_type)
select distinct
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_GRADE' label_type,
    'T' operate_type,
    'balance_grade' data_subject,
    'ALL' token_name,'token' as token_type;
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
select distinct
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
    'DEFI' wired_type,
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
select distinct
    'ALL_TOKEN'  asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_GRADE_' || level_def.level  label_name,
    'Token '||level_def.level_name  "content",
    'token' asset_type,
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
select distinct 'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as rule_code,
                t.address as token,
                'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as label_type,
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
select distinct
    'RelationTeam' "owner",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' as "type",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        level_def.level balance,
        ''  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_RANK_'|| level_def.level label_name,
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
    token_name,token_type)
select distinct
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_RANK' label_type,
    'T' operate_type,
    'balance_rank' data_subject,
    'ALL' token_name,'token' as token_type;
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
select distinct
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
    'DEFI' wired_type,
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
select distinct
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
select distinct 'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as rule_code,
                t.address as token,
                'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as label_type,
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
select distinct
    'RelationTeam' "owner",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' as "type",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        level_def.level balance,
        ''  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_BALANCE_TOP_'|| level_def.level label_name,
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
    token_name,token_type)
select distinct
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_BALANCE_TOP' label_type,
    'T' operate_type,
    'balance_top' data_subject,
    'ALL' token_name,'token' as token_type;
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
select distinct
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
    'DEFI' wired_type,
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
select distinct
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
select distinct 'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as rule_code,
                t.address as token,
                'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as label_type,
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
select distinct
    'RelationTeam' "owner",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' as "type",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        ''  volume,
        level_def.level activity,
        '' hold_time,
        now() created_at,
        'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_ACTIVITY_'|| level_def.level label_name,
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
    token_name,token_type)
select distinct
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_ACTIVITY' label_type,
    'T' operate_type,
    'count' data_subject,
    'ALL' token_name,'token' as token_type;
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
select distinct
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
    'DEFI' wired_type,
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
select distinct
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
select distinct t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as rule_code,
                t.address as token,
                t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as label_type,
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
select distinct
    'RelationTeam' "owner",
    t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' as "type",
    t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        ''  volume,
        '' activity,
        level_def.level hold_time,
        now() created_at,
        t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_GRADE_'|| level_def.level  label_name,
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
select distinct t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as rule_code,
                t.address as token,
                t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as label_type,
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
select distinct
    'RelationTeam' "owner",
    t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' as "type",
    t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        ''  volume,
        '' activity,
        level_def.level hold_time,
        now() created_at,
        t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_HOLDING_TIME_SPECIAL_'|| level_def.level  label_name,
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
select distinct 'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as rule_code,
                t.address as token,
                'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as label_type,
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
select distinct
    'RelationTeam' "owner",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' as "type",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol|| (case when level_def.level='Million' or level_def.level='Billion' then ' '||level_def.level else '' end)||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        level_def.level  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_GRADE_'|| level_def.level label_name,
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
    token_name,token_type)
select
    distinct 'ALL' "token",
             'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_GRADE' label_type,
             'T' operate_type,
             'volume_grade' data_subject,
             'ALL' token_name,'token' as token_type;
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
select distinct
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
    'DEFI' wired_type,
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
select distinct
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
select distinct 'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as rule_code,
                t.address as token,
                'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as label_type,
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
select distinct
    'RelationTeam' "owner",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' as "type",
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    t.symbol||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK' rule_group,
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
select distinct
        t.symbol||'('||SUBSTRING(t.address,1,8)||')' asset,
        '' project,
        '' trade_type,
        '' balance,
        level_def.level   volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL_'||t.symbol||'('||SUBSTRING(t.address,1,8)||')'||'_ALL_VOLUME_RANK_'|| level_def.level label_name,
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
    token_name,token_type)
select distinct
    'ALL' "token",
    'ALL_' ||'ALL_' ||'ALL' ||  '_VOLUME_RANK' label_type,
    'T' operate_type,
    'volume_rank' data_subject,
    'ALL' token_name,'token' as token_type;
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
select distinct
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
    'DEFI' wired_type,
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
select distinct
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

insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_token_whale',
     '',
     '',
     '');
insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_nft_whale',
     '',
     '',
     '');


insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_active_users',
     '',
     '',
     '');
insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_defi_active_users',
     '',
     '',
     '');

insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_nft_active_users',
     '',
     '',
     '');
insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_web3_active_users',
     '',
     '',
     '');


insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_long_term_holder',
     '',
     '',
     '');
insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_defi_high_demander',
     '',
     '',
     '');


insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_nft_high_demander',
     '',
     '',
     '');
insert
into
    combination (asset,
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
                 "content",
                 asset_type,
                 label_category)
values
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '2023-07-09 11:02:30.723',
     '2023-07-09 11:02:30.723',
     false,
     'crowd_elite',
     '',
     '',
     '');
insert into dim_rank_token select distinct token,token_type from dim_rule_content;
insert into tag_result(table_name,batch_date)  SELECT 'dim_rule_content' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;





