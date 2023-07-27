insert
into nft_holding_temp (address,
                  token,
                  balance,
                  total_transfer_volume,
                  total_transfer_count,
                  total_transfer_to_volume,
                  total_transfer_to_count,
                  total_transfer_mint_volume,
                  total_transfer_mint_count,
                  total_transfer_burn_volume,
                  total_transfer_burn_count,
                  total_transfer_all_volume,
                  total_transfer_all_count,
                  updated_block_height,
                  recent_time_code)
select address,
       token,
       sum(balance)                    balance,
       sum(total_transfer_volume)      total_transfer_volume,
       sum(total_transfer_count)       total_transfer_count,
       sum(total_transfer_to_volume)   total_transfer_to_volume,
       sum(total_transfer_to_count)    total_transfer_to_count,
       sum(total_transfer_mint_volume) total_transfer_mint_volume,
       sum(total_transfer_mint_count)  total_transfer_mint_count,
       sum(total_transfer_burn_volume) total_transfer_burn_volume,
       sum(total_transfer_burn_count)  total_transfer_burn_count,
       sum(total_transfer_volume + total_transfer_to_volume + total_transfer_mint_volume +
           total_transfer_burn_volume) total_transfer_all_volume,
       sum(total_transfer_count + total_transfer_to_count + total_transfer_mint_count +
           total_transfer_burn_count)  total_transfer_all_count,
       max(updated_block_height)       updated_block_height,
       '${recentTimeCode}' recent_time_code
from (select address,
             case
                 when token = '0x6ba6f2207e343923ba692e5cae646fb0f566db8d'
                     then '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb'
                 else token
                 end as                      token,
             sum(balance)                    balance,
             sum(total_transfer_volume)      total_transfer_volume,
             sum(total_transfer_count)       total_transfer_count,
             sum(total_transfer_to_volume)   total_transfer_to_volume,
             sum(total_transfer_to_count)    total_transfer_to_count,
             sum(total_transfer_mint_volume) total_transfer_mint_volume,
             sum(total_transfer_mint_count)  total_transfer_mint_count,
             sum(total_transfer_burn_volume) total_transfer_burn_volume,
             sum(total_transfer_burn_count)  total_transfer_burn_count,
             max(updated_block_height)       updated_block_height
      from nft_holding_record
              where nft_holding_record.updated_block_height>=${recentTimeBlockHeight}
      group by address, token, transaction_hash, nft_token_id) t
group by address,
         token;
insert into tag_result(table_name, batch_date)
SELECT 'nft_holding_record_${recentTimeCode}' as table_name, '${batchDate}' as batch_date;
