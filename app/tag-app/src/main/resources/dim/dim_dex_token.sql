---------------count 0x_USDC(0xa0b869)_ALL_ACTIVITY_DEX
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
    token_platform.platform as project,
    token_platform.address as token,
    trade_type.trade_type as type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_ACTIVITY_DEX' as label_type,
    'T' as operate_type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'count' data_subject,
    platform.platform_name project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        INNER JOIN trade_type ON  (1=1);
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
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX' as "type",
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    platform.platform_name || ' ' || upper(top_token_1000.symbol)|| ' ' || (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        inner join trade_type on
        (1 = 1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'count') level_def on
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
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
    platform.platform_name project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX_' || level_def.level label_name,
    platform.platform_name || ' ' || upper(top_token_1000.symbol)|| ' ' || (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||level_def.level_name "content",
    'token' asset_type,
    'GRADE' label_category
from token_platform
         inner join platform on
    (token_platform.platform = platform.platform)
         inner join (
    select
        *
    from
        top_token_1000
    where
            holders >= 100
      and removed <> 'true') top_token_1000 on
    (token_platform.address = top_token_1000.address)
         inner join trade_type on
    (1 = 1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'count') level_def on
    (1 = 1);

---------------count ALL_USDC(0xa0b869)_ALL_ACTIVITY_DEX
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
    'ALL' as project,
    top_token_1000.address as token,
    trade_type.trade_type as type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_ACTIVITY_DEX' as label_type,
    'T' as operate_type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'count' data_subject,
    'ALL' project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000
        INNER JOIN trade_type ON  (1=1);
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
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX' as "type",
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
     upper(top_token_1000.symbol)|| ' ' || (CASE WHEN trade_type.trade_type='ALL' THEN 'DEX' else trade_type.trade_type_name end)||' '||level_def.level_name "content",
    'SQL' rule_type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
     (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000
        INNER JOIN trade_type ON  (1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'count') level_def on
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        'ALL' project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        '' volume,
        level_def.level activity,
        '' hold_time,
        now() created_at,
        'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_ACTIVITY_DEX_' || level_def.level label_name,
        upper(top_token_1000.symbol)|| ' ' || (CASE WHEN trade_type.trade_type='ALL' THEN 'DEX' else trade_type.trade_type_name end)||' '||level_def.level_name "content",
        'token' asset_type,
        'GRADE' label_category
from (
         select
             *
         from
             top_token_1000
         where
                 holders >= 100
           and removed <> 'true') top_token_1000
         INNER JOIN trade_type ON  (1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'count') level_def on
    (1 = 1);


---------------volume_grade 0x_USDC(0xa0b869)_ALL_VOLUME_DEX_GRADE
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
    token_platform.platform as project,
    token_platform.address as token,
    trade_type.trade_type as type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_VOLUME_DEX_GRADE' as label_type,
    'T' as operate_type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'volume_grade' data_subject,
    platform.platform_name project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        INNER JOIN trade_type ON  (1=1);
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
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' as "type",
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    platform.platform_name || ' ' || upper(top_token_1000.symbol)|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)|| ' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        INNER JOIN trade_type ON  (1=1)
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        platform.platform_name project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE_' || level_def.level label_name,
        platform.platform_name || ' ' || upper(top_token_1000.symbol)|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)|| ' '||level_def.level_name  "content",
        'token' asset_type,
        'GRADE' label_category
from  token_platform
          inner join platform on
    (token_platform.platform = platform.platform)
          inner join (
    select
        *
    from
        top_token_1000
    where
            holders >= 100
      and removed <> 'true') top_token_1000 on
    (token_platform.address = top_token_1000.address)
          INNER JOIN trade_type ON  (1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_grade') level_def on
    (1 = 1);

---------------volume_grade ALL_USDC(0xa0b869)_ALL_VOLUME_DEX_GRADE
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
    'ALL' as project,
    top_token_1000.address as token,
    trade_type.trade_type as type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_VOLUME_DEX_GRADE' as label_type,
    'T' as operate_type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000
        INNER JOIN trade_type ON  (1=1);

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
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' as "type",
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    upper(top_token_1000.symbol)|| ' ' || (case when trade_type.trade_type='ALL' and (level_def.level='Million' or level_def.level='Billion') then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||
    (case when trade_type.trade_type<>'ALL' and (level_def.level='Million' or level_def.level='Billion') then ' '||level_def.level else '' end )|| ' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL'|| '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
     (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000
        INNER JOIN trade_type ON  (1=1)
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        'ALL' project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE_' || level_def.level label_name,
        upper(top_token_1000.symbol)|| ' ' || (case when trade_type.trade_type='ALL' and (level_def.level='Million' or level_def.level='Billion') then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||
        (case when trade_type.trade_type<>'ALL' and (level_def.level='Million' or level_def.level='Billion') then ' '||level_def.level else '' end )|| ' '||level_def.level_name "content",
        'token' asset_type,
        'GRADE' label_category
from (
         select
             *
         from
             top_token_1000
         where
                 holders >= 100
           and removed <> 'true') top_token_1000
         INNER JOIN trade_type ON  (1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_grade') level_def on
    (1 = 1);

---------------volume_rank 0x_USDC(0xa0b869)_ALL_VOLUME_DEX_RANK
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
    token_platform.platform as project,
    token_platform.address as token,
    trade_type.trade_type as type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_VOLUME_DEX_RANK' as label_type,
    'T' as operate_type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'volume_rank' data_subject,
    platform.platform_name project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        INNER JOIN trade_type ON  (1=1);
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
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' as "type",
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    platform.platform_name || ' ' || upper(top_token_1000.symbol)|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)|| ' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        INNER JOIN trade_type ON  (1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_volume_rank') level_def on
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        platform.platform_name project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        platform.platform_name || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK_' || level_def.level label_name,
        platform.platform_name || ' ' || upper(top_token_1000.symbol)|| ' ' || (case when level_def.level='Million' or level_def.level='Billion' then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)|| ' '||level_def.level_name  "content",
        'token' asset_type,
        'RANK' label_category
from   token_platform
           inner join platform on
    (token_platform.platform = platform.platform)
           inner join (
    select
        *
    from
        top_token_1000
    where
            holders >= 100
      and removed <> 'true') top_token_1000 on
    (token_platform.address = top_token_1000.address)
           INNER JOIN trade_type ON  (1=1)
           inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_rank') level_def on
    (1 = 1);


---------------volume_rank ALL_USDC(0xa0b869)_ALL_VOLUME_DEX_RANK
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
    'ALL' as project,
    top_token_1000.address as token,
    trade_type.trade_type as type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_VOLUME_DEX_RANK' as label_type,
    'T' as operate_type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
   (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000
        INNER JOIN trade_type ON  (1=1);
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
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' as "type",
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    upper(top_token_1000.symbol)|| ' ' || (case when trade_type.trade_type='ALL'  then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||
    (case when trade_type.trade_type<>'ALL'  then ' '||level_def.level else '' end )|| ' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL'|| '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000
        INNER JOIN trade_type ON  (1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_volume_rank') level_def on
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        'ALL' project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK_' || level_def.level label_name,
        upper(top_token_1000.symbol)|| ' ' || (case when trade_type.trade_type='ALL'  then level_def.level||' ' else '' end )||(CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||
        (case when trade_type.trade_type<>'ALL'  then ' '||level_def.level else '' end )|| ' '||level_def.level_name "content",
        'token' asset_type,
        'RANK' label_category
from (
         select
             *
         from
             top_token_1000
         where
                 holders >= 100
           and removed <> 'true') top_token_1000
         INNER JOIN trade_type ON  (1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_rank') level_def on
    (1 = 1);

---------------count 1inch_ALL_ALL_ACTIVITY_DEX
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
    token_platform.platform as project,
    'ALL' as token,
    trade_type.trade_type as type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name || '_ACTIVITY_DEX' as label_type,
    'T' as operate_type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name seq_flag,
    'count' data_subject,
    platform.platform_name project_name,
    'ALL' token_name
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join trade_type on
        (1 = 1);
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
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name || '_ACTIVITY_DEX' as "type",
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_ACTIVITY_DEX_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    platform.platform_name || ' '|| (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_ACTIVITY_DEX' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        inner join trade_type on
        (1 = 1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'count') level_def on
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        platform.platform_name project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        '' volume,
        level_def.level activity,
        '' hold_time,
        now() created_at,
        platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_ACTIVITY_DEX_' || level_def.level label_name,
        platform.platform_name || ' '|| (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||level_def.level_name  "content",
        'token' asset_type,
        'GRADE' label_category
from   token_platform
           inner join platform on
    (token_platform.platform = platform.platform)
           inner join (
    select
        *
    from
        top_token_1000
    where
            holders >= 100
      and removed <> 'true') top_token_1000 on
    (token_platform.address = top_token_1000.address)
           inner join trade_type on
    (1 = 1)
           inner join (
    select
        *
    from
        level_def
    where
            type = 'count') level_def on
    (1 = 1);
---------------count ALL_ALL_ALL_ACTIVITY_DEX
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
    'ALL' as project,
    'ALL' as token,
    trade_type.trade_type as type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_ACTIVITY_DEX' as label_type,
    'T' as operate_type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name seq_flag,
    'count' data_subject,
    'ALL' project_name,
    'ALL' token_name
from
    trade_type;
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
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_ACTIVITY_DEX' as "type",
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_ACTIVITY_DEX_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    (CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_ACTIVITY_DEX' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    trade_type
    inner join (
        select
            *
        from
            level_def
        where
                type = 'count') level_def on
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        'ALL' project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_ACTIVITY_DEX_'|| level_def.level  label_name,
        (CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||' '||level_def.level_name "content",
        'token' asset_type,
        'GRADE' label_category
from trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'count') level_def on
    (1 = 1);

---------------volume_grade 1inch_ALL_ALL_VOLUME_DEX_GRADE
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
    token_platform.platform as project,
    'ALL' as token,
    trade_type.trade_type as type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' as label_type,
    'T' as operate_type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name seq_flag,
    'volume_grade' data_subject,
    platform.platform_name project_name,
    'ALL' token_name
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join trade_type on
        (1 = 1);
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
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' as "type",
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_VOLUME_DEX_GRADE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    platform.platform_name || ' '|| (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||
    (CASE WHEN level_def.level='Million' or level_def.level='Billion' THEN level_def.level||' ' else '' end) ||level_def.level_name  "content",
    'SQL' rule_type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_VOLUME_DEX_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        inner join trade_type on
        (1 = 1)
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        platform.platform_name project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_VOLUME_DEX_GRADE_' || level_def.level label_name,
        platform.platform_name || ' '|| (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||
        (CASE WHEN level_def.level='Million' or level_def.level='Billion' THEN level_def.level||' ' else '' end) ||level_def.level_name  "content",
        'token' asset_type,
        'GRADE' label_category
from  token_platform
          inner join platform on
    (token_platform.platform = platform.platform)
          inner join (
    select
        *
    from
        top_token_1000
    where
            holders >= 100
      and removed <> 'true') top_token_1000 on
    (token_platform.address = top_token_1000.address)
          inner join trade_type on
    (1 = 1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_grade') level_def on
    (1 = 1);

---------------volume_grade ALL_ALL_ALL_VOLUME_DEX_GRADE
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
    'ALL' as project,
    'ALL' as token,
    trade_type.trade_type as type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' as label_type,
    'T' as operate_type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    'ALL' token_name
from
    trade_type;
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
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' as "type",
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    (CASE WHEN trade_type.trade_type='ALL'  and (level_def.level='Million' or level_def.level='Billion') THEN level_def.level||' ' else '' end)||
    (CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||' '||
    (CASE WHEN trade_type.trade_type<>'ALL'  and (level_def.level='Million' or level_def.level='Billion') THEN level_def.level||' ' else '' end)||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    trade_type
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        'ALL' project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_GRADE_'|| level_def.level label_name,
        (CASE WHEN trade_type.trade_type='ALL'  and (level_def.level='Million' or level_def.level='Billion') THEN level_def.level||' ' else '' end)||
        (CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||' '||
        (CASE WHEN trade_type.trade_type<>'ALL'  and (level_def.level='Million' or level_def.level='Billion') THEN level_def.level||' ' else '' end)||level_def.level_name "content",
        'token' asset_type,
        'GRADE' label_category
from trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_grade') level_def on
    (1 = 1);

---------------volume_rank 1inch_ALL_ALL_VOLUME_DEX_RANK
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
    token_platform.platform as project,
    'ALL' as token,
    trade_type.trade_type as type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' as label_type,
    'T' as operate_type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name seq_flag,
    'volume_rank' data_subject,
    platform.platform_name project_name,
    'ALL' token_name
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join trade_type on
        (1 = 1);
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
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' as "type",
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_VOLUME_DEX_RANK_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    platform.platform_name || ' '|| (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||
    level_def.level||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_VOLUME_DEX_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    token_platform
        inner join platform on
        (token_platform.platform = platform.platform)
        inner join (
        select
            *
        from
            top_token_1000
        where
                holders >= 100
          and removed <> 'true') top_token_1000 on
        (token_platform.address = top_token_1000.address)
        inner join trade_type on
        (1 = 1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_volume_rank') level_def on
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        platform.platform_name project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        platform.platform_name || '_' || 'ALL_' || trade_type.trade_type_name ||  '_VOLUME_DEX_RANK_' || level_def.level label_name,
        platform.platform_name || ' '|| (CASE WHEN trade_type.trade_type='ALL' THEN '' else trade_type.trade_type_name end)||' '||
        level_def.level||' '||level_def.level_name  "content",
        'token' asset_type,
        'RANK' label_category
from  token_platform
          inner join platform on
    (token_platform.platform = platform.platform)
          inner join (
    select
        *
    from
        top_token_1000
    where
            holders >= 100
      and removed <> 'true') top_token_1000 on
    (token_platform.address = top_token_1000.address)
          inner join trade_type on
    (1 = 1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_rank') level_def on
    (1 = 1);
---------------volume_rank ALL_ALL_ALL_VOLUME_DEX_RANK
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
    'ALL' as project,
    'ALL' as token,
    trade_type.trade_type as type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' as label_type,
    'T' as operate_type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    'ALL' token_name
from
    trade_type;
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
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' as "type",
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    level_def.level||' ' ||
    (CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||' '
    ||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'DEFI' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    trade_type
        inner join (
        select
            *
        from
            level_def
        where
                type = 'defi_volume_rank') level_def on
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
        upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) asset,
        'ALL' project,
        nft_trade_type.nft_trade_type trade_type,
        '' balance,
        level_def.level volume,
        '' activity,
        '' hold_time,
        now() created_at,
        'ALL' || '_' || 'ALL_' || trade_type.trade_type_name || '_VOLUME_DEX_RANK_'|| level_def.level label_name,
        (CASE WHEN trade_type.trade_type='ALL' THEN 'Dex' else trade_type.trade_type_name end)||' '
            ||level_def.level_name "content",
        'token' asset_type,
        'RANK' label_category
from trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'defi_volume_rank') level_def on
    (1 = 1);




