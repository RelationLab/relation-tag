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

----------------增加blur的DEPOSIT和WITHDRAW
insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
select
    pdwtr."operator" as address,
    'Blur.io: Marketplace' as platform_group,
    '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
    pdwtr.quote_token as quote_token ,
    pdwtr."token" as "token" ,
    substring(pdwtr."type" , 1, 1)|| lower(substring(pdwtr."type" , 2, length(pdwtr."type" )-1))  as "type" ,
    sum(pdwtr.quote_value * w.price) as volume_usd ,
    count(1) as transfer_count
from
    platform_deposit_withdraw_tx_record pdwtr
        inner join white_list_erc20 w on
        (pdwtr.quote_token = w.address)
        inner join (
        select
            address
        from
            nft_sync_address nsa
        where
                type = 'ERC721') nft_sync_address on
        (pdwtr."token" = nft_sync_address.address)
group by
    pdwtr."operator" ,
    pdwtr.quote_token ,
    pdwtr."token" ,
    pdwtr."type";

insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
select
    address,
    'Blur.io: Marketplace' as platform_group,
    '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
    "token" as quote_token ,
    "token" ,
    'Lend' as "type" ,
    sum(volume_usd) as volume_usd ,
    sum(transfer_count) as transfer_count
from (
         ----------------增加blur的lend的from
         select
             address,
             "token" as quote_token ,
             "token" ,
             sum(volume_usd) as volume_usd ,
             sum(transfer_count) as transfer_count
         from
             (
                 select
                     pltr.borrower as address,
                     pltr.lend_token as "token" ,
                     pltr."type" as "type" ,
                     sum(1) as volume_usd ,
                     1 as transfer_count
                 from
                     platform_lend_tx_record pltr inner join (
                         select
                             address
                         from
                             nft_sync_address nsa
                         where
                                 type = 'ERC721') nft_sync_address on
                         (pltr.lend_token = nft_sync_address.address)
                 group by
                     pltr.borrower ,
                     pltr.lend_token ,
                     pltr."type",
                     hash ) pltrout
         group by
             pltrout.address ,
             pltrout.token
             ----------------增加blur的lend的to
         union all
         select
             pltr.lender as address,
             pltr.lend_token  as quote_token ,
             pltr.lend_token as "token" ,
             sum(1) as volume_usd ,
             0 as transfer_count
         from
             platform_lend_tx_record pltr
                 inner join (
                 select
                     address
                 from
                     nft_sync_address nsa
                 where
                         type = 'ERC721') nft_sync_address on
                 (pltr.lend_token = nft_sync_address.address)
         group by
             pltr.lender ,
             pltr.lend_token) lendt
group by
    lendt.address ,
    lendt.token;




insert
into
    platform_nft_type_volume_count(address,
                                   platform_group,
                                   platform,
                                   quote_token,
                                   token,
                                   type,
                                   volume_usd,
                                   transfer_count)
select
    address,
    'Blur.io: Marketplace' as platform_group,
    '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
    "token" as quote_token ,
    "token" ,
    'Bid' "type" ,
    sum(volume_usd) as volume_usd ,
    sum(transfer_count) as transfer_count
from
    (
        ----------------增加blur的bid的buyer(buyer不一定是from)
        select
            address,
            "token" as quote_token ,
            "token" ,
            sum(volume_usd) as volume_usd ,
            sum(transfer_count) as transfer_count
        from
            (
                select
                    pbtr.buyer as address,
                    pbtr.nft_token as "token" ,
                    'Bid' as "type" ,
                    sum(1) as volume_usd ,
                    case
                        when type = 'ASK' then 1
                        else 0
                        end as transfer_count
                from
                    platform_bid_tx_record pbtr
                        inner join (
                        select
                            address
                        from
                            nft_sync_address nsa
                        where
                                type = 'ERC721') nft_sync_address on
                        (pbtr.nft_token = nft_sync_address.address)
                group by
                    pbtr.buyer ,
                    pbtr.nft_token ,
                    pbtr."type",
                    hash ) pbtrout
        group by
            pbtrout.address ,
            pbtrout.token
        union all
        ----------------增加blur的bid的seller(seller不一定是from)
        select
            address,
            "token" as quote_token ,
            "token" ,
            sum(volume_usd) as volume_usd ,
            sum(transfer_count) as transfer_count
        from
            (
                select
                    pbtr.seller as address,
                    pbtr.nft_token as "token" ,
                    'Bid' as "type" ,
                    sum(1) as volume_usd ,
                    case
                        when type = 'BID' then 1
                        else 0
                        end as transfer_count
                from
                    platform_bid_tx_record pbtr
                        inner join (
                        select
                            address
                        from
                            nft_sync_address nsa
                        where
                                type = 'ERC721') nft_sync_address on
                        (pbtr.nft_token = nft_sync_address.address)
                group by
                    pbtr.seller ,
                    pbtr.nft_token ,
                    pbtr."type",
                    hash ) pbtrout
        group by
            pbtrout.address ,
            pbtrout.token) bidt
group by
    bidt.address ,
    bidt.token;

insert
into
    platform_nft_type_volume_count(address,
                                   platform_group,
                                   platform,
                                   quote_token,
                                   token,
                                   type,
                                   volume_usd,
                                   transfer_count)
select
    pntvc.address,
    pntvc.platform_group,
    pntvc.platform,
    pntvc.quote_token,
    pntvc.token,
    'ALL',
    sum(pntvc.volume_usd) as volume_usd,
    sum(pntvc.transfer_count) as transfer_count
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
    pntvc.token;


insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_type_volume_count' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
