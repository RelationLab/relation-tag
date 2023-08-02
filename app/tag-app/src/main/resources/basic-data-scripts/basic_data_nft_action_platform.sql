DROP TABLE if EXISTS  nft_action_platform_temp;
create table nft_action_platform_temp
(
    platform varchar(80) NULL,
    nft_trade_type varchar(512) NULL,
    token varchar(80) NULL,
    nft_type varchar(10) NULL
) ;


-----------------------Opensea--------------------------
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
    'ALL' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
    'Buy' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
    'Sale' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;

-----------------------PunkMarket--------------------------
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' as platform,
    'ALL' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' as platform,
    'Buy' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb' as platform,
    'Sale' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;



-----------------------X2Y2--------------------------
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' as platform,
    'ALL' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' as platform,
    'Buy' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3' as platform,
    'Sale' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;

-----------------------LooksRare--------------------------
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x59728544b08ab483533076417fbbb2fd0b17ce3a' as platform,
    'ALL' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x59728544b08ab483533076417fbbb2fd0b17ce3a' as platform,
    'Buy' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x59728544b08ab483533076417fbbb2fd0b17ce3a' as platform,
    'Sale' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;

-----------------------Blur--------------------------
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'ALL' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'Buy' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'Sale' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'Bid' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;

insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'Lend' as nft_trade_type,
    nft_sync_address.address,
    'NFT'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721' ;


insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'ALL' as nft_trade_type,
    nft_sync_address.address,
    'Token'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721-token' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'Deposit' as nft_trade_type,
    nft_sync_address.address,
    'Token'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721-token' ;
insert into nft_action_platform_temp(platform,nft_trade_type,token,
                                     nft_type)
select
    distinct
    '0x39da41747a83aee658334415666f3ef92dd0d541' as platform,
    'Withdraw' as nft_trade_type,
    nft_sync_address.address,
    'Token'
from
    nft_sync_address
where
        nft_sync_address.type = 'ERC721-token' ;
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_nft_action_platform' as table_name,'${batchDate}'  as batch_date;
