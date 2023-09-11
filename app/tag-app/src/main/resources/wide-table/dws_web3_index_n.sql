truncate table dws_web3_index_n;
insert into dws_web3_index_n
select 'web3'                                                                                 as b_type           --  业务类型
     , 'web3'                                                                                    statistical_type -- 业务统计类型
     , s1.address                                                                                                 --地址
     , s1.project                                                                                                 -- 项目
     , s2.platform_name_alis                                                                  as platform_name
     , 'ALL'                                                                                  as token
     , s1.type                                                                                                    -- 类型
     , cast(null as timestamp)                                                                as first_tx_time    --最早交易时间
     , cast(null as timestamp)                                                                as latest_tx_time   -- 最后交易时间
     , sum(case when s1.recent_time_code = 'ALL' then s1.total_transfer_count else null end)  as transaction_count
     , sum(case when s1.recent_time_code = 'ALL' then s1.total_transfer_volume else null end) as transaction_volume
     , sum(case when s1.recent_time_code = 'ALL' then s1.balance else null end)               as balance_count
     , cast(null as int)                                                                      as balance_usd
     , cast(null as int)                                                                      as days
     , sum(case when s1.recent_time_code = '3d' then s1.total_transfer_volume else null end)  as transaction_volume_3d
     , sum(case when s1.recent_time_code = '7d' then s1.total_transfer_volume else null end)  as transaction_volume_7d
     , sum(case when s1.recent_time_code = '15d' then s1.total_transfer_volume else null end) as transaction_volume_15d
     , sum(case when s1.recent_time_code = '1m' then s1.total_transfer_volume else null end)  as transaction_volume_1m
     , sum(case when s1.recent_time_code = '3m' then s1.total_transfer_volume else null end)  as transaction_volume_3m
     , sum(case when s1.recent_time_code = '6m' then s1.total_transfer_volume else null end)  as transaction_volume_6m
     , sum(case when s1.recent_time_code = '1y' then s1.total_transfer_volume else null end)  as transaction_volume_1y
     , sum(case when s1.recent_time_code = '2y' then s1.total_transfer_volume else null end)  as transaction_volume_2y

     , sum(case when s1.recent_time_code = '3d' then s1.total_transfer_count else null end)   as transaction_count_3d
     , sum(case when s1.recent_time_code = '7d' then s1.total_transfer_count else null end)   as transaction_count_7d
     , sum(case when s1.recent_time_code = '15d' then s1.total_transfer_count else null end)  as transaction_count_15d
     , sum(case when s1.recent_time_code = '1m' then s1.total_transfer_count else null end)   as transaction_count_1m
     , sum(case when s1.recent_time_code = '3m' then s1.total_transfer_count else null end)   as transaction_count_3m
     , sum(case when s1.recent_time_code = '6m' then s1.total_transfer_count else null end)   as transaction_count_6m
     , sum(case when s1.recent_time_code = '1y' then s1.total_transfer_count else null end)   as transaction_count_1y
     , sum(case when s1.recent_time_code = '2y' then s1.total_transfer_count else null end)   as transaction_count_2y
     , now()                                                                                  as etl_update_time
from web3_transaction_record_summary_temp s1
         left join web3_platform s2
                   on s1.project = s2.platform
group by s1.address --地址
       , s1.project -- 项目
       , s2.platform_name_alis
       , s1.type    -- 类型
