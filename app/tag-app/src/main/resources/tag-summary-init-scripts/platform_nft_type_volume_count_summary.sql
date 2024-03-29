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
    case
        when pnvu.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' or
             pnvu.platform = '0x000000000000ad05ccc4f10045630fb830b95127'
            then '0x39da41747a83aee658334415666f3ef92dd0d541'
        when pnvu.platform = '0x00000000006c3852cbef3e08e8df289169ede581' or
             pnvu.platform = '0x7be8076f4ea4a4ad08075c2508e481d6c946d12b'
            or pnvu.platform = '0x7f268357a8c2552623316e2562d90e642bb538e5'
            then '0x00000000006c3852cbef3e08e8df289169ede581'
        else pnvu.platform
        end as platform,
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
    case
        when pnvu.platform = '0x39da41747a83aee658334415666f3ef92dd0d541' or
             pnvu.platform = '0x000000000000ad05ccc4f10045630fb830b95127'
            then '0x39da41747a83aee658334415666f3ef92dd0d541'
        when pnvu.platform = '0x00000000006c3852cbef3e08e8df289169ede581' or
             pnvu.platform = '0x7be8076f4ea4a4ad08075c2508e481d6c946d12b'
            or pnvu.platform = '0x7f268357a8c2552623316e2562d90e642bb538e5'
            then '0x00000000006c3852cbef3e08e8df289169ede581'
        else pnvu.platform
        end as platform,
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
    nft_sync_address_temp.nft_type
from
    platform_nft_type_volume_count_temp pntvc
        inner join (
        select
            address,type as nft_type
        from
            nft_sync_address_temp nsa
        where
                type <> 'ERC1155') nft_sync_address_temp on
        (pntvc.token = nft_sync_address_temp.address)
group by
    pntvc.address,
    pntvc.platform_group,
    pntvc.platform,
    pntvc.quote_token,
    pntvc.token,
    pntvc.recent_time_code,
    nft_sync_address_temp.nft_type;


insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_type_volume_count_summary' as table_name,'${batchDate}'  as batch_date;
