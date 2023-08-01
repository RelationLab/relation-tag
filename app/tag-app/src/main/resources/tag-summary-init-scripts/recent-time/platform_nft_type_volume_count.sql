----------------增加blur的DEPOSIT和WITHDRAW
insert into platform_nft_type_volume_count_temp(recent_time_code,
                                           address,
                                           platform_group,
                                           platform,
                                           quote_token,
                                           token,
                                           type,
                                           volume_usd,
                                            transfer_count)
select  '${recentTimeCode}' recent_time_code,
       pdwtr."operator"                                                                             as address,
       'Blur.io: Marketplace'                                                                       as platform_group,
       '0x00000000006c3852cbef3e08e8df289169ede581'                                                 as platform,
       pdwtr.quote_token                                                                            as quote_token,
       pdwtr."token"                                                                                as "token",
       substring(pdwtr."type", 1, 1) || lower(substring(pdwtr."type", 2, length(pdwtr."type") - 1)) as "type",
       sum(pdwtr.quote_value * w.price)                                                             as volume_usd,
       count(1)                                                                                     as transfer_count
from platform_deposit_withdraw_tx_record pdwtr
         inner join white_list_erc20_temp w on
    (pdwtr.quote_token = w.address)
         inner join (select address
                     from nft_sync_address nsa
                     where type = 'ERC721-token') nft_sync_address on
    (pdwtr."token" = nft_sync_address.address)
where pdwtr.block_number >= ${recentTimeBlockHeight} 
group by pdwtr."operator",
         pdwtr.quote_token,
         pdwtr."token",
         pdwtr."type";

insert into platform_nft_type_volume_count_temp(recent_time_code,
                                                address,
                                                platform_group,
                                                platform,
                                                quote_token,
                                                token,
                                                type,
                                                volume_usd,
                                                transfer_count)
select  '${recentTimeCode}' recent_time_code,
        pdwtr."operator"                                                                             as address,
        'Blur.io: Marketplace'                                                                       as platform_group,
        '0x00000000006c3852cbef3e08e8df289169ede581'                                                 as platform,
        pdwtr.quote_token                                                                            as quote_token,
        pdwtr.quote_token                                                                               as "token",
        substring(pdwtr."type", 1, 1) || lower(substring(pdwtr."type", 2, length(pdwtr."type") - 1)) as "type",
        sum(pdwtr.quote_value * w.price)                                                             as volume_usd,
        count(1)                                                                                     as transfer_count
from platform_deposit_withdraw_tx_record pdwtr
         inner join white_list_erc20_temp w on
    (pdwtr.quote_token = w.address)
         inner join (select address
                     from nft_sync_address nsa
                     where type = 'ERC721-token') nft_sync_address on
    (pdwtr."token" = nft_sync_address.address)
where pdwtr.block_number >= ${recentTimeBlockHeight}
group by pdwtr."operator",
         pdwtr.quote_token,
         pdwtr."token",
         pdwtr."type";


insert into platform_nft_type_volume_count_temp(recent_time_code,
                                           address,
                                           platform_group,
                                           platform,
                                           quote_token,
                                           token,
                                           type,
                                           volume_usd,
                                            volume,
                                           transfer_count)
select  '${recentTimeCode}' recent_time_code,
       address,
       'Blur.io: Marketplace'                       as platform_group,
       '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
       "token"                                      as quote_token,
       "token",
       'Lend'                                       as "type",
       sum(volume_usd)                              as volume_usd,
        sum(volume)     as volume,
        sum(transfer_count)                          as transfer_count
