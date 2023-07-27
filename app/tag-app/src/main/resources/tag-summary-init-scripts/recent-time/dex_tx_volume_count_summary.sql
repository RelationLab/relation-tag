---汇总UNIv3的LP数据
insert
into dex_tx_volume_count_summary(address,
                                 token,
                                 type,
                                 project,
                                 block_height,
                                 total_transfer_volume_usd,
                                 total_transfer_count,
                                 first_updated_block_height,
                                 recent_time_code)
select th.address,
       th.price_token                               as token,
       th.type                                      as type,
       '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
       max(th.block_height)                         as block_height,
       sum(total_transfer_volume)                   as total_transfer_volume_usd,
       sum(total_transfer_count)                    as total_transfer_count,
       min(first_updated_block_height)              as first_updated_block_height,
       '${recentTimeCode}'                 as recent_time_code
from token_holding_uni_filter th
    where th.block_height >= ${recentTimeBlockHeight}
group by th.address,
         th.price_token,
         th.type;

---汇总UNIv3的token=ALL数据
insert
into dex_tx_volume_count_summary(address,
                                 token,
                                 type,
                                 project,
                                 block_height,
                                 total_transfer_volume_usd,
                                 total_transfer_count,
                                 first_updated_block_height,
                                 recent_time_code)
select th.address,
       'ALL'                                        as token,
       th.type                                      as type,
       '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
       max(th.block_height)                         as block_height,
       sum(total_transfer_volume)                   as total_transfer_volume_usd,
       sum(total_transfer_count)                    as total_transfer_count,
       min(first_updated_block_height)              as first_updated_block_height,
       '${recentTimeCode}'                as recent_time_code
from token_holding_uni_filter th
    where th.block_height >= ${recentTimeBlockHeight}
group by th.address,
         th.type;

---先把dex_tx_volume_count_record的USD计算出来
insert
into dex_tx_volume_count_summary(address,
                                 token,
                                 type,
                                 project,
                                 block_height,
                                 total_transfer_volume_usd,
                                 total_transfer_count,
                                 first_updated_block_height,
                                 recent_time_code)
select dtvcr.address,
       token,
       dtvcr.type,
       project,
       max(dtvcr.block_height)                 block_height,
       sum(total_transfer_volume_usd) as total_transfer_volume_usd,
       sum(total_transfer_count)         total_transfer_count,
       min(first_updated_block_height)   first_updated_block_height,
       '${recentTimeCode}' recent_time_code
from dex_tx_volume_count_record_filter dtvcr
    where dtvcr.block_height >= ${recentTimeBlockHeight}
group by dtvcr.address,
         token,
         dtvcr.type,
         project;

---计算token为ALL的 也是从dex_tx_volume_count_record的USD计算出来
insert
into dex_tx_volume_count_summary(address,
                                 token,
                                 type,
                                 project,
                                 block_height,
                                 total_transfer_volume_usd,
                                 total_transfer_count,
                                 first_updated_block_height,
                                 recent_time_code)
select dtvcr.address,
       'ALL'                          AS token,
       dtvcr.type,
       project,
       max(dtvcr.block_height)                 block_height,
       sum(total_transfer_volume_usd) as total_transfer_volume_usd,
       sum(total_transfer_count)         total_transfer_count,
       min(first_updated_block_height)   first_updated_block_height,
       '${recentTimeCode}' recent_time_code
from dex_tx_volume_count_record_filter dtvcr
    where dtvcr.block_height >= ${recentTimeBlockHeight}
group by dtvcr.address,
         dtvcr.type,
         project;
insert into tag_result(table_name, batch_date)
SELECT 'dex_tx_volume_count_summary_${recentTimeCode}' as table_name, '${batchDate}' as batch_date;


