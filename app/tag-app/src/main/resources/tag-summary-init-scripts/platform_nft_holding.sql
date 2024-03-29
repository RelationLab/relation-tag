drop table if exists platform_nft_holding_temp;
CREATE TABLE public.platform_nft_holding_temp
(
    address                   varchar(512) NOT NULL,
    platform                  varchar(512) NOT NULL,
    quote_token               varchar(512) NOT NULL,
    "token"                   varchar(512) NOT NULL,
    total_transfer_volume     numeric(128, 30) NULL,
    total_transfer_count      int8 NULL,
    total_transfer_to_volume  numeric(128, 30) NULL,
    total_transfer_to_count   int8 NULL,
    total_transfer_all_volume numeric(128, 30) NULL,
    total_transfer_all_count  int8 NULL,
    created_at                timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    removed                   bool NULL DEFAULT false,
    platform_group            varchar(256) NULL,
    weth_token_flag varchar(2),
    recent_time_code          varchar(30) NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address, token, quote_token, platform);
truncate table platform_nft_holding_temp;
vacuum platform_nft_holding_temp;

insert into platform_nft_holding_temp (address,
                                  platform,
                                  quote_token,
                                  token,
                                  total_transfer_volume,
                                  total_transfer_count,
                                  total_transfer_to_volume,
                                  total_transfer_to_count,
                                  total_transfer_all_volume,
                                  total_transfer_all_count,
                                  recent_time_code)
    (select address,
            platform,
            quote_token,
            token,
            sum(total_transfer_volume),
            sum(total_transfer_count),
            sum(total_transfer_to_volume),
            sum(total_transfer_to_count),
            sum(total_transfer_all_volume),
            sum(total_transfer_all_count),
            recent_time_code
     from platform_nft_holding_middle
     group by address, platform, quote_token, token,recent_time_code);
update platform_nft_holding_temp set platform_group='LooksRare' where platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a';
update platform_nft_holding_temp set platform_group='opensea' where platform in ('0x7be8076f4ea4a4ad08075c2508e481d6c946d12b', '0x00000000006c3852cbef3e08e8df289169ede581', '0x7f268357a8c2552623316e2562d90e642bb538e5');
update platform_nft_holding_temp set platform_group='X2Y2' where platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3';
update platform_nft_holding_temp set platform_group='CryptoPunks' where platform = '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb';
update
    platform_nft_holding_temp
set
    platform_group = 'Blur.io: Marketplace'
where
        platform in ('0x000000000000ad05ccc4f10045630fb830b95127', '0x39da41747a83aee658334415666f3ef92dd0d541');
update
    platform_nft_holding_temp
set
    quote_token = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2',
    weth_token_flag = '1'
where
        quote_token = '0x0000000000a39bb272e79075ade125fd351887ac';

insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_holding' as table_name,'${batchDate}'  as batch_date;
