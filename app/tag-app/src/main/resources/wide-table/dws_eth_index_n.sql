--  事实表针对 project字段区分 
--  
--  --  lp的平台  
--  select * from   platform_detail
--  
--  -- token 平台
--  select * from   platform

truncate table dws_eth_index_n_tmp10;
insert into dws_eth_index_n_tmp10
select
-- 包含了type=ALL的情况
-- 维度
    'DEFi'                                                                             as b_type           --  业务类型
     , 'token'                                                                         as statistical_type -- 统计类型
     , address
     , project
     , token
     , type
-- 指标	
     , cast(null as timestamp)                                                         as first_tx_time    --最早交易时间
     , cast(null as timestamp)                                                         as latest_tx_time   -- 最后交易时间
     , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end) as transaction_count
     , 0                                                                               as transaction_volume
     , 0                                                                                  balance_count
     , 0                                                                               as balance_usd
     , cast(null as int)                                                               as days
     , 0                                                                               as transaction_volume_3d
     , 0                                                                               as transaction_volume_7d
     , 0                                                                               as transaction_volume_15d
     , 0                                                                               as transaction_volume_1m
     , 0                                                                               as transaction_volume_3m
     , 0                                                                               as transaction_volume_6m
     , 0                                                                               as transaction_volume_1y
     , 0                                                                               as transaction_volume_2y

     , sum(case when recent_time_code = '3d' then total_transfer_count else null end)  as transaction_count_3d
     , sum(case when recent_time_code = '7d' then total_transfer_count else null end)  as transaction_count_7d
     , sum(case when recent_time_code = '15d' then total_transfer_count else null end) as transaction_count_15d
     , sum(case when recent_time_code = '1m' then total_transfer_count else null end)  as transaction_count_1m
     , sum(case when recent_time_code = '3m' then total_transfer_count else null end)  as transaction_count_3m
     , sum(case when recent_time_code = '6m' then total_transfer_count else null end)  as transaction_count_6m
     , sum(case when recent_time_code = '1y' then total_transfer_count else null end)  as transaction_count_1y
     , sum(case when recent_time_code = '2y' then total_transfer_count else null end)  as transaction_count_2y
     , now()                                                                           as etl_update_time
from dex_tx_count_summary_temp
group by address
       , project
       , token
       , type
;

