--------count project+token
-- Blur_CryptoPunks_ALL_MP_NFT_ACTIVITY
-- Blur_CryptoPunks_Sale_MP_NFT_ACTIVITY
-- Blur_CryptoPunks_Buy_MP_NFT_ACTIVITY
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
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    mp_nft_platform.platform_name project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' as "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_count') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    distinct
    nft_sync_address.platform asset,
    nft_platform.platform_name  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from nft_sync_address
         inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
         inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
         inner join nft_trade_type  on(1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_count') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------count PROJECT(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_ACTIVITY
-- ALL_ALL_Buy_MP_NFT_ACTIVITY
-- ALL_ALL_Sale_MP_NFT_ACTIVITY
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
    'ALL' project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    'ALL' token_name
from  nft_trade_type
where  nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' as "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_trade_type
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_count') level_def on
        (1 = 1)
where  nft_trade_type.type='1';
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
    'ALL_NFT' asset,
    'ALL'  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level label_name,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_trade_type
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_count') level_def on
    (1 = 1)
where  nft_trade_type.type='1';

--------count project(ALL)+token
-- ALL_CryptoPunks_ALL_MP_NFT_ACTIVITY
-- ALL_CryptoPunks_Buy_MP_NFT_ACTIVITY
-- ALL_CryptoPunks_Sale_MP_NFT_ACTIVITY
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
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' as "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_count') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    'ALL'  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_count') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------count project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_ACTIVITY
-- Blur_ALL_Buy_MP_NFT_ACTIVITY
-- Blur_ALL_Sale_MP_NFT_ACTIVITY
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
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_count') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

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
    'ALL_NFT' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
              limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_count') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

------volume_elite
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
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
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    mp_nft_platform.platform_name project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' as "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_elite') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level  label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'ELITE' label_category
from  nft_sync_address
          inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
          inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_elite') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_elite
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
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
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' as "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_elite') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    distinct
    nft_sync_address.platform asset,
    'ALL'   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level  label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'ELITE' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_elite') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------volume_elite project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_ELITE
-- Blur_ALL_Buy_MP_NFT_VOLUME_ELITE
-- Blur_ALL_Sale_MP_NFT_VOLUME_ELITE
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
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_elite') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

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
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_elite') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;
('ALL_NFT','','','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','Elite NFT Trader','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','MP NFT Elite Trader','nft','ELITE');
--------volume_elite project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_ELITE
-- ALL_ALL_Buy_MP_NFT_VOLUME_ELITE
-- ALL_ALL_Sale_MP_NFT_VOLUME_ELITE
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
    'ALL' project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    'ALL' token_name
from  nft_trade_type
where  nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' as "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_trade_type
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_elite') level_def on
        (1 = 1)
where  nft_trade_type.type='1';
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
    'ALL_NFT' asset,
    'ALL'  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level label_name,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_trade_type
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_elite') level_def on
    (1 = 1)
where  nft_trade_type.type='1';


--------volume_grade
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
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
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    mp_nft_platform.platform_name project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' as "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level  label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_sync_address
          inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
          inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_grade') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_grade
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
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
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' as "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    'ALL'   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level  label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_grade') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------volume_grade project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_GRADE
-- Blur_ALL_Buy_MP_NFT_VOLUME_GRADE
-- Blur_ALL_Sale_MP_NFT_VOLUME_GRADE
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
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_grade') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

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
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_grade') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

--------volume_grade project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_GRADE
-- ALL_ALL_Buy_MP_NFT_VOLUME_GRADE
-- ALL_ALL_Sale_MP_NFT_VOLUME_GRADE
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
    'ALL' project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    'ALL' token_name
from  nft_trade_type
where  nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' as "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_trade_type
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_grade') level_def on
        (1 = 1)
where  nft_trade_type.type='1';
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
    'ALL_NFT' asset,
    'ALL'  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level label_name,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_trade_type
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_grade') level_def on
    (1 = 1)
where  nft_trade_type.type='1';                                                                                                                                                                     ('ALL_NFT','ALL','','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L6','MP NFT VOL Lv6 Trader','nft','GRADE');

--------volume_rank
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
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
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    mp_nft_platform.platform_name project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' as "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level  label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)   "content",
    'nft' asset_type,
    'RANK' label_category
from  nft_sync_address
          inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
          inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_rank') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_rank
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
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
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' as "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    'ALL'   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level   label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'RANK' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_rank') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_rank project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_RANK
-- Blur_ALL_Buy_MP_NFT_VOLUME_RANK
-- Blur_ALL_Sale_MP_NFT_VOLUME_RANK
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
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_rank') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

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
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_rank') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;


--------volume_rank project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_RANK
-- ALL_ALL_Buy_MP_NFT_VOLUME_RANK
-- ALL_ALL_Sale_MP_NFT_VOLUME_RANK
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
    'ALL' project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    'ALL' token_name
from  nft_trade_type
where  nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' as "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_trade_type
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_rank') level_def on
        (1 = 1)
where  nft_trade_type.type='1';
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
    'ALL_NFT' asset,
    'ALL'  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level label_name,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_trade_type
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_rank') level_def on
    (1 = 1)
where  nft_trade_type.type='1';                                                                                                                                                              ('ALL_NFT','ALL','','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_RANK_RARE_NFT_TRADER','MP NFT Rare Trader','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','MP NFT Uncommon Trader','nft','RANK');

--------volume_top
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
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
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    mp_nft_platform.platform_name project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' as "type",
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_top') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    'TOP' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'TOP' label_category
from nft_sync_address
         inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
         inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
         inner join nft_trade_type  on(1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_top') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_top
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
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
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    replace(nft_sync_address.platform,' ','') token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' as "type",
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_top') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
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
    nft_sync_address.platform asset,
    'ALL' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    'TOP' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || replace(nft_sync_address.platform,' ','') || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'TOP' label_category
from nft_sync_address
         inner join nft_trade_type  on(1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_top') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------volume_top project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_TOP
-- Blur_ALL_Buy_MP_NFT_VOLUME_TOP
-- Blur_ALL_Sale_MP_NFT_VOLUME_TOP
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
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

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
select distinct
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_top') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

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
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_top') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;


--------volume_top project(ALL)+token(ALL)
-- ALL_ALL_ALL_MP_NFT_VOLUME_TOP
-- ALL_ALL_Buy_MP_NFT_VOLUME_TOP
-- ALL_ALL_Sale_MP_NFT_VOLUME_TOP
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
    'ALL' project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    'ALL' token_name
from  nft_trade_type
where  nft_trade_type.type='1';
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
select distinct
    'RelationTeam' "owner",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' as "type",
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_trade_type
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_top') level_def on
        (1 = 1)
where  nft_trade_type.type='1';
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
    'ALL_NFT' asset,
    'ALL'  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level label_name,
    'MP NFT ' ||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_trade_type
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_top') level_def on
    (1 = 1)
where  nft_trade_type.type='1';
