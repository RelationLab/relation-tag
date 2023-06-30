create table mp_nft_platform
(
   platform varchar(80) NULL,
    platform_name varchar(512) NULL
) ;

insert into mp_nft_platform(platform,platform_name) values('0x00000000006c3852cbef3e08e8df289169ede581','Opensea');
insert into mp_nft_platform(platform,platform_name) values('0x39da41747a83aee658334415666f3ef92dd0d541','Blur');
insert into mp_nft_platform(platform,platform_name) values('0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb','PunkMarket');
insert into mp_nft_platform(platform,platform_name) values('0x74312363e45dcaba76c59ec49a7aa8a65a67eed3','X2Y2');
insert into mp_nft_platform(platform,platform_name) values('0x59728544b08ab483533076417fbbb2fd0b17ce3a','LooksRare');
insert into tag_result(table_name,batch_date)  SELECT 'mp_nft_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
