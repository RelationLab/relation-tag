insert
into nft_holding (address,
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
       recent_time_code                recent_time_code
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
             max(updated_block_height)       updated_block_height,
             recent_time_code                recent_time_code
      from nft_holding_record
               inner join (select *
                           from recent_time
                           where recent_time.recent_time_code = '${recent_time_code}') recent_time on
          (nft_holding_record.updated_block_height >= recent_time.block_height)
      group by address, token, transaction_hash, nft_token_id, recent_time_code) t
group by address,
         token,
         recent_time_code;
insert into tag_result(table_name, batch_date)
SELECT 'nft_holding_record_${recent_time_code}' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;