union all
select 'web3'                                                                                 as b_type           --  业务类型
     , 'web3'                                                                                    statistical_type -- 业务统计类型
     , s1.address                                                                                                 --地址
     , 'ALL'                                                                                  AS project          -- 项目
     , 'ALL'                                                                                  as platform_name
     , 'ALL'                                                                                  as token
     , s1.type                                                                                                    -- 类型
     , cast(null as timestamp)                                                                as first_tx_time    --最早交易时间
     , cast(null as timestamp)                                                                as latest_tx_time   -- 最后交易时间
     , sum(case when s1.recent_time_code = 'ALL' then s1.total_transfer_count else null end)  as transaction_count
     , sum(case when s1.recent_time_code = 'ALL' then s1.total_transfer_volume else null end) as transaction_volume
     , sum(case when s1.recent_time_code = 'ALL' then s1.balance else null end)               as balance_count
     , null                                                                                   as balance_usd
     , cast(null as int)                                                                      as days
     , sum(case when s1.recent_time_code = '3d' then s1.total_transfer_volume else null end)  as transaction_volume_3d
     , sum(case when s1.recent_time_code = '7d' then s1.total_transfer_volume else null end)  as transaction_volume_7d
     , sum(case when s1.recent_time_code = '15d' then s1.total_transfer_volume else null end) as transaction_volume_15d
     , sum(case when s1.recent_time_code = '1m' then s1.total_transfer_volume else null end)  as transaction_volume_1m
     , sum(case when s1.recent_time_code = '3m' then s1.total_transfer_volume else null end)  as transaction_volume_3m
     , sum(case when s1.recent_time_code = '6m' then s1.total_transfer_volume else null end)  as transaction_volume_6m
     , sum(case when s1.recent_time_code = '1y' then s1.total_transfer_volume else null end)  as transaction_volume_1y
     , sum(case when s1.recent_time_code = '2y' then s1.total_transfer_volume else null end)  as transaction_volume_2y

     , sum(case when s1.recent_time_code = '3d' then s1.total_transfer_count else null end)   as transaction_count_3d
     , sum(case when s1.recent_time_code = '7d' then s1.total_transfer_count else null end)   as transaction_count_7d
     , sum(case when s1.recent_time_code = '15d' then s1.total_transfer_count else null end)  as transaction_count_15d
     , sum(case when s1.recent_time_code = '1m' then s1.total_transfer_count else null end)   as transaction_count_1m
     , sum(case when s1.recent_time_code = '3m' then s1.total_transfer_count else null end)   as transaction_count_3m
     , sum(case when s1.recent_time_code = '6m' then s1.total_transfer_count else null end)   as transaction_count_6m
     , sum(case when s1.recent_time_code = '1y' then s1.total_transfer_count else null end)   as transaction_count_1y
     , sum(case when s1.recent_time_code = '2y' then s1.total_transfer_count else null end)   as transaction_count_2y
     , now()                                                                                  as etl_update_time
from web3_transaction_record_summary_temp s1
         left join web3_platform s2
                   on s1.project = s2.platform
group by s1.address --地址
       , s1.type    -- 类型

union all
select 'web3'                  as b_type           --  业务类型
     , 'web3'                     statistical_type -- 业务统计类型
     , s1.address                                  --地址
     , s1.project                                  -- 项目
     , s2.platform_name_alis   as platform_name
     , 'ALL'                   as token
     , 'ALL'                   AS type             -- 类型
     , cast(null as timestamp) as first_tx_time    --最早交易时间
     , cast(null as timestamp) as latest_tx_time   -- 最后交易时间
     , sum(case
               when s1.recent_time_code = 'ALL' then s1.total_transfer_count
               else null end)  as transaction_count
     , sum(case
               when s1.recent_time_code = 'ALL' then s1.total_transfer_volume
               else null end)  as transaction_volume
     , sum(case
               when s1.recent_time_code = 'ALL' AND s1.type = 'NFT Recipient' then s1.balance
               else null end)  as balance_count
     , null                    as balance_usd
     , cast(null as int)       as days
     , sum(case
               when s1.recent_time_code = '3d' then s1.total_transfer_volume
               else null end)  as transaction_volume_3d
     , sum(case
               when s1.recent_time_code = '7d' then s1.total_transfer_volume
               else null end)  as transaction_volume_7d
     , sum(case
               when s1.recent_time_code = '15d' then s1.total_transfer_volume
               else null end)  as transaction_volume_15d
     , sum(case
               when s1.recent_time_code = '1m' then s1.total_transfer_volume
               else null end)  as transaction_volume_1m
     , sum(case
               when s1.recent_time_code = '3m' then s1.total_transfer_volume
               else null end)  as transaction_volume_3m
     , sum(case
               when s1.recent_time_code = '6m' then s1.total_transfer_volume
               else null end)  as transaction_volume_6m
     , sum(case
               when s1.recent_time_code = '1y' then s1.total_transfer_volume
               else null end)  as transaction_volume_1y
     , sum(case
               when s1.recent_time_code = '2y' then s1.total_transfer_volume
               else null end)  as transaction_volume_2y

     , sum(case
               when s1.recent_time_code = '3d' then s1.total_transfer_count
               else null end)  as transaction_count_3d
     , sum(case
               when s1.recent_time_code = '7d' then s1.total_transfer_count
               else null end)  as transaction_count_7d
     , sum(case
               when s1.recent_time_code = '15d' then s1.total_transfer_count
               else null end)  as transaction_count_15d
     , sum(case
               when s1.recent_time_code = '1m' then s1.total_transfer_count
               else null end)  as transaction_count_1m
     , sum(case
               when s1.recent_time_code = '3m' then s1.total_transfer_count
               else null end)  as transaction_count_3m
     , sum(case
               when s1.recent_time_code = '6m' then s1.total_transfer_count
               else null end)  as transaction_count_6m
     , sum(case
               when s1.recent_time_code = '1y' then s1.total_transfer_count
               else null end)  as transaction_count_1y
     , sum(case
               when s1.recent_time_code = '2y' then s1.total_transfer_count
               else null end)  as transaction_count_2y
     , now()                   as etl_update_time
