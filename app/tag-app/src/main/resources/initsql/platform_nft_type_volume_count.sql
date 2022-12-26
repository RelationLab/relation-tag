

insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Buy', pnvu.buy_volume_usd, pnh.total_transfer_to_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Sale', pnvu.sell_volume_usd, pnh.total_transfer_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


    insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'ALL', pnvu.volume_usd, pnh.total_transfer_all_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;
