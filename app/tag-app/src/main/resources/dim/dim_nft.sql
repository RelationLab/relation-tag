--------------------NFT---------有211 但维度表有合并的204个而已------------------
--------balance_grade CryptoPunks_NFT_BALANCE_GRADE
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
    ''  project,
    address "token",
    ''    "type",
    platform||'_NFT_BALANCE_GRADE' label_type,
    'T' operate_type,
    platform seq_flag,
    'balance_grade' data_subject,
    null project_name,
    platform token_name
from
    public.nft_sync_address where type<>'ERC1155';

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
    platform||'_NFT_BALANCE_GRADE' as "type",
    platform||'_NFT_BALANCE_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform||'_NFT_BALANCE_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    public.nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_balance_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;
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
        platform asset,
        '' project,
        '' trade_type,
        level_def.level balance,
        ''  volume,
        '' activity,
        '' hold_time,
        now() created_at,
        platform||'_NFT_BALANCE_GRADE_'|| level_def.level label_name,
        nft_sync_address.platform||' '||level_def.level_name    "content",
        'nft' asset_type,
        'GRADE' label_category
from
    public.nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_balance_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;


--------balance_grade ALL_NFT_BALANCE_GRADE
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
    ''  project,
    'ALL' "token",
    '' "type",
    'ALL' ||  '_NFT_BALANCE_GRADE' label_type,
    'T' operate_type,
    'ALL' seq_flag,
    'balance_grade' data_subject,
    '' project_name,
    'ALL' token_name;
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
    'ALL' ||  '_NFT_BALANCE_GRADE'  as "type",
    'ALL' ||  '_NFT_BALANCE_GRADE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'NFT '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_NFT_BALANCE_GRADE'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'nft_balance_grade' ;
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
    'ALL_NFT'  asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL' ||  '_NFT_BALANCE_GRADE_' || level_def.level  label_name,
    'NFT '||level_def.level_name  "content",
    'nft' asset_type,
    'GRADE' label_category
from level_def where type = 'nft_balance_grade' ;


--------balance_rank CryptoPunks_NFT_BALANCE_RANK
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
    ''  project,
    address "token",
    ''    "type",
    platform||'_NFT_BALANCE_RANK' label_type,
    'T' operate_type,
    platform seq_flag,
    'balance_rank' data_subject,
    null project_name,
    platform token_name
from
    public.nft_sync_address where type<>'ERC1155';

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
    platform||'_NFT_BALANCE_RANK' as "type",
    platform||'_NFT_BALANCE_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform||'_NFT_BALANCE_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    public.nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_balance_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;
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
    platform asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''  volume,
    '' activity,
    '' hold_time,
    now() created_at,
    platform||'_NFT_BALANCE_RANK_'|| level_def.level label_name,
    nft_sync_address.platform||' '||level_def.level_name    "content",
    'nft' asset_type,
    'RANK' label_category
from
    public.nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_balance_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;

--------balance_rank ALL_NFT_BALANCE_RANK
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
    ''  project,
    'ALL' "token",
    '' "type",
    'ALL' ||  '_NFT_BALANCE_RANK' label_type,
    'T' operate_type,
    'ALL' seq_flag,
    'balance_rank' data_subject,
    '' project_name,
    'ALL' token_name;
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
    'ALL' ||  '_NFT_BALANCE_RANK'  as "type",
    'ALL' ||  '_NFT_BALANCE_RANK_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'NFT '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_NFT_BALANCE_RANK'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'nft_balance_rank' ;
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
    'ALL_NFT'  asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL' ||  '_NFT_BALANCE_RANK_' || level_def.level  label_name,
    'NFT '||level_def.level_name  "content",
    'nft' asset_type,
    'GRADE' label_category
from level_def where type = 'nft_balance_rank' ;

--------balance_top CryptoPunks_NFT_BALANCE_TOP
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
    ''  project,
    address "token",
    ''    "type",
    platform||'_NFT_BALANCE_TOP' label_type,
    'T' operate_type,
    platform seq_flag,
    'balance_top' data_subject,
    null project_name,
    platform token_name
