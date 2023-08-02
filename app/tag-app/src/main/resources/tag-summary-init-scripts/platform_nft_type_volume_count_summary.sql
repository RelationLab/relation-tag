insert
into
    platform_nft_type_volume_count_temp(address,
                                   platform_group,
                                   platform,
                                   quote_token,
                                   token,
                                   type,
                                   volume_usd,
                                   transfer_count,
                                   recent_time_code,
                                        nft_type)
select
    pnvu.address,
    pnvu.platform_group,
    pnvu.platform,
    pnvu.quote_token,
    pnvu.token,
    'Buy',
    pnvu.buy_volume_usd,
    pnh.total_transfer_to_count,
    pnvu.recent_time_code,
    'ERC721'
from
    platform_nft_volume_usd pnvu
        inner join platform_nft_holding_temp pnh on
                pnvu .address = pnh.address
            and pnvu."token" = pnh."token"
            and pnvu.quote_token = pnh.quote_token
            and pnvu.platform_group = pnh.platform_group
            and pnvu.platform = pnh.platform
            and pnvu.recent_time_code = pnh.recent_time_code;


insert
into
    platform_nft_type_volume_count_temp(address,
                                   platform_group,
                                   platform,
                                   quote_token,
                                   token,
                                   type,
                                   volume_usd,
                                   transfer_count,
                                   recent_time_code,
                                    nft_type)
select
    pnvu.address,
    pnvu.platform_group,
    pnvu.platform,
    pnvu.quote_token,
    pnvu.token,
    'Sale',
    pnvu.sell_volume_usd,
    pnh.total_transfer_count,
    pnvu.recent_time_code,
    'ERC721'
from
    platform_nft_volume_usd pnvu
        inner join platform_nft_holding_temp pnh on
                pnvu .address = pnh.address
            and pnvu."token" = pnh."token"
            and pnvu.quote_token = pnh.quote_token
            and pnvu.platform_group = pnh.platform_group
            and pnvu.platform = pnh.platform
            and pnvu.recent_time_code = pnh.recent_time_code;

insert
into
    platform_nft_type_volume_count_temp(address,
                                   platform_group,
                                   platform,
                                   quote_token,
                                   token,
                                   type,
                                   volume_usd,
                                   transfer_count,
                                   recent_time_code,
                                    nft_type)
select
    pntvc.address,
    pntvc.platform_group,
    pntvc.platform,
    pntvc.quote_token,
    pntvc.token,
    'ALL',
    sum(pntvc.volume_usd) as volume_usd,
    sum(pntvc.transfer_count) as transfer_count,
    pntvc.recent_time_code,
    nft_sync_address.nft_type
from
    platform_nft_type_volume_count_temp pntvc
        inner join (
        select
            address,type as nft_type
        from
            nft_sync_address nsa
        where
                type <> 'ERC1155') nft_sync_address on
        (pntvc.token = nft_sync_address.address)
group by
    pntvc.address,
    pntvc.platform_group,
    pntvc.platform,
    pntvc.quote_token,
    pntvc.token,
    pntvc.recent_time_code,
    nft_sync_address.nft_type;


insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_type_volume_count_summary' as table_name,'${batchDate}'  as batch_date;
