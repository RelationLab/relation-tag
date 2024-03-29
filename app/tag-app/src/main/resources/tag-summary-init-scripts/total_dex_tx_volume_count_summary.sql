---再计算dex_tx_volume_count_summary_temp的ALL(有些同一笔交易txHash同时LP和SWAP)
insert
into dex_tx_volume_count_summary_temp (address,
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
from dex_tx_volume_count_summary_temp dtvcr
group by dtvcr.address,
         dtvcr."token",
         dtvcr.project,
         recent_time_code;

insert
into
    dex_tx_volume_count_summary_temp(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                recent_time_code
)
select
    dtvcr.address,
    'ALL' AS token,
    dtvcr.type,
    project,
    max(block_height) block_height,
    sum(total_transfer_volume_usd) as total_transfer_volume_usd,
    sum(total_transfer_count) total_transfer_count,
    min(first_updated_block_height) first_updated_block_height,
    recent_time_code
from
    dex_tx_volume_count_summary_temp dtvcr
group by
    dtvcr.address,
    dtvcr.type,
    project,
    recent_time_code;
insert
into
    dex_tx_volume_count_summary_temp(address,
                                     token,
                                     type,
                                     project,
                                     block_height,
                                     total_transfer_volume_usd,
                                     total_transfer_count,
                                     first_updated_block_height,
                                     recent_time_code
)
select
    dtvcr.address,
    dtvcr.token,
    dtvcr.type,
    platform_temp.platform_large_code as project,
    max(block_height) block_height,
    sum(total_transfer_volume_usd) as total_transfer_volume_usd,
    sum(total_transfer_count) total_transfer_count,
    min(first_updated_block_height) first_updated_block_height,
    recent_time_code
from
    dex_tx_volume_count_summary_temp dtvcr
        left join  platform_temp on (dtvcr.project=platform_temp.platform)
where platform_temp.platform_large_code is not null
group by
    dtvcr.address,
    dtvcr.type,
    dtvcr.token,
    recent_time_code,
    platform_temp.platform_large_code;

insert into tag_result(table_name, batch_date)
SELECT 'total_dex_tx_volume_count_summary' as table_name, '${batchDate}' as batch_date;


