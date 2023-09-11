truncate table wired_address_dataset_temp;
insert into wired_address_dataset_temp
select s1.b_type
     , s1.statistical_type
     , s1.address
     , s1.project
     , s1.platform_name
     , s1.token
     , case when s1.token = 'ALL' then 'ALL' else s2.name end as asset -- token 名称
     , s1.type as action
	,s1.first_tx_time                             --最早交易时间
    ,s1.latest_tx_time                            -- 最后交易时间
    ,s1.transaction_volume
	,s1.transaction_count
	,s1.balance_count
   	,s1.balance_usd
    ,s1.days
	,s1.transaction_volume_3d 
	,s1.transaction_volume_7d 
	,s1.transaction_volume_15d
	,s1.transaction_volume_1m 
	,s1.transaction_volume_3m 
	,s1.transaction_volume_6m 
	,s1.transaction_volume_1y 
	,s1.transaction_volume_2y 
	,s1.transaction_count_3d 
	,s1.transaction_count_7d 
	,s1.transaction_count_15d
	,s1.transaction_count_1m 
	,s1.transaction_count_3m 
	,s1.transaction_count_6m 
	,s1.transaction_count_1y 
	,s1.transaction_count_2y 	
    ,now() as etl_update_time
from dws_eth_index_n s1 left join (
    select address, name from top_token_1000 where removed= false and holders >= 100
    union all
    select distinct
    wlp.address, wlp.symbol_wired as name
    from white_list_lp_temp wlp
    left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
    where wlp.tvl > 1000000
    and wlp.symbols <@ ARRAY(
select
	symbol
from
	top_token_1000_temp
where
	holders >= 100
	and removed = false)
    and wlp."type" = 'LP'
    ) s2
on s1.token=s2.address
where s1.address not in (select address from exclude_address);


insert into wired_address_dataset_temp
select s1.b_type
     , s1.statistical_type
     , s1.address
     , s1.project
     , s1.platform_name
     , s1.token
     , 'ALL' as asset -- token 名称
     , s1.type as action
	,s1.first_tx_time                             --最早交易时间
    ,s1.latest_tx_time                            -- 最后交易时间
	,s1.transaction_volume
    ,s1.transaction_count
	,s1.balance_count
   	,s1.balance_usd
    ,s1.days
	,s1.transaction_volume_3d
	,s1.transaction_volume_7d
	,s1.transaction_volume_15d
	,s1.transaction_volume_1m
	,s1.transaction_volume_3m
	,s1.transaction_volume_6m
	,s1.transaction_volume_1y
	,s1.transaction_volume_2y
	,s1.transaction_count_3d
	,s1.transaction_count_7d
	,s1.transaction_count_15d
	,s1.transaction_count_1m
	,s1.transaction_count_3m
	,s1.transaction_count_6m
	,s1.transaction_count_1y
	,s1.transaction_count_2y
    ,now() as etl_update_time
from dws_web3_index_n s1
where s1.address not in (select address from exclude_address);

insert into wired_address_dataset_temp
select s1.b_type
     , s1.statistical_type
     , s1.address
     , s1.project
     , s1.platform_name
     , s1.token
     , case when s1.token = 'ALL' then 'ALL' else s2.platform end as asset -- token 名称
     , s1.type as action
	,s1.first_tx_time                             --最早交易时间
    ,s1.latest_tx_time                            -- 最后交易时间
    ,s1.transaction_volume
	,s1.transaction_count
	,s1.balance_count
   	,s1.balance_usd
    ,s1.days
	,s1.transaction_volume_3d 
	,s1.transaction_volume_7d 
	,s1.transaction_volume_15d
	,s1.transaction_volume_1m 
	,s1.transaction_volume_3m 
	,s1.transaction_volume_6m 
	,s1.transaction_volume_1y 
	,s1.transaction_volume_2y 
	,s1.transaction_count_3d 
	,s1.transaction_count_7d 
	,s1.transaction_count_15d
	,s1.transaction_count_1m 
	,s1.transaction_count_3m 
	,s1.transaction_count_6m 
	,s1.transaction_count_1y 
	,s1.transaction_count_2y 	
    ,now() as etl_update_time
from dws_nft_index_n s1 left join
    nft_sync_address_temp s2
on s1.token=s2.address
where s1.address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'wired_address_dataset' as table_name, '${batchDate}' as batch_date;