from web3_transaction_record_summary_temp s1
         left join web3_platform s2
                   on s1.project = s2.platform
group by s1.address --地址
       , s1.project -- 项目
       , s2.platform_name_alis

union all
select 'web3'                  as b_type           --  业务类型
     , 'web3'                     statistical_type -- 业务统计类型
     , s1.address                                  --地址
     , 'ALL'                   AS project          -- 项目
     , 'ALL'                   as platform_name
     , 'ALL'                   as token
     , 'ALL'                   AS type             -- 类型
     , cast(null as timestamp) as first_tx_time    --最早交易时间
     , cast(null as timestamp) as latest_tx_time   -- 最后交易时间
     , sum(case
               when s1.recent_time_code = 'ALL' then s1.total_transfer_count
               else null end)  as transaction_count
     , sum(case
               when s1.recent_time_code = 'ALL' then s1.total_transfer_volume
               else null end)  as transaction_volume
     , sum(case
               when s1.recent_time_code = 'ALL' AND s1.type = 'NFT Recipient' then s1.balance
               else null end)  as balance_count
     , null                    as balance_usd
     , cast(null as int)       as days
     , sum(case
               when s1.recent_time_code = '3d' then s1.total_transfer_volume
               else null end)  as transaction_volume_3d
     , sum(case
               when s1.recent_time_code = '7d' then s1.total_transfer_volume
               else null end)  as transaction_volume_7d
     , sum(case
               when s1.recent_time_code = '15d' then s1.total_transfer_volume
               else null end)  as transaction_volume_15d
     , sum(case
               when s1.recent_time_code = '1m' then s1.total_transfer_volume
               else null end)  as transaction_volume_1m
     , sum(case
               when s1.recent_time_code = '3m' then s1.total_transfer_volume
               else null end)  as transaction_volume_3m
     , sum(case
               when s1.recent_time_code = '6m' then s1.total_transfer_volume
               else null end)  as transaction_volume_6m
     , sum(case
               when s1.recent_time_code = '1y' then s1.total_transfer_volume
               else null end)  as transaction_volume_1y
     , sum(case
               when s1.recent_time_code = '2y' then s1.total_transfer_volume
               else null end)  as transaction_volume_2y

     , sum(case
               when s1.recent_time_code = '3d' then s1.total_transfer_count
               else null end)  as transaction_count_3d
     , sum(case
               when s1.recent_time_code = '7d' then s1.total_transfer_count
               else null end)  as transaction_count_7d
     , sum(case
               when s1.recent_time_code = '15d' then s1.total_transfer_count
               else null end)  as transaction_count_15d
     , sum(case
               when s1.recent_time_code = '1m' then s1.total_transfer_count
               else null end)  as transaction_count_1m
     , sum(case
               when s1.recent_time_code = '3m' then s1.total_transfer_count
               else null end)  as transaction_count_3m
     , sum(case
               when s1.recent_time_code = '6m' then s1.total_transfer_count
               else null end)  as transaction_count_6m
     , sum(case
               when s1.recent_time_code = '1y' then s1.total_transfer_count
               else null end)  as transaction_count_1y
     , sum(case
               when s1.recent_time_code = '2y' then s1.total_transfer_count
               else null end)  as transaction_count_2y
     , now()                   as etl_update_time
from web3_transaction_record_summary_temp s1
         left join web3_platform s2
                   on s1.project = s2.platform
group by s1.address; --地址
insert into tag_result(table_name, batch_date)
SELECT 'dws_web3_index_n' as table_name, '${batchDate}' as batch_date;