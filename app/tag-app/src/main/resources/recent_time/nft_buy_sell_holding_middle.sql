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
            recent_time_code
     from (select from_address,
                  token,
                  0,
                  0,
                  1 as count,
                  sum(1) as value,
                  max(block_number) as block_number,
       recent_time_code
           from platform_nft_tx_record inner join (select *
               from recent_time
               where recent_time.recent_time_code = '${recent_time_code}') recent_time on
               (platform_nft_tx_record.block_number >= recent_time.block_height)
           group by from_address, token,hash,
               recent_time_code
          ) platform_nft_tx_record
     group by from_address, token,
              recent_time_code);

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
            recent_time_code
        from
            (
                select
                    to_address,
                    token,
                    1 as count,
			sum(1) as value,
			0,
			0,
			max(block_number) as block_number,
			recent_time_code
                from
                    platform_nft_tx_record
                group by
                    to_address,
                    token,
                    hash,
                    recent_time_code) platform_nft_tx_record
                inner join (
                select
                    *
                from
                    recent_time
                where
                        recent_time.recent_time_code = '${recent_time_code}') recent_time on
                (platform_nft_tx_record.block_number >= recent_time.block_height)
        group by
            to_address,
            token,
            recent_time_code);
insert into tag_result(table_name,batch_date)
SELECT 'nft_buy_sell_holding_middle_${recent_time_code}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;


