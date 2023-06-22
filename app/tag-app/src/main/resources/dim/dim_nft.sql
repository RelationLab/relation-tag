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

--------balance_grade CryptoPunks_NFT_BALANCE_RANK
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