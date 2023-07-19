DROP TABLE if exists public.platform_nft_type_volume_count;
CREATE TABLE public.platform_nft_type_volume_count (
                                                       address varchar(512) NOT NULL,
                                                       platform_group varchar(256) NULL,
                                                       platform varchar(512) NOT NULL,
                                                       quote_token varchar(512) NOT NULL,
                                                       "token" varchar(512) NOT NULL,
                                                       type varchar(100) NOT NULL,
                                                       volume_usd numeric(128, 30) NULL,
                                                       transfer_count int8 null,
                                                       created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       removed bool NULL DEFAULT false,
                                                       recent_time_code varchar(30)  null
)distributed by (address, token, quote_token, platform);
truncate table platform_nft_type_volume_count;
vacuum platform_nft_type_volume_count;

insert into platform_nft_type_volume_count(recent_time_code,address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.recent_time_code,pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Buy', pnvu.buy_volume_usd, pnh.total_transfer_to_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


insert into platform_nft_type_volume_count(recent_time_code,address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.recent_time_code,pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Sale', pnvu.sell_volume_usd, pnh.total_transfer_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


    insert into platform_nft_type_volume_count(recent_time_code,address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select
        pnvu.recent_time_code,
        pnh.address,
        pnh.platform_group,
        pnh.platform,
        pnh.quote_token,
        pnh.token,
        'ALL',
        pnvu.volume_usd,
        pnh.total_transfer_all_count
    from
        platform_nft_holding pnh
            inner join (
            select
                address
            from
                nft_sync_address nsa
            where
                    type = 'ERC721') nft_sync_address on
            (pnh.token = nft_sync_address.address)
            left join platform_nft_volume_usd pnvu on
                    pnvu .address = pnh.address
                and pnvu."token" = pnh."token"
                and pnvu.quote_token = pnh.quote_token
                and pnvu.platform_group = pnh.platform_group
                and pnvu.platform = pnh.platform ;
insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_type_volume_count' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
