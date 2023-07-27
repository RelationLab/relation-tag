insert into nft_buy_sell_holding_middle (address,
                                         token,
                                         total_transfer_buy_volume,
                                         total_transfer_buy_count,
                                         total_transfer_sell_volume,
                                         total_transfer_sell_count,
                                         updated_block_height,
                                         recent_time_code)
    (select from_address,
            token,
            0,
            0,
            sum(count),
            sum(value),
            max(block_number),
            '${recentTimeCode}' recent_time_code
     from (select from_address,
                  token,
                  0,
                  0,
                  1 as count,
                  sum(1) as value,
                  max(block_number) as block_number
           from platform_nft_tx_record
           where platform_nft_tx_record.block_number >= ${recentTimeBlockHeight}
           group by from_address, token,hash
          ) platform_nft_tx_record
     group by from_address, token);

insert
into
    nft_buy_sell_holding_middle (address,
                                 token,
                                 total_transfer_buy_volume,
                                 total_transfer_buy_count,
                                 total_transfer_sell_volume,
                                 total_transfer_sell_count,
                                 updated_block_height,
                                 recent_time_code)
    (
        select
            to_address,
            token,
            sum(count),
            sum(value),
            0,
            0,
            max(block_number),
            '${recentTimeCode}' recent_time_code
        from
            (
                select
                    to_address,
                    token,
                    1 as count,
			sum(1) as value,
			0,
			0,
			max(block_number) as block_number 
                from
                    platform_nft_tx_record where platform_nft_tx_record.block_number >= ${recentTimeBlockHeight}
                group by
                    to_address,
                    token,
                    hash) platform_nft_tx_record

        group by
            to_address,
            token);
insert into tag_result(table_name,batch_date)
SELECT 'nft_buy_sell_holding_middle_${recentTimeCode}' as table_name,'${batchDate}'  as batch_date;