insert into dws_eth_index_n_tmp10
select 'DEFi'                  as b_type
     , 'token'                 as statistical_type
     , address
     , project
     , token
     , type
     , cast(null as timestamp) as first_tx_time  --最早交易时间
     , cast(null as timestamp) as latest_tx_time -- 最后交易时间
     , sum(case
               when recent_time_code = 'ALL' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count
     , sum(case
               when recent_time_code = 'ALL' then total_transfer_volume_usd
               else null end)  as transaction_volume

     , 0                          balance_count
     , 0                       as balance_usd
     , cast(null as int)       as days
     , sum(case
               when recent_time_code = '3d' then total_transfer_volume_usd
               else null end)  as transaction_volume_3d
     , sum(case
               when recent_time_code = '7d' then total_transfer_volume_usd
               else null end)  as transaction_volume_7d
     , sum(case
               when recent_time_code = '15d' then total_transfer_volume_usd
               else null end)  as transaction_volume_15d
     , sum(case
               when recent_time_code = '1m' then total_transfer_volume_usd
               else null end)  as transaction_volume_1m
     , sum(case
               when recent_time_code = '3m' then total_transfer_volume_usd
               else null end)  as transaction_volume_3m
     , sum(case
               when recent_time_code = '6m' then total_transfer_volume_usd
               else null end)  as transaction_volume_6m
     , sum(case
               when recent_time_code = '1y' then total_transfer_volume_usd
               else null end)  as transaction_volume_1y
     , sum(case
               when recent_time_code = '2y' then total_transfer_volume_usd
               else null end)  as transaction_volume_2y


     , sum(case
               when recent_time_code = '3d' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_3d
     , sum(case
               when recent_time_code = '7d' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_7d
     , sum(case
               when recent_time_code = '15d' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_15d
     , sum(case
               when recent_time_code = '1m' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_1m
     , sum(case
               when recent_time_code = '3m' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_3m
     , sum(case
               when recent_time_code = '6m' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_6m
     , sum(case
               when recent_time_code = '1y' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_1y
     , sum(case
               when recent_time_code = '2y' and token <> 'ALL' then total_transfer_count
               else null end)  as transaction_count_2y

     , now()                   as etl_update_time
from dex_tx_volume_count_summary_temp
group by address
       , project
       , token
       , type;

--  LP 数据执行 univ3
insert into dws_eth_index_n_tmp10
select 'DEFi'                                                                                 as b_type
     , 'LP'                                                                                   as statistical_type
     , address
     , project
     , token                                                                                                    --  枚举值   1m  2y
     , type
     , (select to_timestamp(min(first_updated_block_height)) ::timestamp)                     as first_tx_time  --最早交易时间
     , cast(null as timestamp)                                                                as latest_tx_time -- 最后交易时间
     , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end)        as transaction_count
     , sum(case when recent_time_code = 'ALL' then total_transfer_volume_usd else null end)   as transaction_volume
     , sum(case when recent_time_code = 'ALL' and type = 'lp' then 1 else null end)           as balance_count
     , sum(case when recent_time_code = 'ALL' and type = 'lp' then balance_usd else null end) as balance_usd
     , cast(null as int)                                                                      as days
     , sum(case when recent_time_code = '3d' then total_transfer_volume_usd else null end)    as transaction_volume_3d
     , sum(case when recent_time_code = '7d' then total_transfer_volume_usd else null end)    as transaction_volume_7d
     , sum(case when recent_time_code = '15d' then total_transfer_volume_usd else null end)   as transaction_volume_15d
     , sum(case when recent_time_code = '1m' then total_transfer_volume_usd else null end)    as transaction_volume_1m
     , sum(case when recent_time_code = '3m' then total_transfer_volume_usd else null end)    as transaction_volume_3m
     , sum(case when recent_time_code = '6m' then total_transfer_volume_usd else null end)    as transaction_volume_6m
     , sum(case when recent_time_code = '1y' then total_transfer_volume_usd else null end)    as transaction_volume_1y
     , sum(case when recent_time_code = '2y' then total_transfer_volume_usd else null end)    as transaction_volume_2y


     , sum(case when recent_time_code = '3d' then total_transfer_count else null end)         as transaction_count_3d
     , sum(case when recent_time_code = '7d' then total_transfer_count else null end)         as transaction_count_7d
     , sum(case when recent_time_code = '15d' then total_transfer_count else null end)        as transaction_count_15d
     , sum(case when recent_time_code = '1m' then total_transfer_count else null end)         as transaction_count_1m
     , sum(case when recent_time_code = '3m' then total_transfer_count else null end)         as transaction_count_3m
     , sum(case when recent_time_code = '6m' then total_transfer_count else null end)         as transaction_count_6m
     , sum(case when recent_time_code = '1y' then total_transfer_count else null end)         as transaction_count_1y
     , sum(case when recent_time_code = '2y' then total_transfer_count else null end)         as transaction_count_2y
     , now()                                                                                  as etl_update_time
from dex_tx_volume_count_summary_univ3_temp
group by address
       , project
       , token
       , type;

-- type 交易类型 
truncate table dws_eth_index_n_tmp1;
insert into dws_eth_index_n_tmp1
select
-- 维度
    s1.b_type                                           --  业务类型
     , s1.statistical_type                              -- 统计类型
     , s1.address
     , s1.project
     , s2.platform_name
     , s1.token
     , s1.type
-- 指标	
     , min(s1.first_tx_time)          as first_tx_time  --最早交易时间
     , max(s1.latest_tx_time)         as latest_tx_time -- 最后交易时间
     , sum(s1.transaction_count)      as transaction_count
     , sum(s1.transaction_volume)     as transaction_volume
     , sum(s1.balance_count)          as balance_count
     , sum(s1.balance_usd)            as balance_usd
     , cast(null as int)              as days
     , sum(s1.transaction_volume_3d)  as transaction_volume_3d
     , sum(s1.transaction_volume_7d)  as transaction_volume_7d
     , sum(s1.transaction_volume_15d) as transaction_volume_15d
     , sum(s1.transaction_volume_1m)  as transaction_volume_1m
     , sum(s1.transaction_volume_3m)  as transaction_volume_3m
     , sum(s1.transaction_volume_6m)  as transaction_volume_6m
     , sum(s1.transaction_volume_1y)  as transaction_volume_1y
     , sum(s1.transaction_volume_2y)  as transaction_volume_2y
     , sum(s1.transaction_count_3d)   as transaction_count_3d
     , sum(s1.transaction_count_7d)   as transaction_count_7d
     , sum(s1.transaction_count_15d)  as transaction_count_15d
     , sum(s1.transaction_count_1m)   as transaction_count_1m
     , sum(s1.transaction_count_3m)   as transaction_count_3m
     , sum(s1.transaction_count_6m)   as transaction_count_6m
     , sum(s1.transaction_count_1y)   as transaction_count_1y
     , sum(s1.transaction_count_2y)   as transaction_count_2y
     , now()                          as etl_update_time
from dws_eth_index_n_tmp10 s1
         left join (select platform, platform_name
                    from platform_detail --  补充   uniswap
                    union
                    select platform_large_code as platform, platform_large_name as platform_name
                    from platform_large_category) s2
                   on s1.project = s2.platform
group by s1.b_type           --  业务类型
       , s1.statistical_type -- 统计类型
       , s1.address
       , s1.project
       , s2.platform_name
       , s1.token
       , s1.type
;



--  token='ALL'  AND type='ALL'的时候交易量没有
-- 第二部分统计
-- 由于数据量巨大 进行数据拆分
truncate table dws_eth_index_n_tmp2;
-- 第一步
insert into dws_eth_index_n_tmp2
select 'DEFi'            as b_type
     , 'token'           as statistical_type
     , address
     , 'ALLNET'          as project
     , 'ALLNET'          as platform_name
     , 'eth'             as token
     , 'ALL'             as type
     , null              as first_tx_time  --最早交易时间
     , null              as latest_tx_time -- 最后交易时间
     , null              as transaction_count
     , null              as transaction_volume
     , sum(balance)      as balance_count  -- balance*价格  就是
     , null              as balance_usd
     , cast(null as int) as days
     , null              as transaction_volume_3d
     , null              as transaction_volume_7d
     , null              as transaction_volume_15d
     , null              as transaction_volume_1m
     , null              as transaction_volume_3m
     , null              as transaction_volume_6m
     , null              as transaction_volume_1y
     , null              as transaction_volume_2y

     , null              as transaction_count_3d
     , null              as transaction_count_7d
     , null              as transaction_count_15d
     , null              as transaction_count_1m
     , null              as transaction_count_3m
     , null              as transaction_count_6m
     , null              as transaction_count_1y
     , null              as transaction_count_2y
     , now()             as etl_update_time

from eth_holding_temp
group by address
;


-- 第二步
insert into dws_eth_index_n_tmp2
select 'DEFi'              as b_type
     , 'token'             as statistical_type
     , address
     , 'ALLNET'            as project
     , 'ALLNET'            as platform_name
     , 'eth'               as token
     , 'ALL'               as type
     , min(first_tx_time)  as first_tx_time  --最早交易时间
     , max(latest_tx_time) as latest_tx_time -- 最后交易时间
     , null                as transaction_count
     , null                as transaction_volume
     , null                as balance_count
     , null                as balance_usd
     , floor(
            (floor(EXTRACT(epoch FROM CAST('${batchDate}' AS TIMESTAMP))) -
             floor(extract(epoch from max(latest_tx_time)))) /
            (24 * 3600))   as days
     , null                as transaction_volume_3d
     , null                as transaction_volume_7d
     , null                as transaction_volume_15d
     , null                as transaction_volume_1m
     , null                as transaction_volume_3m
     , null                as transaction_volume_6m
     , null                as transaction_volume_1y
     , null                as transaction_volume_2y
     , null                as transaction_count_3d
     , null                as transaction_count_7d
     , null                as transaction_count_15d
     , null                as transaction_count_1m
     , null                as transaction_count_3m
     , null                as transaction_count_6m
     , null                as transaction_count_1y
     , null                as transaction_count_2y

     , now()               as etl_update_time
from eth_holding_time_temp
group by address
;

-- 第三步 
insert into dws_eth_index_n_tmp2
select 'DEFi'                                                                          as b_type
     , 'token'                                                                         as statistical_type
     , address
     , 'ALLNET'                                                                        as project
     , 'ALLNET'                                                                        as platform_name
     , 'eth'                                                                           as token
     , 'ALL'                                                                           as type
     , null                                                                            as first_tx_time  --最早交易时间
     , null                                                                            as latest_tx_time -- 最后交易时间
     , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end) as transaction_count
     , null                                                                            as transaction_volume
     , null                                                                            as balance_count
     , null                                                                            as balance_usd
     , cast(null as int)                                                               as days
     , null                                                                            as transaction_volume_3d
     , null                                                                            as transaction_volume_7d
     , null                                                                            as transaction_volume_15d
     , null                                                                            as transaction_volume_1m
     , null                                                                            as transaction_volume_3m
     , null                                                                            as transaction_volume_6m
     , null                                                                            as transaction_volume_1y
     , null                                                                            as transaction_volume_2y

     , sum(case when recent_time_code = '3d' then total_transfer_count else null end)  as transaction_count_3d
     , sum(case when recent_time_code = '7d' then total_transfer_count else null end)  as transaction_count_7d
     , sum(case when recent_time_code = '15d' then total_transfer_count else null end) as transaction_count_15d
     , sum(case when recent_time_code = '1m' then total_transfer_count else null end)  as transaction_count_1m
     , sum(case when recent_time_code = '3m' then total_transfer_count else null end)  as transaction_count_3m
     , sum(case when recent_time_code = '6m' then total_transfer_count else null end)  as transaction_count_6m
     , sum(case when recent_time_code = '1y' then total_transfer_count else null end)  as transaction_count_1y
     , sum(case when recent_time_code = '2y' then total_transfer_count else null end)  as transaction_count_2y


     , now()                                                                           as etl_update_time
from eth_holding_vol_count_temp
group by address;


-- 第四步
insert into dws_eth_index_n_tmp2
select 'DEFi'            as b_type
     , 'token'           as statistical_type
     , token_balance_volume_usd_temp.address
     , 'ALLNET'          as project
     , 'ALLNET'          as platform_name
     , token
     , 'ALL'             as type
     , null              as first_tx_time  --最早交易时间
     , null              as latest_tx_time -- 最后交易时间
     , null              as transaction_count
     , null              as transaction_volume
     , null              as balance_count
     , sum(balance_usd)  as balance_usd
     , cast(null as int) as days
     , null              as transaction_volume_3d
     , null              as transaction_volume_7d
     , null              as transaction_volume_15d
     , null              as transaction_volume_1m
     , null              as transaction_volume_3m
     , null              as transaction_volume_6m
     , null              as transaction_volume_1y
     , null              as transaction_volume_2y
     , null              as transaction_count_3d
     , null              as transaction_count_7d
     , null              as transaction_count_15d
     , null              as transaction_count_1m
     , null              as transaction_count_3m
     , null              as transaction_count_6m
     , null              as transaction_count_1y
     , null              as transaction_count_2y
     , now()             as etl_update_time
from token_balance_volume_usd_temp
         inner join (select address, name from top_token_1000 where removed = false and holders >= 100) top_token_1000
                    on (token_balance_volume_usd_temp.token = top_token_1000.address)
group by token_balance_volume_usd_temp.address, token
;

insert into dws_eth_index_n_tmp2
select 'DEFi'            as b_type
     , 'LP'              as statistical_type
     , token_balance_volume_usd_temp.address
     , 'ALLNET'          as project
     , factory_type      as platform_name
     , token
     , 'ALL'             as type
     , null              as first_tx_time  --最早交易时间
     , null              as latest_tx_time -- 最后交易时间
     , null              as transaction_count
     , null              as transaction_volume
     , null              as balance_count
     , sum(balance_usd)  as balance_usd
     , cast(null as int) as days
     , null              as transaction_volume_3d
     , null              as transaction_volume_7d
     , null              as transaction_volume_15d
     , null              as transaction_volume_1m
     , null              as transaction_volume_3m
     , null              as transaction_volume_6m
     , null              as transaction_volume_1y
     , null              as transaction_volume_2y
     , null              as transaction_count_3d
     , null              as transaction_count_7d
     , null              as transaction_count_15d
     , null              as transaction_count_1m
     , null              as transaction_count_3m
     , null              as transaction_count_6m
     , null              as transaction_count_1y
     , null              as transaction_count_2y
     , now()             as etl_update_time
from token_balance_volume_usd_temp
         inner join (select distinct wlp.address,
                                     wlp.symbol_wired as name,
                                     wlp.factory_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp
                                        on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and wlp.symbols <@ array(
select
	symbol
from
	top_token_1000_temp
where
	holders >= 100
	and removed = false)
    and wlp."type" = 'LP') top_token_1000 on (token_balance_volume_usd_temp.token = top_token_1000.address)
group by token_balance_volume_usd_temp.address, token, factory_type;

-- 第三步2
insert into dws_eth_index_n_tmp2
select 'DEFi'            as b_type
     , 'token'           as statistical_type
     , address
     , 'ALLNET'          as project
     , 'ALLNET'          as platform_name
     , 'ALL'             AS token
     , 'ALL'             as type
     , null              as first_tx_time  --最早交易时间
     , null              as latest_tx_time -- 最后交易时间
     , null              as transaction_count
     , null              as transaction_volume
     , null              as balance_count
     , sum(balance_usd)  as balance_usd
     , cast(null as int) as days
     , null              as transaction_volume_3d
     , null              as transaction_volume_7d
     , null              as transaction_volume_15d
     , null              as transaction_volume_1m
     , null              as transaction_volume_3m
     , null              as transaction_volume_6m
     , null              as transaction_volume_1y
     , null              as transaction_volume_2y
     , null              as transaction_count_3d
     , null              as transaction_count_7d
     , null              as transaction_count_15d
     , null              as transaction_count_1m
     , null              as transaction_count_3m
     , null              as transaction_count_6m
     , null              as transaction_count_1y
     , null              as transaction_count_2y
     , now()             as etl_update_time
from total_balance_volume_usd_temp
group by address
;


-- 第五步

insert into dws_eth_index_n_tmp2
select 'DEFi'                                                                as b_type
     , 'token'                                                               as statistical_type
     , token_volume_usd_temp.address
     , 'ALLNET'                                                              as project
     , 'ALLNET'                                                              as platform_name
     , token_volume_usd_temp.token
     , 'ALL'                                                                 as type
     , null                                                                  as first_tx_time  --最早交易时间
     , null                                                                  as latest_tx_time -- 最后交易时间
     , null                                                                  as transaction_count
     , sum(case when recent_time_code = 'ALL' then volume_usd else null end) as transaction_volume
     , null                                                                  as balance_count
     , null                                                                  as balance_usd
     , cast(null as int)                                                     as days
     , sum(case when recent_time_code = '3d' then volume_usd else null end)  as transaction_volume_3d
     , sum(case when recent_time_code = '7d' then volume_usd else null end)  as transaction_volume_7d
     , sum(case when recent_time_code = '15d' then volume_usd else null end) as transaction_volume_15d
     , sum(case when recent_time_code = '1m' then volume_usd else null end)  as transaction_volume_1m
     , sum(case when recent_time_code = '3m' then volume_usd else null end)  as transaction_volume_3m
     , sum(case when recent_time_code = '6m' then volume_usd else null end)  as transaction_volume_6m
     , sum(case when recent_time_code = '1y' then volume_usd else null end)  as transaction_volume_1y
     , sum(case when recent_time_code = '2y' then volume_usd else null end)  as transaction_volume_2y
     , null                                                                  as transaction_count_3d
     , null                                                                  as transaction_count_7d
     , null                                                                  as transaction_count_15d
     , null                                                                  as transaction_count_1m
     , null                                                                  as transaction_count_3m
     , null                                                                  as transaction_count_6m
     , null                                                                  as transaction_count_1y
     , null                                                                  as transaction_count_2y
     , now()                                                                 as etl_update_time
from token_volume_usd_temp
         inner join (select address, name from top_token_1000 where removed = false and holders >= 100) top_token_1000
                    on (token_volume_usd_temp.token = top_token_1000.address)
group by token_volume_usd_temp.address, token_volume_usd_temp.token
;


insert into dws_eth_index_n_tmp2
select 'DEFi'                                                                as b_type
     , 'LP'                                                                  as statistical_type
     , token_volume_usd_temp.address
     , 'ALLNET'                                                              as project
     , factory_type                                                          as platform_name
     , token_volume_usd_temp.token
     , 'ALL'                                                                 as type
     , null                                                                  as first_tx_time  --最早交易时间
     , null                                                                  as latest_tx_time -- 最后交易时间
     , null                                                                  as transaction_count
     , sum(case when recent_time_code = 'ALL' then volume_usd else null end) as transaction_volume
     , null                                                                  as balance_count
     , null                                                                  as balance_usd
     , cast(null as int)                                                     as days
     , sum(case when recent_time_code = '3d' then volume_usd else null end)  as transaction_volume_3d
     , sum(case when recent_time_code = '7d' then volume_usd else null end)  as transaction_volume_7d
     , sum(case when recent_time_code = '15d' then volume_usd else null end) as transaction_volume_15d
     , sum(case when recent_time_code = '1m' then volume_usd else null end)  as transaction_volume_1m
     , sum(case when recent_time_code = '3m' then volume_usd else null end)  as transaction_volume_3m
     , sum(case when recent_time_code = '6m' then volume_usd else null end)  as transaction_volume_6m
     , sum(case when recent_time_code = '1y' then volume_usd else null end)  as transaction_volume_1y
     , sum(case when recent_time_code = '2y' then volume_usd else null end)  as transaction_volume_2y
     , null                                                                  as transaction_count_3d
     , null                                                                  as transaction_count_7d
     , null                                                                  as transaction_count_15d
     , null                                                                  as transaction_count_1m
     , null                                                                  as transaction_count_3m
     , null                                                                  as transaction_count_6m
     , null                                                                  as transaction_count_1y
     , null                                                                  as transaction_count_2y
     , now()                                                                 as etl_update_time
from token_volume_usd_temp
         inner join (select distinct wlp.address,
                                     wlp.symbol_wired as name,
                                     wlp.factory_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp
                                        on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and wlp.symbols <@ array(
select
	symbol
from
	top_token_1000_temp
where
	holders >= 100
	and removed = false)
    and wlp."type" = 'LP') top_token_1000 on (token_volume_usd_temp.token = top_token_1000.address)
group by token_volume_usd_temp.address, token_volume_usd_temp.token, factory_type
;


insert into dws_eth_index_n_tmp2
select 'DEFi'                                                                as b_type
     , 'token'                                                               as statistical_type
     , address
     , 'ALLNET'                                                              as project
     , 'ALLNET'                                                              as platform_name
     , 'ALL'                                                                 as token
     , 'ALL'                                                                 as type
     , null                                                                  as first_tx_time  --最早交易时间
     , null                                                                  as latest_tx_time -- 最后交易时间
     , null                                                                  as transaction_count
     , sum(case when recent_time_code = 'ALL' then volume_usd else null end) as transaction_volume
     , null                                                                  as balance_count
     , null                                                                  as balance_usd
     , cast(null as int)                                                     as days
     , sum(case when recent_time_code = '3d' then volume_usd else null end)  as transaction_volume_3d
     , sum(case when recent_time_code = '7d' then volume_usd else null end)  as transaction_volume_7d
     , sum(case when recent_time_code = '15d' then volume_usd else null end) as transaction_volume_15d
     , sum(case when recent_time_code = '1m' then volume_usd else null end)  as transaction_volume_1m
     , sum(case when recent_time_code = '3m' then volume_usd else null end)  as transaction_volume_3m
     , sum(case when recent_time_code = '6m' then volume_usd else null end)  as transaction_volume_6m
     , sum(case when recent_time_code = '1y' then volume_usd else null end)  as transaction_volume_1y
     , sum(case when recent_time_code = '2y' then volume_usd else null end)  as transaction_volume_2y
     , null                                                                  as transaction_count_3d
     , null                                                                  as transaction_count_7d
     , null                                                                  as transaction_count_15d
     , null                                                                  as transaction_count_1m
     , null                                                                  as transaction_count_3m
     , null                                                                  as transaction_count_6m
     , null                                                                  as transaction_count_1y
     , null                                                                  as transaction_count_2y
     , now()                                                                 as etl_update_time
from total_volume_usd_temp
group by address;

-- 第六步

insert into dws_eth_index_n_tmp2
select 'DEFi'            as b_type
     , 'token'           as statistical_type
     , token_holding_temp.address
     , 'ALLNET'          as project
     , 'ALLNET'          as platform_name
     , token
     , 'ALL'             as type
     , null              as first_tx_time  --最早交易时间
     , null              as latest_tx_time -- 最后交易时间
     , null              as transaction_count
     , null              as transaction_volume
     , sum(balance)      as balance_count  -- 余额 个数
     , null              as balance_usd
     , cast(null as int) as days
     , null              as transaction_volume_3d
     , null              as transaction_volume_7d
     , null              as transaction_volume_15d
     , null              as transaction_volume_1m
     , null              as transaction_volume_3m
     , null              as transaction_volume_6m
     , null              as transaction_volume_1y
     , null              as transaction_volume_2y
     , null              as transaction_count_3d
     , null              as transaction_count_7d
     , null              as transaction_count_15d
     , null              as transaction_count_1m
     , null              as transaction_count_3m
     , null              as transaction_count_6m
     , null              as transaction_count_1y
     , null              as transaction_count_2y
     , now()             as etl_update_time
from token_holding_temp
         inner join (select address, name from top_token_1000 where removed = false and holders >= 100) top_token_1000
                    on (token_holding_temp.token = top_token_1000.address)
group by token_holding_temp.address, token_holding_temp.token
;


insert into dws_eth_index_n_tmp2
select 'DEFi'            as b_type
     , 'LP'              as statistical_type
     , token_holding_temp.address
     , 'ALLNET'          as project
     , factory_type      as platform_name
     , token
     , 'ALL'             as type
     , null              as first_tx_time  --最早交易时间
     , null              as latest_tx_time -- 最后交易时间
     , null              as transaction_count
     , null              as transaction_volume
     , sum(balance)      as balance_count  -- 余额 个数
     , null              as balance_usd
     , cast(null as int) as days
     , null              as transaction_volume_3d
     , null              as transaction_volume_7d
     , null              as transaction_volume_15d
     , null              as transaction_volume_1m
     , null              as transaction_volume_3m
     , null              as transaction_volume_6m
     , null              as transaction_volume_1y
     , null              as transaction_volume_2y
     , null              as transaction_count_3d
     , null              as transaction_count_7d
     , null              as transaction_count_15d
     , null              as transaction_count_1m
     , null              as transaction_count_3m
     , null              as transaction_count_6m
     , null              as transaction_count_1y
     , null              as transaction_count_2y
     , now()             as etl_update_time
from token_holding_temp
         inner join (select distinct wlp.address,
                                     wlp.symbol_wired as name,
                                     wlp.factory_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp
                                        on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and wlp.symbols <@ array(
select
	symbol
from
	top_token_1000_temp
where
	holders >= 100
	and removed = false)
    and wlp."type" = 'LP') top_token_1000 on (token_holding_temp.token = top_token_1000.address)
group by token_holding_temp.address, token_holding_temp.token, factory_type
;

-- 第七步
insert into dws_eth_index_n_tmp2
select 'DEFi'              as b_type
     , 'token'             as statistical_type
     , token_holding_time_temp.address
     , 'ALLNET'            as project
     , 'ALLNET'            as platform_name
     , token
     , 'ALL'               as type
     , min(first_tx_time)  as first_tx_time  --最早交易时间
     , max(latest_tx_time) as latest_tx_time -- 最后交易时间
     , null                as transaction_count
     , null                as transaction_volume
     , null                as balance_count
     , null                as balance_usd
     , floor(
            (floor(EXTRACT(epoch FROM CAST('${batchDate}' AS TIMESTAMP))) -
             floor(extract(epoch from max(latest_tx_time)))) /
            (24 * 3600))   as days
     , null                as transaction_volume_3d
     , null                as transaction_volume_7d
     , null                as transaction_volume_15d
     , null                as transaction_volume_1m
     , null                as transaction_volume_3m
     , null                as transaction_volume_6m
     , null                as transaction_volume_1y
     , null                as transaction_volume_2y
     , null                as transaction_count_3d
     , null                as transaction_count_7d
     , null                as transaction_count_15d
     , null                as transaction_count_1m
     , null                as transaction_count_3m
     , null                as transaction_count_6m
     , null                as transaction_count_1y
     , null                as transaction_count_2y
     , now()               as etl_update_time
from token_holding_time_temp
         inner join (select address, name from top_token_1000 where removed = false and holders >= 100) top_token_1000
                    on (token_holding_time_temp.token = top_token_1000.address)
group by token_holding_time_temp.address, token
;
insert into dws_eth_index_n_tmp2
select 'DEFi'              as b_type
     , 'LP'                as statistical_type
     , token_holding_time_temp.address
     , 'ALLNET'            as project
     , factory_type        as platform_name
     , token
     , 'ALL'               as type
     , min(first_tx_time)  as first_tx_time  --最早交易时间
     , max(latest_tx_time) as latest_tx_time -- 最后交易时间
     , null                as transaction_count
     , null                as transaction_volume
     , null                as balance_count
     , null                as balance_usd
     , floor(
            (floor(EXTRACT(epoch FROM CAST('${batchDate}' AS TIMESTAMP))) -
             floor(extract(epoch from max(latest_tx_time)))) /
            (24 * 3600))   as days
     , null                as transaction_volume_3d
     , null                as transaction_volume_7d
     , null                as transaction_volume_15d
     , null                as transaction_volume_1m
     , null                as transaction_volume_3m
     , null                as transaction_volume_6m
     , null                as transaction_volume_1y
     , null                as transaction_volume_2y
     , null                as transaction_count_3d
     , null                as transaction_count_7d
     , null                as transaction_count_15d
     , null                as transaction_count_1m
     , null                as transaction_count_3m
     , null                as transaction_count_6m
     , null                as transaction_count_1y
     , null                as transaction_count_2y
     , now()               as etl_update_time
from token_holding_time_temp
         inner join (select distinct wlp.address,
                                     wlp.symbol_wired as name,
                                     wlp.factory_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp
                                        on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and wlp.symbols <@ array(
select
	symbol
from
	top_token_1000_temp
where
	holders >= 100
	and removed = false)
    and wlp."type" = 'LP') top_token_1000 on (token_holding_time_temp.token = top_token_1000.address)
group by token_holding_time_temp.address, token, factory_type
;

-- 第八步
insert into dws_eth_index_n_tmp2
select 'DEFi'                                                                          as b_type
     , 'token'                                                                         as statistical_type
     , token_holding_vol_count_temp.address
     , 'ALLNET'                                                                        as project
     , 'ALLNET'                                                                        as platform_name
     , token
     , 'ALL'                                                                           as type
     , null                                                                            as first_tx_time  --最早交易时间
     , null                                                                            as latest_tx_time -- 最后交易时间
     , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end) as transaction_count
     , null                                                                            as transaction_volume
     , null                                                                            as balance_count
     , null                                                                            as balance_usd
     , cast(null as int)                                                               as days
     , null                                                                            as transaction_volume_3d
     , null                                                                            as transaction_volume_7d
     , null                                                                            as transaction_volume_15d
     , null                                                                            as transaction_volume_1m
     , null                                                                            as transaction_volume_3m
     , null                                                                            as transaction_volume_6m
     , null                                                                            as transaction_volume_1y
     , null                                                                            as transaction_volume_2y
     , sum(case when recent_time_code = '3d' then total_transfer_count else null end)  as transaction_count_3d
     , sum(case when recent_time_code = '7d' then total_transfer_count else null end)  as transaction_count_7d
     , sum(case when recent_time_code = '15d' then total_transfer_count else null end) as transaction_count_15d
     , sum(case when recent_time_code = '1m' then total_transfer_count else null end)  as transaction_count_1m
     , sum(case when recent_time_code = '3m' then total_transfer_count else null end)  as transaction_count_3m
     , sum(case when recent_time_code = '6m' then total_transfer_count else null end)  as transaction_count_6m
     , sum(case when recent_time_code = '1y' then total_transfer_count else null end)  as transaction_count_1y
     , sum(case when recent_time_code = '2y' then total_transfer_count else null end)  as transaction_count_2y
     , now()                                                                           as etl_update_time
from token_holding_vol_count_temp
         inner join (select address, name from top_token_1000 where removed = false and holders >= 100) top_token_1000
                    on (token_holding_vol_count_temp.token = top_token_1000.address)
group by token_holding_vol_count_temp.address, token
;

-- 第八步
insert into dws_eth_index_n_tmp2
select 'DEFi'                                                                          as b_type
     , 'LP'                                                                            as statistical_type
     , token_holding_vol_count_temp.address
     , 'ALLNET'                                                                        as project
     , factory_type                                                                    as platform_name
     , token
     , 'ALL'                                                                           as type
     , null                                                                            as first_tx_time  --最早交易时间
     , null                                                                            as latest_tx_time -- 最后交易时间
     , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end) as transaction_count
     , null                                                                            as transaction_volume
     , null                                                                            as balance_count
     , null                                                                            as balance_usd
     , cast(null as int)                                                               as days
     , null                                                                            as transaction_volume_3d
     , null                                                                            as transaction_volume_7d
     , null                                                                            as transaction_volume_15d
     , null                                                                            as transaction_volume_1m
     , null                                                                            as transaction_volume_3m
     , null                                                                            as transaction_volume_6m
     , null                                                                            as transaction_volume_1y
     , null                                                                            as transaction_volume_2y
     , sum(case when recent_time_code = '3d' then total_transfer_count else null end)  as transaction_count_3d
     , sum(case when recent_time_code = '7d' then total_transfer_count else null end)  as transaction_count_7d
     , sum(case when recent_time_code = '15d' then total_transfer_count else null end) as transaction_count_15d
     , sum(case when recent_time_code = '1m' then total_transfer_count else null end)  as transaction_count_1m
     , sum(case when recent_time_code = '3m' then total_transfer_count else null end)  as transaction_count_3m
     , sum(case when recent_time_code = '6m' then total_transfer_count else null end)  as transaction_count_6m
     , sum(case when recent_time_code = '1y' then total_transfer_count else null end)  as transaction_count_1y
     , sum(case when recent_time_code = '2y' then total_transfer_count else null end)  as transaction_count_2y
     , now()                                                                           as etl_update_time
from token_holding_vol_count_temp
         inner join (select distinct wlp.address,
                                     wlp.symbol_wired as name,
                                     wlp.factory_type
                     from white_list_lp_temp wlp
                              left join white_list_lp_temp wslp
                                        on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
                     where wlp.tvl > 1000000
                       and wlp.symbols <@ array(
select
	symbol
from
	top_token_1000_temp
where
	holders >= 100
	and removed = false)
    and wlp."type" = 'LP') top_token_1000 on (token_holding_vol_count_temp.token = top_token_1000.address)
group by token_holding_vol_count_temp.address, token, factory_type
;

insert into dws_eth_index_n_tmp2
select 'DEFi'                     as b_type
     , 'token'                    as statistical_type
     , address
     , 'ALLNET'                   as project
     , 'ALLNET'                   as platform_name
     , 'ALL'                      AS token
     , 'ALL'                      as type
     , null                       as first_tx_time  --最早交易时间
     , null                       as latest_tx_time -- 最后交易时间
     , sum(transaction_count)     as transaction_count
     , null                       as transaction_volume
     , null                       as balance_count
     , null                       as balance_usd
     , cast(null as int)          as days
     , null                       as transaction_volume_3d
     , null                       as transaction_volume_7d
     , null                       as transaction_volume_15d
     , null                       as transaction_volume_1m
     , null                       as transaction_volume_3m
     , null                       as transaction_volume_6m
     , null                       as transaction_volume_1y
     , null                       as transaction_volume_2y
     , sum(transaction_count_3d)  as transaction_count_3d
     , sum(transaction_count_3d)  as transaction_count_7d
     , sum(transaction_count_15d) as transaction_count_15d
     , sum(transaction_count_1m)  as transaction_count_1m
     , sum(transaction_count_3m)  as transaction_count_3m
     , sum(transaction_count_6m)  as transaction_count_6m
     , sum(transaction_count_1y)  as transaction_count_1y
     , sum(transaction_count_2y)  as transaction_count_2y
     , now()                      as etl_update_time
from (select address
           , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end) as transaction_count
           , sum(case when recent_time_code = '3d' then total_transfer_count else null end)  as transaction_count_3d
           , sum(case when recent_time_code = '7d' then total_transfer_count else null end)  as transaction_count_7d
           , sum(case when recent_time_code = '15d' then total_transfer_count else null end) as transaction_count_15d
           , sum(case when recent_time_code = '1m' then total_transfer_count else null end)  as transaction_count_1m
           , sum(case when recent_time_code = '3m' then total_transfer_count else null end)  as transaction_count_3m
           , sum(case when recent_time_code = '6m' then total_transfer_count else null end)  as transaction_count_6m
           , sum(case when recent_time_code = '1y' then total_transfer_count else null end)  as transaction_count_1y
           , sum(case when recent_time_code = '2y' then total_transfer_count else null end)  as transaction_count_2y
      from eth_holding_vol_count_temp
      where total_transfer_count >= 1
      group by address
      union
      select address
           , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end) as transaction_count
           , sum(case when recent_time_code = '3d' then total_transfer_count else null end)  as transaction_count_3d
           , sum(case when recent_time_code = '7d' then total_transfer_count else null end)  as transaction_count_7d
           , sum(case when recent_time_code = '15d' then total_transfer_count else null end) as transaction_count_15d
           , sum(case when recent_time_code = '1m' then total_transfer_count else null end)  as transaction_count_1m
           , sum(case when recent_time_code = '3m' then total_transfer_count else null end)  as transaction_count_3m
           , sum(case when recent_time_code = '6m' then total_transfer_count else null end)  as transaction_count_6m
           , sum(case when recent_time_code = '1y' then total_transfer_count else null end)  as transaction_count_1y
           , sum(case when recent_time_code = '2y' then total_transfer_count else null end)  as transaction_count_2y
      from token_holding_vol_count_temp
      where total_transfer_count >= 1
      group by address
      union
      select address
           , sum(case when recent_time_code = 'ALL' then total_transfer_count else null end) as transaction_count
           , sum(case when recent_time_code = '3d' then total_transfer_count else null end)  as transaction_count_3d
           , sum(case when recent_time_code = '7d' then total_transfer_count else null end)  as transaction_count_7d
           , sum(case when recent_time_code = '15d' then total_transfer_count else null end) as transaction_count_15d
           , sum(case when recent_time_code = '1m' then total_transfer_count else null end)  as transaction_count_1m
           , sum(case when recent_time_code = '3m' then total_transfer_count else null end)  as transaction_count_3m
           , sum(case when recent_time_code = '6m' then total_transfer_count else null end)  as transaction_count_6m
           , sum(case when recent_time_code = '1y' then total_transfer_count else null end)  as transaction_count_1y
           , sum(case when recent_time_code = '2y' then total_transfer_count else null end)  as transaction_count_2y
      from dex_tx_volume_count_summary_univ3_temp
      where project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
        and total_transfer_count >= 1
        and type = 'ALL'
      group by address) totalAc
group by address;


-- 第二部分汇总
truncate table dws_eth_index_n_tmp3;
insert into dws_eth_index_n_tmp3
select s1.b_type
     , s1.statistical_type
     , s1.address
     , s1.project
     , s1.platform_name
     , s1.token
     , s1.type
     , min(first_tx_time)          as first_tx_time  --最早交易时间
     , max(latest_tx_time)         as latest_tx_time -- 最后交易时间
     , sum(transaction_count)      as transaction_count
     , sum(transaction_volume)     as transaction_volume
     , sum(balance_count)          as balance_count-- balance*价格  就是
     , sum(balance_usd)            as balance_usd
     , sum(days)                   as days
     , sum(transaction_volume_3d)  as transaction_volume_3d
     , sum(transaction_volume_7d)  as transaction_volume_7d
     , sum(transaction_volume_15d) as transaction_volume_15d
     , sum(transaction_volume_1m)  as transaction_volume_1m
     , sum(transaction_volume_3m)  as transaction_volume_3m
     , sum(transaction_volume_6m)  as transaction_volume_6m
     , sum(transaction_volume_1y)  as transaction_volume_1y
     , sum(transaction_volume_2y)  as transaction_volume_2y
     , sum(transaction_count_3d)   as transaction_count_3d
     , sum(transaction_count_7d)   as transaction_count_7d
     , sum(transaction_count_15d)  as transaction_count_15d
     , sum(transaction_count_1m)   as transaction_count_1m
     , sum(transaction_count_3m)   as transaction_count_3m
     , sum(transaction_count_6m)   as transaction_count_6m
     , sum(transaction_count_1y)   as transaction_count_1y
     , sum(transaction_count_2y)   as transaction_count_2y
     , now()                       as etl_update_time
from dws_eth_index_n_tmp2 s1
group by s1.b_type
       , s1.statistical_type
       , s1.address
       , s1.project
       , s1.platform_name
       , s1.token
       , s1.type
;


--  asset ：token 和 lp   platform：DEX ETH2.0
truncate table dws_eth_index_n;
insert into dws_eth_index_n
select b_type
     , statistical_type
     , address
     , project
     , platform_name
     , token
     , type
     , first_tx_time  --最早交易时间
     , latest_tx_time -- 最后交易时间
     , transaction_count
     , transaction_volume
     , balance_count
     , balance_usd
     , days
     , transaction_volume_3d
     , transaction_volume_7d
     , transaction_volume_15d
     , transaction_volume_1m
     , transaction_volume_3m
     , transaction_volume_6m
     , transaction_volume_1y
     , transaction_volume_2y
     , transaction_count_3d
     , transaction_count_7d
     , transaction_count_15d
     , transaction_count_1m
     , transaction_count_3m
     , transaction_count_6m
     , transaction_count_1y
     , transaction_count_2y
     , now() as etl_update_time
from dws_eth_index_n_tmp1
union all
select b_type
     , statistical_type
     , address
     , project
     , platform_name
     , token
     , type
     , first_tx_time  --最早交易时间
     , latest_tx_time -- 最后交易时间
     , transaction_count
     , transaction_volume
     , balance_count
     , balance_usd
     , days
     , transaction_volume_3d
     , transaction_volume_7d
     , transaction_volume_15d
     , transaction_volume_1m
     , transaction_volume_3m
     , transaction_volume_6m
     , transaction_volume_1y
     , transaction_volume_2y
     , transaction_count_3d
     , transaction_count_7d
     , transaction_count_15d
     , transaction_count_1m
     , transaction_count_3m
     , transaction_count_6m
     , transaction_count_1y
     , transaction_count_2y
     , now() as etl_update_time
from dws_eth_index_n_tmp3
;
insert into tag_result(table_name, batch_date)
SELECT 'dws_eth_index_n' as table_name, '${batchDate}' as batch_date;