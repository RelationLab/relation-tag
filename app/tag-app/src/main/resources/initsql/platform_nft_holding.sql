-- public.platform_nft_holding definition

-- Drop table

-- DROP TABLE public.platform_nft_holding;
drop table if exists platform_nft_holding;
CREATE TABLE public.platform_nft_holding (
                                             address varchar(512) NOT NULL,
                                             platform varchar(512) NOT NULL,
                                             quote_token varchar(512) NOT NULL,
                                             "token" varchar(512) NOT NULL,
                                             total_transfer_volume numeric(128, 30) NULL,
                                             total_transfer_count int8 NULL,
                                             total_transfer_to_volume numeric(128, 30) NULL,
                                             total_transfer_to_count int8 NULL,
                                             total_transfer_all_volume numeric(128, 30) NULL,
                                             total_transfer_all_count int8 NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT false,
                                             platform_group varchar(256) NULL
 )distributed by (address,"token");
truncate table platform_nft_holding;
vacuum platform_nft_holding;


insert into platform_nft_holding (address, platform, quote_token, token, total_transfer_volume, total_transfer_count,
                                         total_transfer_to_volume, total_transfer_to_count, total_transfer_all_volume,
                                         total_transfer_all_count) (select address,
                                                                           platform,
                                                                           quote_token,
                                                                           token,
                                                                           sum(total_transfer_volume),
                                                                           sum(total_transfer_count),
                                                                           sum(total_transfer_to_volume),
                                                                           sum(total_transfer_to_count),
                                                                           sum(total_transfer_all_volume),
                                                                           sum(total_transfer_all_count)
                                                                    from platform_nft_holding_middle
                                                                    group by address, platform, quote_token, token);
update platform_nft_holding set platform_group='LooksRare' where platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a';
update platform_nft_holding set platform_group='opensea' where platform in ('0x7be8076f4ea4a4ad08075c2508e481d6c946d12b', '0x00000000006c3852cbef3e08e8df289169ede581', '0x7f268357a8c2552623316e2562d90e642bb538e5');
update platform_nft_holding set platform_group='X2Y2' where platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3';
update platform_nft_holding set platform_group='CryptoPunks' where platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb';
update platform_nft_holding set platform_group='Blur.io: Marketplace' where platform in ('0x000000000000ad05ccc4f10045630fb830b95127', '0x39da41747a83aee658334415666f3ef92dd0d541');

insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_holding' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
