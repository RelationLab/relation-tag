DROP TABLE if exists public.platform_nft_type_volume_count;
CREATE TABLE public.platform_nft_type_volume_count (
                                                       address varchar(512) NOT NULL,
                                                       platform_group varchar(256) NULL,
                                                       platform varchar(512) NOT NULL,
                                                       quote_token varchar(512) NOT NULL,
                                                       "token" varchar(512) NOT NULL,
                                                       type varchar(20) NOT NULL,
                                                       volume_usd numeric(128, 30) NULL,
                                                       transfer_count int8 null,
                                                       created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       removed bool NULL DEFAULT false,
                                                       CONSTRAINT uk_pntvu_address_token_type_platform UNIQUE (address, token, type, quote_token, platform, platform_group)
);
truncate table platform_nft_type_volume_count;

insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Buy', pnvu.buy_volume_usd, pnh.total_transfer_to_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Sale', pnvu.sell_volume_usd, pnh.total_transfer_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;
--
--
--     insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
--     select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'ALL', pnvu.volume_usd, pnh.total_transfer_all_count+
--            ( select  total_transfer_count from nft_transfer_holding nth where nth.address=pnvu.address and nth.token=pnvu.token) from
--     platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token"
--     and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform ;
