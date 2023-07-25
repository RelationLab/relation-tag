insert
into nft_holding(address,
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
       sum(balance),
       sum(total_transfer_volume),
       sum(total_transfer_count),
       sum(total_transfer_to_volume),
       sum(total_transfer_to_count),
       sum(total_transfer_mint_volume),
       sum(total_transfer_mint_count),
       sum(total_transfer_burn_volume),
       sum(total_transfer_burn_count),
       sum(total_transfer_all_volume),
       sum(total_transfer_all_count),
       max(updated_block_height),
       recent_time_code
from nft_holding_middle
group by address, token, recent_time_code;
insert into tag_result(table_name, batch_date)
SELECT 'nft_holding_summary' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;