from
    public.nft_sync_address where type<>'ERC1155';

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
    platform||'_NFT_BALANCE_TOP' as "type",
    platform||'_NFT_BALANCE_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform||'_NFT_BALANCE_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    public.nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_balance_top') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;
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
    platform asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''  volume,
    '' activity,
    '' hold_time,
    now() created_at,
    platform||'_NFT_BALANCE_TOP_'|| level_def.level  label_name,
    nft_sync_address.platform||' '||level_def.level_name    "content",
    'nft' asset_type,
    'TOP' label_category
from
    public.nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_balance_top') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;


--------balance_top ALL_NFT_BALANCE_TOP
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
    ''  project,
    'ALL' "token",
    '' "type",
    'ALL' ||  '_NFT_BALANCE_TOP' label_type,
    'T' operate_type,
    'ALL' seq_flag,
    'balance_top' data_subject,
    '' project_name,
    'ALL' token_name;
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
    'ALL' ||  '_NFT_BALANCE_TOP'  as "type",
    'ALL' ||  '_NFT_BALANCE_TOP_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'NFT '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL' ||  '_NFT_BALANCE_TOP'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from level_def where type = 'nft_balance_top' ;
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
    'ALL_NFT'  asset,
    '' project,
    '' trade_type,
    level_def.level balance,
    ''    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL' ||  '_NFT_BALANCE_TOP_' || level_def.level  label_name,
    'NFT '||level_def.level_name  "content",
    'nft' asset_type,
    'GRADE' label_category
from level_def where type = 'nft_balance_top' ;

--------count ALL_CryptoPunks_ALL_NFT_ACTIVITY
-- ALL_CryptoPunks_Transfer_NFT_ACTIVITY
-- ALL_CryptoPunks_Mint_NFT_ACTIVITY
-- ALL_CryptoPunks_Sale_NFT_ACTIVITY
-- ALL_CryptoPunks_Burn_NFT_ACTIVITY
-- ALL_CryptoPunks_Buy_NFT_ACTIVITY
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
    ''  project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
    inner join nft_trade_type  on(1=1)
 where nft_sync_address.type<>'ERC1155'  and  nft_trade_type.type='0';
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
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY'  as "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
     nft_sync_address.platform||' '||level_def.level_name  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY'  rule_group,
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';
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
    nft_sync_address.platform  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    ''  volume,
    level_def.level  activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY_' || level_def.level  label_name,
    nft_sync_address.platform||' '||level_def.level_name    "content",
    'nft' asset_type,
    'GRADE' label_category
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';



--------count ALL_ALL_ALL_NFT_ACTIVITY
-- ALL_ALL_Transfer_NFT_ACTIVITY
-- ALL_ALL_Mint_NFT_ACTIVITY
-- ALL_ALL_Sale_NFT_ACTIVITY
-- ALL_ALL_Burn_NFT_ACTIVITY
-- ALL_ALL_Buy_NFT_ACTIVITY
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
    ''  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    '' project_name,
    'ALL' token_name
from nft_trade_type
where nft_trade_type.type='0';
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
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY'  as "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'NFT '||level_def.level_name||' '||(case when nft_trade_type.nft_trade_type='ALL' then '' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || '_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from nft_trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_count') level_def on
    (1 = 1)
where  nft_trade_type.type='0';
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
    'ALL_NFT'  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    ''  volume,
    level_def.level  activity,
    '' hold_time,
    now() created_at,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_ACTIVITY_' || level_def.level  label_name,
    'NFT '||level_def.level_name||' '||(case when nft_trade_type.nft_trade_type='ALL' then '' else nft_trade_type.nft_trade_type_name end)    "content",
    'nft' asset_type,
    'GRADE' label_category
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
where nft_trade_type.type='0';

--------time_grade CryptoPunks_NFT_TIME_GRADE
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
    ''  project,
    address "token",
    ''    "type",
    platform||'_NFT_TIME_GRADE' label_type,
    'T' operate_type,
    platform seq_flag,
    'time_grade' data_subject,
    null project_name,
    platform token_name
