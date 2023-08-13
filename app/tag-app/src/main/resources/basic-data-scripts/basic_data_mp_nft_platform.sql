DROP TABLE if EXISTS mp_nft_platform_temp;
create table mp_nft_platform_temp
(
    id                 int8,
    platform           varchar(80) NULL,
    platform_name      varchar(512) NULL,
    platform_name_alis varchar(512) NULL
);

insert into mp_nft_platform_temp(platform, platform_name, platform_name_alis)
values (1,'0x00000000006c3852cbef3e08e8df289169ede581', 'Opensea', 'opensea');
insert into mp_nft_platform_temp(platform, platform_name, platform_name_alis)
values (2,'0x39da41747a83aee658334415666f3ef92dd0d541', 'Blur', 'Blur.io: Marketplace');
insert into mp_nft_platform_temp(platform, platform_name, platform_name_alis)
values (3,'0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb', 'PunkMarket', 'CryptoPunks');
insert into mp_nft_platform_temp(platform, platform_name, platform_name_alis)
values (4,'0x74312363e45dcaba76c59ec49a7aa8a65a67eed3', 'X2Y2', 'X2Y2');
insert into mp_nft_platform_temp(platform, platform_name, platform_name_alis)
values (5,'0x59728544b08ab483533076417fbbb2fd0b17ce3a', 'LooksRare', 'LooksRare');
insert into tag_result(table_name, batch_date)
SELECT 'basic_data_mp_nft_platform' as table_name, '${batchDate}' as batch_date;
