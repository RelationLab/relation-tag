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
    public.nft_sync_address;

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
    public.nft_sync_address;

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
    public.nft_sync_address;



--------count Blur_CryptoPunks_ALL_MP_NFT_ACTIVITY
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL' seq_flag,
    'count' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------count Blur_CryptoPunks_Buy_MP_NFT_ACTIVITY
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
    'Buy' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy' seq_flag,
    'count' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------count Blur_CryptoPunks_Sale_MP_NFT_ACTIVITY
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale' seq_flag,
    'count' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------count ALL_CryptoPunks_ALL_MP_NFT_ACTIVITY
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------count ALL_CryptoPunks_Buy_MP_NFT_ACTIVITY
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'count' data_subject,
     'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------count ALL_CryptoPunks_Sale_MP_NFT_ACTIVITY
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------count ALL_CryptoPunks_ALL_NFT_ACTIVITY
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------count ALL_CryptoPunks_Burn_NFT_ACTIVITY
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
    'Burn' "type",
    'ALL_' || nft_sync_address.platform || '_Burn_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Burn' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;



--------count ALL_CryptoPunks_Buy_NFT_ACTIVITY
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------count ALL_CryptoPunks_Mint_NFT_ACTIVITY
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
    'Mint' "type",
    'ALL_' || nft_sync_address.platform || '_Mint_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Mint' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;

--------count ALL_CryptoPunks_Sale_NFT_ACTIVITY
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------count ALL_CryptoPunks_Transfer_NFT_ACTIVITY
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
    'Transfer' "type",
    'ALL_' || nft_sync_address.platform || '_Transfer_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Transfer' seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from

    nft_sync_address;

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
    public.nft_sync_address;

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
    public.nft_sync_address;


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
    public.nft_sync_address;



--------volume_elite Blur_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_elite' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_elite Blur_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
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
    'Buy' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_elite' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_elite Blur_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_elite' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_elite ALL_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_elite ALL_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_elite ALL_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_elite ALL_CryptoPunks_ALL_NFT_VOLUME_ELITE
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_elite ALL_CryptoPunks_Burn_NFT_VOLUME_ELITE
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
    'Burn' "type",
    'ALL_' || nft_sync_address.platform || '_Burn_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Burn' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;



--------volume_elite ALL_CryptoPunks_Buy_NFT_VOLUME_ELITE
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_elite ALL_CryptoPunks_Mint_NFT_VOLUME_ELITE
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
    'Mint' "type",
    'ALL_' || nft_sync_address.platform || '_Mint_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Mint' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;

--------volume_elite ALL_CryptoPunks_Sale_NFT_VOLUME_ELITE
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_elite ALL_CryptoPunks_Transfer_NFT_VOLUME_ELITE
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
    'Transfer' "type",
    'ALL_' || nft_sync_address.platform || '_Transfer_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Transfer' seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from

    nft_sync_address;




--------volume_grade Blur_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_grade' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_grade Blur_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
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
    'Buy' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_grade' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_grade Blur_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_grade' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_grade ALL_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_grade ALL_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_grade ALL_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_grade ALL_CryptoPunks_ALL_NFT_VOLUME_GRADE
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_grade ALL_CryptoPunks_Burn_NFT_VOLUME_GRADE
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
    'Burn' "type",
    'ALL_' || nft_sync_address.platform || '_Burn_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Burn' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;



--------volume_grade ALL_CryptoPunks_Buy_NFT_VOLUME_GRADE
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_grade ALL_CryptoPunks_Mint_NFT_VOLUME_GRADE
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
    'Mint' "type",
    'ALL_' || nft_sync_address.platform || '_Mint_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Mint' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;

--------volume_grade ALL_CryptoPunks_Sale_NFT_VOLUME_GRADE
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_grade ALL_CryptoPunks_Transfer_NFT_VOLUME_GRADE
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
    'Transfer' "type",
    'ALL_' || nft_sync_address.platform || '_Transfer_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Transfer' seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from

    nft_sync_address;





--------volume_rank Blur_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_rank' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_rank Blur_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
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
    'Buy' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_rank' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_rank Blur_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_rank' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_rank ALL_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_rank ALL_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_rank ALL_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_rank ALL_CryptoPunks_ALL_NFT_VOLUME_RANK
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_rank ALL_CryptoPunks_Burn_NFT_VOLUME_RANK
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
    'Burn' "type",
    'ALL_' || nft_sync_address.platform || '_Burn_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Burn' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;



--------volume_rank ALL_CryptoPunks_Buy_NFT_VOLUME_RANK
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_rank ALL_CryptoPunks_Mint_NFT_VOLUME_RANK
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
    'Mint' "type",
    'ALL_' || nft_sync_address.platform || '_Mint_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Mint' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;

--------volume_rank ALL_CryptoPunks_Sale_NFT_VOLUME_RANK
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_rank ALL_CryptoPunks_Transfer_NFT_VOLUME_RANK
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
    'Transfer' "type",
    'ALL_' || nft_sync_address.platform || '_Transfer_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Transfer' seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from

    nft_sync_address;





--------volume_top Blur_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_top' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_top Blur_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
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
    'Buy' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_top' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_top Blur_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
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
    'ALL' "type",
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end
        || '_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_top' data_subject,
    case
        when nft_platform.platform = '0x00000000006c3852cbef3e08e8df289169ede581' then 'Opensea'
        when nft_platform.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' then 'Blur'
        when nft_platform.platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' then 'PunkMarket'
        when nft_platform.platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' then 'X2Y2'
        when nft_platform.platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a' then 'LooksRare'
        else 'ALL'
        end project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_top ALL_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_top ALL_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_top ALL_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
where
        nft_platform.platform in ('0x00000000006c3852cbef3e08e8df289169ede581',
                                  '0x39da41747a83aee658334415666f3ef92dd0d541',
                                  '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb',
                                  '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3',
                                  '0x59728544b08ab483533076417fbbb2fd0b17ce3a');


--------volume_top ALL_CryptoPunks_ALL_NFT_VOLUME_TOP
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
    'ALL' "type",
    'ALL_' || nft_sync_address.platform || '_ALL_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_ALL' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_top ALL_CryptoPunks_Burn_NFT_VOLUME_TOP
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
    'Burn' "type",
    'ALL_' || nft_sync_address.platform || '_Burn_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Burn' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;



--------volume_top ALL_CryptoPunks_Buy_NFT_VOLUME_TOP
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
    'Buy' "type",
    'ALL_' || nft_sync_address.platform || '_Buy_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Buy' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_top ALL_CryptoPunks_Mint_NFT_VOLUME_TOP
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
    'Mint' "type",
    'ALL_' || nft_sync_address.platform || '_Mint_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Mint' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;

--------volume_top ALL_CryptoPunks_Sale_NFT_VOLUME_TOP
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
    'Sale' "type",
    'ALL_' || nft_sync_address.platform || '_Sale_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Sale' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;


--------volume_top ALL_CryptoPunks_Transfer_NFT_VOLUME_TOP
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
    'Transfer' "type",
    'ALL_' || nft_sync_address.platform || '_Transfer_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform || '_Transfer' seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address;