from
    public.nft_sync_address where nft_sync_address.type<>'ERC1155';
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
    platform||'_NFT_TIME_GRADE'  as "type",
    platform||'_NFT_TIME_GRADE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform||'_NFT_TIME_GRADE'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_time_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;
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
    platform asset,
    '' project,
    '' trade_type,
    '' balance,
    ''  volume,
    '' activity,
    level_def.level  hold_time,
    now() created_at,
    platform||'_NFT_TIME_GRADE_' || level_def.level  label_name,
    nft_sync_address.platform||' '||level_def.level_name     "content",
    'nft' asset_type,
    'GRADE' label_category
from
    nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_time_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;

--------time_rank CryptoPunks_NFT_TIME_SMART_NFT_EARLY_ADOPTER
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
    ''  project,
    address "token",
    ''    "type",
    platform||'_NFT_TIME_SMART_NFT_EARLY_ADOPTER' label_type,
    'T' operate_type,
    platform seq_flag,
    'time_rank' data_subject,
    null project_name,
    platform token_name
from
    public.nft_sync_address where nft_sync_address.type<>'ERC1155';
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
    platform||'_NFT_TIME_SMART_NFT_EARLY_ADOPTER'  as "type",
    platform||'_NFT_TIME_SMART_NFT_EARLY_ADOPTER' as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform||'_NFT_TIME_SMART_NFT_EARLY_ADOPTER'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_time_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;
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
    platform asset,
    '' project,
    '' trade_type,
    '' balance,
    ''  volume,
    '' activity,
    'SMART_NFT_EARLY_ADOPTER'  hold_time,
    now() created_at,
    platform||'_NFT_TIME_SMART_NFT_EARLY_ADOPTER'  label_name,
    nft_sync_address.platform||' '||level_def.level_name   "content",
    'nft' asset_type,
    'RANK' label_category
from
    nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_time_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;

--------time_special CryptoPunks_NFT_TIME_SPECIAL
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
    ''  project,
    address "token",
    ''    "type",

    platform||'_NFT_TIME_SPECIAL' label_type,
    'T' operate_type,
    platform seq_flag,
    'time_special' data_subject,
    null project_name,
    platform token_name
from
    public.nft_sync_address where nft_sync_address.type<>'ERC1155';
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
    platform||'_NFT_TIME_SPECIAL'  as "type",
    platform||'_NFT_TIME_SPECIAL_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name  "content",
    'SQL' rule_type,
    platform||'_NFT_TIME_SPECIAL'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_time_special') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;

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
    platform asset,
    '' project,
    '' trade_type,
    '' balance,
    ''  volume,
    '' activity,
    level_def.level  hold_time,
    now() created_at,
    platform||'_NFT_TIME_SPECIAL_'||level_def.level  label_name,
    nft_sync_address.platform||' '||level_def.level_name "content",
    'nft' asset_type,
    'SPECIAL' label_category
from
    nft_sync_address
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_time_special') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' ;

--------volume_elite ALL_CryptoPunks_ALL_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Mint_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Sale_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Burn_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Buy_NFT_VOLUME_ELITE
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
    ''  project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155'  and  nft_trade_type.type='0';
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
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE'  as "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)   "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE'  rule_group,
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';
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
    nft_sync_address.platform  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
     '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE_'||level_def.level  label_name,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)   "content",
    'nft' asset_type,
    'ELITE' label_category
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';


--------volume_elite ALL_ALL_ALL_NFT_VOLUME_ELITE
-- ALL_ALL_Transfer_NFT_VOLUME_ELITE
-- ALL_ALL_Mint_NFT_VOLUME_ELITE
-- ALL_ALL_Sale_NFT_VOLUME_ELITE
-- ALL_ALL_Burn_NFT_VOLUME_ELITE
-- ALL_ALL_Buy_NFT_VOLUME_ELITE
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
    ''  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    '' project_name,
    'ALL' token_name
from nft_trade_type
where nft_trade_type.type='0';
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
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE'  as "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then ' Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || '_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from nft_trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_elite') level_def on
    (1 = 1)
