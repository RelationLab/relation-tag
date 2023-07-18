insert into platform_nft_holding (address,
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
    (select address,
            platform,
            quote_token,
            token,
            sum(total_transfer_volume),
            sum(total_transfer_count),
            sum(total_transfer_to_volume),
            sum(total_transfer_to_count),
            sum(total_transfer_all_volume),
            sum(total_transfer_all_count),
            recent_time_code
     from platform_nft_holding_middle
              inner join (select *
                          from recent_time
                          where recent_time.recent_time_code = '${recent_time_code}') recent_time
                         on (dex_tx_volume_count_record_filterate.block_height >= recent_time.block_height)
     group by address, platform, quote_token, token,recent_time_code);

update platform_nft_holding
set platform_group='LooksRare'
where platform = '0x59728544b08ab483533076417fbbb2fd0b17ce3a';
update platform_nft_holding
set platform_group='opensea'
where platform in ('0x7be8076f4ea4a4ad08075c2508e481d6c946d12b', '0x00000000006c3852cbef3e08e8df289169ede581',
                   '0x7f268357a8c2552623316e2562d90e642bb538e5');
update platform_nft_holding
set platform_group='X2Y2'
where platform = '0x74312363e45dcaba76c59ec49a7aa8a65a67eed3';

insert into tag_result(table_name, batch_date)
SELECT 'platform_nft_holding_${recent_time_code}' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;
