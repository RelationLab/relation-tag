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
            1,
            0,
            0,
            sum(value),
            1,
            '${recentTimeCode}' recent_time_code
     from platform_nft_tx_record
              INNER JOIN nft_sync_address_temp ON(nft_sync_address_temp.address=platform_nft_tx_record.token)
     where nft_sync_address_temp.type <> 'ERC1155' and platform_nft_tx_record.block_number >= ${recentTimeBlockHeight}
     group by from_address, platform_address, quote_token, token,hash);


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
            1,
            sum(value),
            1,
            '${recentTimeCode}' recent_time_code
     from platform_nft_tx_record
          INNER JOIN nft_sync_address_temp ON(nft_sync_address_temp.address=platform_nft_tx_record.token)
     where nft_sync_address_temp.type <> 'ERC1155' and platform_nft_tx_record.block_number >= ${recentTimeBlockHeight}
     group by to_address, platform_address, quote_token, token,hash);
insert into tag_result(table_name, batch_date)
SELECT 'platform_nft_holding_middle_${recentTimeCode}' as table_name, '${batchDate}' as batch_date;
