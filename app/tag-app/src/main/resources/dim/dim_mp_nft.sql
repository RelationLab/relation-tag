--------count
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
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    mp_nft_platform.platform_name project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------count
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
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

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
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE ' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    mp_nft_platform.platform_name project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


------volume_grade
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
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

------volume_grade
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
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';



------volume_rank
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
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

------volume_rank
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
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';




------volume_top
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
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

------volume_top
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
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

