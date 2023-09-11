DROP TABLE IF EXISTS dws_eth_index_n;
create table   dws_eth_index_n (
-- 维度
                                   b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  platform_name   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间

    ,  transaction_count        numeric(125, 0)     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的

    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    numeric(125, 0)
    ,  transaction_count_7d    numeric(125, 0)
    ,  transaction_count_15d   numeric(125, 0)
    ,  transaction_count_1m    numeric(125, 0)
    ,  transaction_count_3m    numeric(125, 0)
    ,  transaction_count_6m    numeric(125, 0)
    ,  transaction_count_1y    numeric(125, 0)
    ,  transaction_count_2y    numeric(125, 0)
    ,  etl_update_time timestamp
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;


DROP TABLE IF EXISTS dws_eth_index_n_tmp1;
create table  dws_eth_index_n_tmp1 (
-- 维度
                                       b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  platform_name   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间

    ,  transaction_count        int8     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的

    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    int8
    ,  transaction_count_7d    int8
    ,  transaction_count_15d   int8
    ,  transaction_count_1m    int8
    ,  transaction_count_3m    int8
    ,  transaction_count_6m    int8
    ,  transaction_count_1y    int8
    ,  transaction_count_2y    int8
    ,  etl_update_time timestamp
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;




DROP TABLE IF EXISTS dws_eth_index_n_tmp10;
create table  dws_eth_index_n_tmp10 (
-- 维度
                                        b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间

    ,  transaction_count        int8     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的

    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    int8
    ,  transaction_count_7d    int8
    ,  transaction_count_15d   int8
    ,  transaction_count_1m    int8
    ,  transaction_count_3m    int8
    ,  transaction_count_6m    int8
    ,  transaction_count_1y    int8
    ,  transaction_count_2y    int8
    ,  etl_update_time timestamp
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;


DROP TABLE IF EXISTS dws_eth_index_n_tmp2;
create table  dws_eth_index_n_tmp2 (
-- 维度
                                       b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  platform_name   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间

    ,  transaction_count        int8     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的

    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    int8
    ,  transaction_count_7d    int8
    ,  transaction_count_15d   int8
    ,  transaction_count_1m    int8
    ,  transaction_count_3m    int8
    ,  transaction_count_6m    int8
    ,  transaction_count_1y    int8
    ,  transaction_count_2y    int8
    ,  etl_update_time timestamp
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;




DROP TABLE IF EXISTS dws_eth_index_n_tmp3;
create table  dws_eth_index_n_tmp3 (
-- 维度
                                       b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  platform_name   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间

    ,  transaction_count        int8     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的

    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    int8
    ,  transaction_count_7d    int8
    ,  transaction_count_15d   int8
    ,  transaction_count_1m    int8
    ,  transaction_count_3m    int8
    ,  transaction_count_6m    int8
    ,  transaction_count_1y    int8
    ,  transaction_count_2y    int8
    ,  etl_update_time timestamp
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;







drop table if exists dws_web3_index_n;
create table dws_web3_index_n (
    -- 维度
                                  b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  platform_name   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间

    ,  transaction_count        int8     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的

    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    int8
    ,  transaction_count_7d    int8
    ,  transaction_count_15d   int8
    ,  transaction_count_1m    int8
    ,  transaction_count_3m    int8
    ,  transaction_count_6m    int8
    ,  transaction_count_1y    int8
    ,  transaction_count_2y    int8
    ,  etl_update_time timestamp

)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;




drop table if exists dws_nft_index_n;
create table  dws_nft_index_n (
    -- 维度
                                  b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  platform_name   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间
    ,  transaction_count        int8     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的
    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    int8
    ,  transaction_count_7d    int8
    ,  transaction_count_15d   int8
    ,  transaction_count_1m    int8
    ,  transaction_count_3m    int8
    ,  transaction_count_6m    int8
    ,  transaction_count_1y    int8
    ,  transaction_count_2y    int8
    ,  etl_update_time timestamp

)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;



drop table if exists dws_nft_index_n_tmp1;
create table  dws_nft_index_n_tmp1 (
    -- 维度
                                       b_type   varchar(256)     --  业务类型
    ,  statistical_type   varchar(256)  -- 业务统计类型
    ,  address    varchar(256)     --地址
    ,  project   varchar(256)      -- 项目
    ,  platform_name   varchar(256)      -- 项目
    ,  token     varchar(256)      -- token
    ,  type             varchar(256)   -- 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    ,  first_tx_time   timestamp                          --最早交易时间
    ,  latest_tx_time   timestamp  -- 最后交易时间
    ,  transaction_count        int8     -- 交易次数
    ,  transaction_volume              numeric(125, 30)   -- 交易量  添加了余额后的
    ,  balance_count              numeric(125, 30)
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_3d   numeric(125, 30)
    ,  transaction_volume_7d    numeric(125, 30)
    ,  transaction_volume_15d   numeric(125, 30)
    ,  transaction_volume_1m    numeric(125, 30)
    ,  transaction_volume_3m     numeric(125, 30)
    ,  transaction_volume_6m   numeric(125, 30)
    ,  transaction_volume_1y    numeric(125, 30)
    ,  transaction_volume_2y   numeric(125, 30)
    ,  transaction_count_3d    int8
    ,  transaction_count_7d    int8
    ,  transaction_count_15d   int8
    ,  transaction_count_1m    int8
    ,  transaction_count_3m    int8
    ,  transaction_count_6m    int8
    ,  transaction_count_1y    int8
    ,  transaction_count_2y    int8
    ,  etl_update_time timestamp

)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,type)
;




--等待修改
drop table if exists wired_address_dataset_temp ;
create table  wired_address_dataset_temp  (
                                              b_type   varchar(256)     --  业务类型
    , statistical_type   varchar(256)  -- 业务统计类型
    , address    varchar(256)     --地址
    , project   varchar(256)      -- 项目
    , platform_name    varchar(256)  -- 平台名称
    , token     varchar(256)      -- token
    , asset    varchar(256) -- token 名称
    , action             varchar(256)   -- type 交易类型
--指标（统计度量）
-- 这个看作特殊 唯独下的 统计度量
    , first_tx_time   timestamp                          --最早交易时间
    , latest_tx_time   timestamp                         -- 最后交易时间
    , transaction_volume_usd               numeric(125, 30)   -- 交易量  添加了余额后的
    , transaction_count    numeric(125, 0)      -- 交易次数
-- 余额如何统计 当前的最新额余额  不管什么阶段  的值是一样的 
    ,  balance_count numeric(125, 30)   -- 余额个数
    ,  balance_usd      numeric(125, 30)   -- 余额
    ,  days      int8   -- 持有天数
    ,  transaction_volume_usd_3d   numeric(125, 30)
    ,  transaction_volume_usd_7d    numeric(125, 30)
    ,  transaction_volume_usd_15d   numeric(125, 30)
    ,  transaction_volume_usd_1m    numeric(125, 30)
    ,  transaction_volume_usd_3m     numeric(125, 30)
    ,  transaction_volume_usd_6m   numeric(125, 30)
    ,  transaction_volume_usd_1y    numeric(125, 30)
    ,  transaction_volume_usd_2y   numeric(125, 30)
    ,  transaction_count_3d    numeric(125, 0)
    ,  transaction_count_7d    numeric(125, 0)
    ,  transaction_count_15d   numeric(125, 0)
    ,  transaction_count_1m    numeric(125, 0)
    ,  transaction_count_3m    numeric(125, 0)
    ,  transaction_count_6m    numeric(125, 0)
    ,  transaction_count_1y    numeric(125, 0)
    ,  transaction_count_2y    numeric(125, 0)
    ,  etl_update_time timestamp
)
    with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by(b_type,statistical_type,address,project,action);
insert into tag_result(table_name,batch_date)  SELECT 'table_defi_wide_table_ddl' as table_name,'${batchDate}'  as batch_date;
