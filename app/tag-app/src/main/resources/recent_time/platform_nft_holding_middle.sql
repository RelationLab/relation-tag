insert into platform_nft_holding_middle (address,
                                         platform,
                                         quote_token,
                                         token,
                                         total_transfer_volume,
                                         total_transfer_count,
                                         total_transfer_to_volume,
                                         total_transfer_to_count,
                                         total_transfer_all_volume,
                                         total_transfer_all_count,
                                         recent_time_code)
    (select from_address,
            platform_address,
            quote_token,
            token,
            sum(value),
            sum(count),
            0,
            0,
            sum(value),
            sum(count),
            recent_time_code
     from platform_nft_tx_record
              inner join (select *
                          from recent_time
                          where recent_time.recent_time_code = '${recent_time_code}') recent_time on
         (platform_nft_tx_record.block_number >= recent_time.block_height)
     group by from_address, platform_address, quote_token, token,
              recent_time_code);


insert into platform_nft_holding_middle (address,
                                         platform,
                                         quote_token,
                                         token,
                                         total_transfer_volume,
                                         total_transfer_count,
                                         total_transfer_to_volume,
                                         total_transfer_to_count,
                                         total_transfer_all_volume,
                                         total_transfer_all_count,
                                         recent_time_code)
    (select to_address,
            platform_address,
            quote_token,
            token,
            0,
            0,
            sum(value),
            sum(count),
            sum(value),
            sum(count),
            recent_time_code
     from platform_nft_tx_record inner join (select *
                                            from recent_time
                                            where recent_time.recent_time_code = '${recent_time_code}') recent_time on
         (platform_nft_tx_record.block_number >= recent_time.block_height)
     group by to_address, platform_address, quote_token, token,
              recent_time_code);
insert into tag_result(table_name, batch_date)
SELECT 'platform_nft_holding_middle_${recent_time_code}' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;
