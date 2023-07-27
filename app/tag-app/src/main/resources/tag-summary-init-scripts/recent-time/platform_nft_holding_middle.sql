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
            '${recentTimeCode}' recent_time_code
     from platform_nft_tx_record
              INNER JOIN nft_sync_address ON(nft_sync_address.address=platform_nft_tx_record.token)
     where nft_sync_address.type <> 'ERC1155' and platform_nft_tx_record.block_number >= ${recentTimeBlockHeight}
     group by from_address, platform_address, quote_token, token);


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
            '${recentTimeCode}' recent_time_code
     from platform_nft_tx_record
          INNER JOIN nft_sync_address ON(nft_sync_address.address=platform_nft_tx_record.token)
     where nft_sync_address.type <> 'ERC1155' and platform_nft_tx_record.block_number >= ${recentTimeBlockHeight}
     group by to_address, platform_address, quote_token, token);
insert into tag_result(table_name, batch_date)
SELECT 'platform_nft_holding_middle_${recentTimeCode}' as table_name, '${batchDate}' as batch_date;
