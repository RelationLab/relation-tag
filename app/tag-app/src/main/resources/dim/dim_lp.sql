-----balance_grade  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_GRADE
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_GRADE' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'balance_grade' data_subject,
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_GRADE' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_GRADE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_GRADE' rule_group,
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


-----balance_rank  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_RANK
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_RANK' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'balance_rank' data_subject,
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_RANK' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_RANK_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_RANK' rule_group,
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

-----balance_top  Uniswap_v3_UNI/WETH_0x1d42_BALANCE_TOP
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_TOP' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'balance_top' data_subject,
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_TOP' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_TOP_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_BALANCE_TOP' rule_group,
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


-----count  Uniswap_v3_UNI/WETH_0x1d42_ACTIVITY
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_ACTIVITY' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'count' data_subject,
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_ACTIVITY' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_ACTIVITY_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired||' '||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_ACTIVITY' rule_group,
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

-----volume_grade  Uniswap_v3_UNI/WETH_0x1d42_VOLUME_GRADE
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_GRADE' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'volume_grade' data_subject,
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_GRADE' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_GRADE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_GRADE' rule_group,
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

-----volume_rank  Uniswap_v3_UNI/WETH_0x1d42_VOLUME_RANK
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_RANK' as label_type,
    'T' as operate_type,
    lpt.factory_type || '_' || lpt.symbol_wired||'_lp' seq_flag,
    'volume_rank' data_subject,
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
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_RANK' as "type",
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_RANK_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    lpt.factory_content||' '||symbol_wired|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||level_def.level_name  "content",
    'SQL' rule_type,
    lpt.factory_type || '_' || (lpt.symbol1||'/'||lpt.symbol2)|| '_' || '(' || SUBSTRING(lpt.pool, 1, 6)|| ')'||'_VOLUME_RANK' rule_group,
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
