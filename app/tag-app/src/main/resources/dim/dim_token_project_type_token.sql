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
    token_platform.address as token,
    trade_type.trade_type as type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_ACTIVITY_DEX' as label_type,
    'T' as operate_type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'count' data_subject,
    'ALL' project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    token_platform
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
    token_platform.address as token,
    trade_type.trade_type as type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_VOLUME_DEX_GRADE' as label_type,
    'T' as operate_type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    token_platform
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
    token_platform.address as token,
    trade_type.trade_type as type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name||'_VOLUME_DEX_RANK' as label_type,
    'T' as operate_type,
    'ALL' || '_' || upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8)|| ')_'||trade_type.trade_type_name seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    upper(top_token_1000.symbol)|| '_' || '(' || SUBSTRING(top_token_1000.address, 1, 8) token_name
from
    token_platform
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

---------------count 1inch_ALL_ALL
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


---------------volume_grade 1inch_ALL_ALL
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

---------------volume_rank 1inch_ALL_ALL
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





