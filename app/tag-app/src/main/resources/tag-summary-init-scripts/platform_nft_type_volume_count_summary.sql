insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Buy', pnvu.buy_volume_usd, pnh.total_transfer_to_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token"
        and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform
                                                                            and pnvu.recent_time_code=pnh.recent_time_code;


insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Sale', pnvu.sell_volume_usd, pnh.total_transfer_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token"
        and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform and pnvu.recent_time_code=pnh.recent_time_code;


insert
into
    platform_nft_type_volume_count(address,
                                   platform_group,
                                   platform,
                                   quote_token,
                                   token,
                                   type,
                                   volume_usd,
                                   transfer_count,
                                   recent_time_code)
select
    pntvc.address,
    pntvc.platform_group,
    pntvc.platform,
    pntvc.quote_token,
    pntvc.token,
    'ALL',
    sum(pntvc.volume_usd) as volume_usd,
    sum(pntvc.transfer_count) as transfer_count,
    pntvc.recent_time_code
from
    platform_nft_type_volume_count pntvc
        inner join (
        select
            address
        from
            nft_sync_address nsa
        where
                type = 'ERC721') nft_sync_address on
        (pntvc.token = nft_sync_address.address)
group by
    pntvc.address,
    pntvc.platform_group,
    pntvc.platform,
    pntvc.quote_token,
    pntvc.token,
    pntvc.recent_time_code;


insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_type_volume_count_summary' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