where  nft_trade_type.type='0';
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
    'ALL_NFT'  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_ELITE_' || level_def.level  label_name,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then ' Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
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
where nft_trade_type.type='0';

--------volume_grade ALL_CryptoPunks_ALL_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Mint_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Sale_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Burn_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Buy_NFT_VOLUME_GRADE
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
    ''  project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155'  and  nft_trade_type.type='0';
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
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE'  as "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE'  rule_group,
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';
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
    nft_sync_address.platform  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE_'||level_def.level label_name,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';


--------volume_grade ALL_ALL_ALL_NFT_VOLUME_GRADE
-- ALL_ALL_Transfer_NFT_VOLUME_GRADE
-- ALL_ALL_Mint_NFT_VOLUME_GRADE
-- ALL_ALL_Sale_NFT_VOLUME_GRADE
-- ALL_ALL_Burn_NFT_VOLUME_GRADE
-- ALL_ALL_Buy_NFT_VOLUME_GRADE
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
    ''  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    '' project_name,
    'ALL' token_name
from nft_trade_type
where nft_trade_type.type='0';
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
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE'  as "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then '' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || '_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from nft_trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_grade') level_def on
    (1 = 1)
where  nft_trade_type.type='0';
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
    'ALL_NFT'  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_GRADE_' || level_def.level  label_name,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then '' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
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
where nft_trade_type.type='0';

--------volume_rank ALL_CryptoPunks_ALL_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Mint_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Sale_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Burn_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Buy_NFT_VOLUME_RANK
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
    ''  project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155'  and  nft_trade_type.type='0';
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
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK'  as "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK'  rule_group,
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';
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
    nft_sync_address.platform  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK_'||level_def.level label_name,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'RANK' label_category
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';

--------volume_rank ALL_ALL_ALL_NFT_VOLUME_RANK
-- ALL_ALL_Transfer_NFT_VOLUME_RANK
-- ALL_ALL_Mint_NFT_VOLUME_RANK
-- ALL_ALL_Sale_NFT_VOLUME_RANK
-- ALL_ALL_Burn_NFT_VOLUME_RANK
-- ALL_ALL_Buy_NFT_VOLUME_RANK
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
    ''  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    '' project_name,
    'ALL' token_name
from nft_trade_type
where nft_trade_type.type='0';
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
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK'  as "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then ' Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || '_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from nft_trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_rank') level_def on
    (1 = 1)
where  nft_trade_type.type='0';
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
    'ALL_NFT'  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_RANK_' || level_def.level  label_name,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then ' Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
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
where nft_trade_type.type='0';

--------volume_top ALL_CryptoPunks_ALL_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Transfer_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Mint_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Sale_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Burn_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Buy_NFT_VOLUME_TOP
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
    ''  project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155'  and  nft_trade_type.type='0';
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
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP'  as "type",
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP'  rule_group,
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';
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
    nft_sync_address.platform  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP_'||level_def.level label_name,
    nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'TOP' label_category
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
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='0';

--------volume_top ALL_ALL_ALL_NFT_VOLUME_TOP
-- ALL_ALL_Transfer_NFT_VOLUME_TOP
-- ALL_ALL_Mint_NFT_VOLUME_TOP
-- ALL_ALL_Sale_NFT_VOLUME_TOP
-- ALL_ALL_Burn_NFT_VOLUME_TOP
-- ALL_ALL_Buy_NFT_VOLUME_TOP
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
    ''  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' ||  'ALL_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    '' project_name,
    'ALL' token_name
from nft_trade_type
where nft_trade_type.type='0';
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
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP'  as "type",
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP_' || level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then ' Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || '_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP'  rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from nft_trade_type
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_top') level_def on
    (1 = 1)
where  nft_trade_type.type='0';
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
    'ALL_NFT'  asset,
    '' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level    volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || 'ALL_'||nft_trade_type.nft_trade_type|| '_NFT_VOLUME_TOP_' || level_def.level  label_name,
    level_def.level_name||' NFT '||(case when nft_trade_type.nft_trade_type='ALL' then ' Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
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
where nft_trade_type.type='0';