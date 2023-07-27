---再计算dex_tx_volume_count_summary的ALL(有些同一笔交易txHash同时LP和SWAP)
insert
into dex_tx_volume_count_summary (address,
                                  token,
                                  type,
                                  project,
                                  block_height,
                                  total_transfer_volume_usd,
                                  total_transfer_count,
                                  first_updated_block_height,
                                  recent_time_code)

select dtvcr.address                         as address
     , dtvcr.token                           as token
     , 'ALL'                                 as type
     , dtvcr.project                         as project
     , min(dtvcr.block_height)               as block_height
     , sum(dtvcr.total_transfer_volume_usd)  as total_transfer_volume_usd
     , sum(dtvcr.total_transfer_count)       as total_transfer_count
     , min(dtvcr.first_updated_block_height) as first_updated_block_height
     , dtvcr.recent_time_code                as recent_time_code
from dex_tx_volume_count_summary dtvcr
group by dtvcr.address,
         dtvcr."token",
         dtvcr.project,
         recent_time_code;
insert into tag_result(table_name, batch_date)
SELECT 'dex_tx_volume_count_summary' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;