from (
         select address,
                "token"             as quote_token,
                "token" as token,
                sum(volume_usd)     as volume_usd,
                sum(volume)     as volume,
                sum(transfer_count) as transfer_count
         from (select pltr.borrower   as address,
                      pltr.pledge_token as "token",
                      pltr."type"     as "type",
                      sum(w.price*lend_value)          as volume_usd,
                      sum(1)          as volume,
                      1               as transfer_count
               from platform_lend_tx_record pltr
                        inner join (select address
                                    from nft_sync_address nsa
                                    where type = 'ERC721') nft_sync_address on
                   (pltr.pledge_token = nft_sync_address.address)
                        inner join white_list_erc20_temp w on
                   (w.address='eth')
               where pltr.block_number >=${recentTimeBlockHeight}
               group by pltr.borrower,
                        pltr.pledge_token,
                        pltr."type",
                        hash) pltrout
         group by pltrout.address,
                  pltrout.token
                  ----------------增加blur的lend的to
         union all
         select pltr.lender     as address,
                pltr.pledge_token as quote_token,
                pltr.pledge_token as "token",
                sum(w.price*lend_value)          as volume_usd,
                sum(1)          as volume,
                0               as transfer_count
         from platform_lend_tx_record pltr
                  inner join (select address
                              from nft_sync_address nsa
                              where type = 'ERC721') nft_sync_address on
             (pltr.pledge_token = nft_sync_address.address)
              inner join white_list_erc20_temp w on
             (w.address='eth')
         where pltr.block_number >=${recentTimeBlockHeight}
         group by pltr.lender,
                  pltr.pledge_token) lendt
group by lendt.address,
         lendt.token;



insert
into platform_nft_type_volume_count_temp(recent_time_code,
                                    address,
                                    platform_group,
                                    platform,
                                    quote_token,
                                    token,
                                    type,
                                    volume_usd,
                                     volume,
                                    transfer_count)
select  '${recentTimeCode}' recent_time_code,
                                                       address,
       'Blur.io: Marketplace'                       as platform_group,
       '0x00000000006c3852cbef3e08e8df289169ede581' as platform,
       "token"                                      as quote_token,
       "token",
       'Bid'                                           "type",
        sum(volume_usd)                              as volume_usd,
        sum(volume)     as volume,
       sum(transfer_count)                          as transfer_count
from (
         ----------------增加blur的bid的buyer(buyer不一定是from)
         select
                address,
                "token"             as quote_token,
                "token",
                sum(volume_usd)                              as volume_usd,
                sum(volume)     as volume,
                sum(transfer_count) as transfer_count
         from (select pbtr.buyer     as address,
                      pbtr.nft_token as "token",
                      'Bid'          as "type",
                      sum(w.price*amount)          as volume_usd,
                      sum(1)          as volume,
                      case
                          when pbtr.type = 'ASK' then 1
                          else 0
                          end        as transfer_count
               from platform_bid_tx_record pbtr
                        inner join (select address
                                    from nft_sync_address nsa
                                    where type = 'ERC721') nft_sync_address on
                   (pbtr.nft_token = nft_sync_address.address)
                        inner join white_list_erc20_temp w on
                   (w.address='eth')
               where pbtr.block_number >= ${recentTimeBlockHeight}
               group by pbtr.buyer,
                        pbtr.nft_token,
                        pbtr."type",
                        hash) pbtrout
         group by pbtrout.address,
                  pbtrout.token
         union all
         ----------------增加blur的bid的seller(seller不一定是from)
         select
                                       address,
                "token"             as quote_token,
                "token",
               sum(volume_usd)                              as volume_usd,
               sum(volume)     as volume,
                sum(transfer_count) as transfer_count
         from (select pbtr.seller    as address,
                      pbtr.nft_token as "token",
                      'Bid'          as "type",
                      sum(w.price*amount)          as volume_usd,
                      sum(1)          as volume,
                      case
                          when pbtr.type = 'BID' then 1
                          else 0
                          end        as transfer_count
               from platform_bid_tx_record pbtr
                        inner join (select address
                                    from nft_sync_address nsa
                                    where type = 'ERC721') nft_sync_address on
                   (pbtr.nft_token = nft_sync_address.address)
                        inner join white_list_erc20_temp w on
                   (w.address='eth')
               where pbtr.block_number >= ${recentTimeBlockHeight}
               group by pbtr.seller,
                        pbtr.nft_token,
                        pbtr."type",
                        hash) pbtrout
         group by pbtrout.address,
                  pbtrout.token) bidt
group by bidt.address,
         bidt.token;

insert into tag_result(table_name, batch_date)
SELECT 'platform_nft_type_volume_count_${recentTimeCode}' as table_name,
       '${batchDate}'                  as batch_date;
