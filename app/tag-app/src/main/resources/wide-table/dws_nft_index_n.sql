-- 第一部分
truncate  table dws_nft_index_n_tmp1;
insert into dws_nft_index_n_tmp1
-- 所有平台 
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型
    ,   s1.address
	,  'ALLNET' as  project  --ALL  是产品中全部5个的平台     如果为空就是全部
	,  'ALLNET' AS platform_name
	,  s1.token
 --    ,  s2.platform as  asset
    ,  'ALL' as type
	,  null as first_tx_time                             --最早交易时间
    ,  null as latest_tx_time     -- 最后交易时间 
	,  sum(case when recent_time_code='ALL' then total_transfer_all_volume  else 0 end) as transaction_volume
	,  sum(case when recent_time_code='ALL' then total_transfer_all_count  else 0 end) as transaction_count
    ,  sum(case when recent_time_code='ALL' then balance  else 0 end) as balance_count
    ,  null  as  balance_usd
	,  sum(case when recent_time_code='3d' then total_transfer_all_volume else null end)  as transaction_volume_3d 
	,  sum(case when recent_time_code='7d' then total_transfer_all_volume else null end)  as transaction_volume_7d 
	,  sum(case when recent_time_code='15d' then total_transfer_all_volume else null end)  as transaction_volume_15d
	,  sum(case when recent_time_code='1m' then total_transfer_all_volume else null end)  as transaction_volume_1m 
	,  sum(case when recent_time_code='3m' then total_transfer_all_volume else null end)  as transaction_volume_3m 
	,  sum(case when recent_time_code='6m' then total_transfer_all_volume else null end)  as transaction_volume_6m 
	,  sum(case when recent_time_code='1y' then total_transfer_all_volume else null end)  as transaction_volume_1y 
	,  sum(case when recent_time_code='2y' then total_transfer_all_volume else null end)  as transaction_volume_2y 
	
    ,  sum(case when recent_time_code='3d'  then total_transfer_all_count else null end)  as transaction_count_3d 
	,  sum(case when recent_time_code='7d'  then total_transfer_all_count else null end)  as transaction_count_7d 
	,  sum(case when recent_time_code='15d' then total_transfer_all_count else null end)  as transaction_count_15d
	,  sum(case when recent_time_code='1m'  then total_transfer_all_count else null end)  as transaction_count_1m 
	,  sum(case when recent_time_code='3m'  then total_transfer_all_count else null end)  as transaction_count_3m 
	,  sum(case when recent_time_code='6m'  then total_transfer_all_count else null end)  as transaction_count_6m 
	,  sum(case when recent_time_code='1y'  then total_transfer_all_count else null end)  as transaction_count_1y 
	,  sum(case when recent_time_code='2y'  then total_transfer_all_count else null end)  as transaction_count_2y 	
	 ,now() as etl_update_time
 from  nft_holding_temp  s1 inner join  nft_sync_address s2
 on s1.token=s2.address
 --  left join  platform_nft_sync_address  s3
 where  s2.type<>'ERC1155'
group by 
       s1.address
     , s1.token
	--  , s2.platform 
;
	 



insert into dws_nft_index_n_tmp1
-- 所有平台 
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型
    ,   s1.address
	,  'ALLNET' as  project  --ALL  是产品中全部5个的平台     如果为空就是全部
	,  'ALLNET' AS platform_name
	,  'ALL' AS token
 --    ,  s2.platform as  asset
    ,  'ALL' as type
	,  null as first_tx_time                             --最早交易时间
    ,  null as latest_tx_time     -- 最后交易时间 
	,  sum(case when recent_time_code='ALL' then total_transfer_all_volume  else 0 end) as transaction_volume
	,  sum(case when recent_time_code='ALL' then total_transfer_all_count  else 0 end) as transaction_count
    ,  sum(case when recent_time_code='ALL' then balance  else 0 end) as balance_count
    ,  null  as  balance_usd
	,  sum(case when recent_time_code='3d' then total_transfer_all_volume else null end)  as transaction_volume_3d 
	,  sum(case when recent_time_code='7d' then total_transfer_all_volume else null end)  as transaction_volume_7d 
	,  sum(case when recent_time_code='15d' then total_transfer_all_volume else null end)  as transaction_volume_15d
	,  sum(case when recent_time_code='1m' then total_transfer_all_volume else null end)  as transaction_volume_1m 
	,  sum(case when recent_time_code='3m' then total_transfer_all_volume else null end)  as transaction_volume_3m 
	,  sum(case when recent_time_code='6m' then total_transfer_all_volume else null end)  as transaction_volume_6m 
	,  sum(case when recent_time_code='1y' then total_transfer_all_volume else null end)  as transaction_volume_1y 
	,  sum(case when recent_time_code='2y' then total_transfer_all_volume else null end)  as transaction_volume_2y 
	
    ,  sum(case when recent_time_code='3d'  then total_transfer_all_count else null end)  as transaction_count_3d 
	,  sum(case when recent_time_code='7d'  then total_transfer_all_count else null end)  as transaction_count_7d 
	,  sum(case when recent_time_code='15d' then total_transfer_all_count else null end)  as transaction_count_15d
	,  sum(case when recent_time_code='1m'  then total_transfer_all_count else null end)  as transaction_count_1m 
	,  sum(case when recent_time_code='3m'  then total_transfer_all_count else null end)  as transaction_count_3m 
	,  sum(case when recent_time_code='6m'  then total_transfer_all_count else null end)  as transaction_count_6m 
	,  sum(case when recent_time_code='1y'  then total_transfer_all_count else null end)  as transaction_count_1y 
	,  sum(case when recent_time_code='2y'  then total_transfer_all_count else null end)  as transaction_count_2y 	
	 ,now() as etl_update_time
 from  nft_holding_temp  s1 inner join  nft_sync_address s2
 on s1.token=s2.address
 --  left join  platform_nft_sync_address  s3
 where  s2.type<>'ERC1155'
group by 
       s1.address
;


	 
-- 第二部分	 
insert into dws_nft_index_n_tmp1
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型 
    ,   s1.address
	,  'ALLNET' as  project  --ALL  是产品中全部5个的平台     如果为空就是全部
	,  'ALLNET' AS platform_name
	,  s1.token
--     ,  s2.platform as  asset
    ,  s1.type
	,  null as first_tx_time                             --最早交易时间
    ,  null as latest_tx_time     -- 最后交易时间  
    ,  sum(case when recent_time_code='ALL' then transfer_volume  else 0 end) as transaction_volume
	,  sum(case when recent_time_code='ALL' then transfer_count  else 0 end) as transaction_count
    ,  cast(null as int) as  balance_count
    ,  cast(null as int)  as  balance_usd
	
	,  sum(case when recent_time_code='3d' then transfer_volume else null end)  as transaction_volume_3d 
	,  sum(case when recent_time_code='7d' then transfer_volume else null end)  as transaction_volume_7d 
	,  sum(case when recent_time_code='15d' then transfer_volume else null end)  as transaction_volume_15d
	,  sum(case when recent_time_code='1m' then transfer_volume else null end)  as transaction_volume_1m 
	,  sum(case when recent_time_code='3m' then transfer_volume else null end)  as transaction_volume_3m 
	,  sum(case when recent_time_code='6m' then transfer_volume else null end)  as transaction_volume_6m 
	,  sum(case when recent_time_code='1y' then transfer_volume else null end)  as transaction_volume_1y 
	,  sum(case when recent_time_code='2y' then transfer_volume else null end)  as transaction_volume_2y 
	
    ,  sum(case when recent_time_code='3d'  then transfer_count else null end)  as transaction_count_3d 
	,  sum(case when recent_time_code='7d'  then transfer_count else null end)  as transaction_count_7d 
	,  sum(case when recent_time_code='15d' then transfer_count else null end)  as transaction_count_15d
	,  sum(case when recent_time_code='1m'  then transfer_count else null end)  as transaction_count_1m 
	,  sum(case when recent_time_code='3m'  then transfer_count else null end)  as transaction_count_3m 
	,  sum(case when recent_time_code='6m'  then transfer_count else null end)  as transaction_count_6m 
	,  sum(case when recent_time_code='1y'  then transfer_count else null end)  as transaction_count_1y 
	,  sum(case when recent_time_code='2y'  then transfer_count else null end)  as transaction_count_2y 	

	,now() as etl_update_time
from  nft_volume_count_temp S1  
 inner join  nft_sync_address s2
 on s1.token=s2.address
  where  s2.type<>'ERC1155'
  group by s1.address,s1.token
  ,s1.type
  
;  
 
 
 
 insert into dws_nft_index_n_tmp1
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型 
    ,   s1.address
	,  'ALLNET' as  project  --ALL  是产品中全部5个的平台     如果为空就是全部
	,  'ALLNET' AS platform_name
	,  'ALL' AS token
--     ,  s2.platform as  asset
    ,  s1.type
	,  null as first_tx_time                             --最早交易时间
    ,  null as latest_tx_time     -- 最后交易时间  
    ,  sum(case when recent_time_code='ALL' then transfer_volume  else 0 end) as transaction_volume
	,  sum(case when recent_time_code='ALL' then transfer_count  else 0 end) as transaction_count
    ,  cast(null as int) as  balance_count
    ,  cast(null as int)  as  balance_usd
	
	,  sum(case when recent_time_code='3d' then transfer_volume else null end)  as transaction_volume_3d   --交易个数
	,  sum(case when recent_time_code='7d' then transfer_volume else null end)  as transaction_volume_7d 
	,  sum(case when recent_time_code='15d' then transfer_volume else null end)  as transaction_volume_15d
	,  sum(case when recent_time_code='1m' then transfer_volume else null end)  as transaction_volume_1m 
	,  sum(case when recent_time_code='3m' then transfer_volume else null end)  as transaction_volume_3m 
	,  sum(case when recent_time_code='6m' then transfer_volume else null end)  as transaction_volume_6m 
	,  sum(case when recent_time_code='1y' then transfer_volume else null end)  as transaction_volume_1y 
	,  sum(case when recent_time_code='2y' then transfer_volume else null end)  as transaction_volume_2y 
	
    ,  sum(case when recent_time_code='3d'  then transfer_count else null end)  as transaction_count_3d 
	,  sum(case when recent_time_code='7d'  then transfer_count else null end)  as transaction_count_7d 
	,  sum(case when recent_time_code='15d' then transfer_count else null end)  as transaction_count_15d
	,  sum(case when recent_time_code='1m'  then transfer_count else null end)  as transaction_count_1m 
	,  sum(case when recent_time_code='3m'  then transfer_count else null end)  as transaction_count_3m 
	,  sum(case when recent_time_code='6m'  then transfer_count else null end)  as transaction_count_6m 
	,  sum(case when recent_time_code='1y'  then transfer_count else null end)  as transaction_count_1y 
	,  sum(case when recent_time_code='2y'  then transfer_count else null end)  as transaction_count_2y 	

	,now() as etl_update_time
from  nft_volume_count_temp S1  
 inner join  nft_sync_address s2
 on s1.token=s2.address
  where  s2.type<>'ERC1155'
  group by s1.address
  ,s1.type
  
;  



 
 
--第三部分
insert into dws_nft_index_n_tmp1
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型 
    ,  s1.address 
	,s1.platform  as project
	,s2.platform_name  
	,s1.token 
--	,s3.platform as  asset
	,s1.type
	,  null as first_tx_time                             --最早交易时间
    ,  null as latest_tx_time     -- 最后交易时间 
	, sum(case when recent_time_code='ALL' then s1.volume_usd  else null end)  as transaction_volume
	, sum(case when recent_time_code='ALL' then s1.transfer_count  else null end)  as transaction_count
    ,  null  as  balance_count
    ,  null  as  balance_usd

	,  sum(case when recent_time_code='3d' then volume_usd else null end)  as transaction_volume_3d 
	,  sum(case when recent_time_code='7d' then volume_usd else null end)  as transaction_volume_7d 
	,  sum(case when recent_time_code='15d' then volume_usd else null end)  as transaction_volume_15d
	,  sum(case when recent_time_code='1m' then volume_usd else null end)  as transaction_volume_1m 
	,  sum(case when recent_time_code='3m' then volume_usd else null end)  as transaction_volume_3m 
	,  sum(case when recent_time_code='6m' then volume_usd else null end)  as transaction_volume_6m 
	,  sum(case when recent_time_code='1y' then volume_usd else null end)  as transaction_volume_1y 
	,  sum(case when recent_time_code='2y' then volume_usd else null end)  as transaction_volume_2y 
	
    ,  sum(case when recent_time_code='3d'  then transfer_count else null end)  as transaction_count_3d 
	,  sum(case when recent_time_code='7d'  then transfer_count else null end)  as transaction_count_7d 
	,  sum(case when recent_time_code='15d' then transfer_count else null end)  as transaction_count_15d
	,  sum(case when recent_time_code='1m'  then transfer_count else null end)  as transaction_count_1m 
	,  sum(case when recent_time_code='3m'  then transfer_count else null end)  as transaction_count_3m 
	,  sum(case when recent_time_code='6m'  then transfer_count else null end)  as transaction_count_6m 
	,  sum(case when recent_time_code='1y'  then transfer_count else null end)  as transaction_count_1y 
	,  sum(case when recent_time_code='2y'  then transfer_count else null end)  as transaction_count_2y 	

	,now() as etl_update_time
	
  from  platform_nft_type_volume_count_temp  s1  left join  mp_nft_platform s2 
  on s1.platform=s2.platform
  left join   nft_sync_address s3 
  on s1.token=s3.address
  where   s3.type<>'ERC1155'
  
  group  by    
	 s1.address 
	,s1.platform 
	,s2.platform_name  
	,s1.token 
	-- ,s3.platform
	,s1.type	
;



--第四部分
insert into dws_nft_index_n_tmp1
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型 
    ,s1.address 
	,'ALL' AS  project
	,'ALL' AS  platform_name  
	,s1.token 
-- 	,s3.platform as  asset
	,s1.type
	,null as first_tx_time                             --最早交易时间
    ,null as latest_tx_time     -- 最后交易时间 
	,sum(case when recent_time_code='ALL' then s1.volume_usd  else null end)  as transaction_volume
	,sum(case when recent_time_code='ALL' then s1.transfer_count  else null end)  as transaction_count
    ,null  as  balance_count
    ,null  as  balance_usd

	,sum(case when recent_time_code='3d' then volume_usd else null end)  as transaction_volume_3d 
	,sum(case when recent_time_code='7d' then volume_usd else null end)  as transaction_volume_7d 
	,sum(case when recent_time_code='15d' then volume_usd else null end)  as transaction_volume_15d
	,sum(case when recent_time_code='1m' then volume_usd else null end)  as transaction_volume_1m 
	,sum(case when recent_time_code='3m' then volume_usd else null end)  as transaction_volume_3m 
	,sum(case when recent_time_code='6m' then volume_usd else null end)  as transaction_volume_6m 
	,sum(case when recent_time_code='1y' then volume_usd else null end)  as transaction_volume_1y 
	,sum(case when recent_time_code='2y' then volume_usd else null end)  as transaction_volume_2y 
	
    ,sum(case when recent_time_code='3d'  then transfer_count else null end)  as transaction_count_3d 
	,sum(case when recent_time_code='7d'  then transfer_count else null end)  as transaction_count_7d 
	,sum(case when recent_time_code='15d' then transfer_count else null end)  as transaction_count_15d
	,sum(case when recent_time_code='1m'  then transfer_count else null end)  as transaction_count_1m 
	,sum(case when recent_time_code='3m'  then transfer_count else null end)  as transaction_count_3m 
	,sum(case when recent_time_code='6m'  then transfer_count else null end)  as transaction_count_6m 
	,sum(case when recent_time_code='1y'  then transfer_count else null end)  as transaction_count_1y 
	,sum(case when recent_time_code='2y'  then transfer_count else null end)  as transaction_count_2y 	
	,now() as etl_update_time
  from  platform_nft_type_volume_count_temp  s1  left join  mp_nft_platform s2 
  on s1.platform=s2.platform
  inner join   nft_sync_address s3 
  on s1.token=s3.address
  where   s3.type<>'ERC1155'
  group  by    
	 s1.address 
	,s1.token 
	-- ,s3.platform
	,s1.type
;
	
insert into dws_nft_index_n_tmp1
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型 
    ,s1.address 
	,'ALL' AS  project
	,'ALL' AS  platform_name  
	,'ALL' AS token 
-- 	,s3.platform as  asset
	,s1.type
	,null as first_tx_time                             --最早交易时间
    ,null as latest_tx_time     -- 最后交易时间 
	,sum(case when recent_time_code='ALL' then s1.volume_usd  else null end)  as transaction_volume
	,sum(case when recent_time_code='ALL' then s1.transfer_count  else null end)  as transaction_count
    ,null  as  balance_count
    ,null  as  balance_usd

	,sum(case when recent_time_code='3d' then volume_usd else null end)  as transaction_volume_3d 
	,sum(case when recent_time_code='7d' then volume_usd else null end)  as transaction_volume_7d 
	,sum(case when recent_time_code='15d' then volume_usd else null end)  as transaction_volume_15d
	,sum(case when recent_time_code='1m' then volume_usd else null end)  as transaction_volume_1m 
	,sum(case when recent_time_code='3m' then volume_usd else null end)  as transaction_volume_3m 
	,sum(case when recent_time_code='6m' then volume_usd else null end)  as transaction_volume_6m 
	,sum(case when recent_time_code='1y' then volume_usd else null end)  as transaction_volume_1y 
	,sum(case when recent_time_code='2y' then volume_usd else null end)  as transaction_volume_2y 
	
    ,sum(case when recent_time_code='3d'  then transfer_count else null end)  as transaction_count_3d 
	,sum(case when recent_time_code='7d'  then transfer_count else null end)  as transaction_count_7d 
	,sum(case when recent_time_code='15d' then transfer_count else null end)  as transaction_count_15d
	,sum(case when recent_time_code='1m'  then transfer_count else null end)  as transaction_count_1m 
	,sum(case when recent_time_code='3m'  then transfer_count else null end)  as transaction_count_3m 
	,sum(case when recent_time_code='6m'  then transfer_count else null end)  as transaction_count_6m 
	,sum(case when recent_time_code='1y'  then transfer_count else null end)  as transaction_count_1y 
	,sum(case when recent_time_code='2y'  then transfer_count else null end)  as transaction_count_2y 	
	,now() as etl_update_time
  from  platform_nft_type_volume_count_temp  s1  left join  mp_nft_platform s2 
  on s1.platform=s2.platform
  inner join   nft_sync_address s3 
  on s1.token=s3.address
  where   s3.type<>'ERC1155'
  group  by    
	 s1.address 
	,s1.type
;




insert into dws_nft_index_n_tmp1
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型 
    ,s1.address 
	,s1.platform as project
	,s2.platform_name  platform_name  
	,'ALL' AS token 
-- 	,s3.platform as  asset
	,s1.type
	,null as first_tx_time                             --最早交易时间
    ,null as latest_tx_time     -- 最后交易时间 
	,sum(case when recent_time_code='ALL' then s1.volume_usd  else null end)  as transaction_volume
	,sum(case when recent_time_code='ALL' then s1.transfer_count  else null end)  as transaction_count
    ,null  as  balance_count
    ,null  as  balance_usd

	,sum(case when recent_time_code='3d' then volume_usd else null end)  as transaction_volume_3d 
	,sum(case when recent_time_code='7d' then volume_usd else null end)  as transaction_volume_7d 
	,sum(case when recent_time_code='15d' then volume_usd else null end)  as transaction_volume_15d
	,sum(case when recent_time_code='1m' then volume_usd else null end)  as transaction_volume_1m 
	,sum(case when recent_time_code='3m' then volume_usd else null end)  as transaction_volume_3m 
	,sum(case when recent_time_code='6m' then volume_usd else null end)  as transaction_volume_6m 
	,sum(case when recent_time_code='1y' then volume_usd else null end)  as transaction_volume_1y 
	,sum(case when recent_time_code='2y' then volume_usd else null end)  as transaction_volume_2y 
	
    ,sum(case when recent_time_code='3d'  then transfer_count else null end)  as transaction_count_3d 
	,sum(case when recent_time_code='7d'  then transfer_count else null end)  as transaction_count_7d 
	,sum(case when recent_time_code='15d' then transfer_count else null end)  as transaction_count_15d
	,sum(case when recent_time_code='1m'  then transfer_count else null end)  as transaction_count_1m 
	,sum(case when recent_time_code='3m'  then transfer_count else null end)  as transaction_count_3m 
	,sum(case when recent_time_code='6m'  then transfer_count else null end)  as transaction_count_6m 
	,sum(case when recent_time_code='1y'  then transfer_count else null end)  as transaction_count_1y 
	,sum(case when recent_time_code='2y'  then transfer_count else null end)  as transaction_count_2y 	
	,now() as etl_update_time
  from  platform_nft_type_volume_count_temp  s1  left join  mp_nft_platform s2 
  on s1.platform=s2.platform
  inner join   nft_sync_address s3 
  on s1.token=s3.address
  where   s3.type<>'ERC1155'
  group  by    
	 s1.address 
	,s1.platform
	,s2.platform_name
	,s1.type
;
	
-- 第五部分
insert into dws_nft_index_n_tmp1
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型 
    , s1.address 
	,'ALLNET' AS  project
	,'ALLNET' AS  platform_name  
	, s1.token 
	, 'ALL' AS type
    , min(s1.latest_tx_time) as latest_tx_time
	, max(s1.first_tx_time) as first_tx_time
	, null  as transaction_volume
	, null  as transaction_count
    ,  null  as  balance_count
    ,  null  as  balance_usd

	,  null   as transaction_volume_3d 
	,  null   as transaction_volume_7d 
	,  null    as transaction_volume_15d
	,  null   as transaction_volume_1m 
	,  null   as transaction_volume_3m 
	,  null   as transaction_volume_6m 
	,  null   as transaction_volume_1y 
	,  null   as transaction_volume_2y 
    ,  null  as  transaction_count_3d 
	,  null  as  transaction_count_7d 
	,  null  as  transaction_count_15d
	,  null  as  transaction_count_1m 
	,  null  as  transaction_count_3m 
	,  null  as  transaction_count_6m 
	,  null  as  transaction_count_1y 
	,  null  as  transaction_count_2y 	
	,now() as etl_update_time
	from   nft_holding_time_temp  s1 inner join  nft_sync_address s2
  on s1.token=s2.address
    where   s2.type<>'ERC1155'
	group by s1.address ,s1.token 
 ; 
 














-- 汇总
truncate table dws_nft_index_n;
insert into dws_nft_index_n
select 
-- 维度
      'nft' as b_type   --  业务类型 
    , 'nft' asstatistical_type   -- 业务统计类型
    , s1.address
	, s1.project
	, s1.platform_name
	, s1.token
	, s1.type
-- 指标	
	,min(s1.first_tx_time)  as   first_tx_time                          --最早交易时间
    ,max(s1.latest_tx_time)    as    latest_tx_time                     -- 最后交易时间
    ,sum(s1.transaction_count) as  transaction_count
	,sum(s1.transaction_volume) as transaction_volume
	,sum(s1.balance_count)  as balance_count
   	,sum(s1.balance_usd) as  balance_usd
	,sum(s1.transaction_volume_3d) as transaction_volume_3d
	,sum(s1.transaction_volume_7d)  as transaction_volume_7d
	,sum(s1.transaction_volume_15d) as transaction_volume_15d
	,sum(s1.transaction_volume_1m)  as transaction_volume_1m
	,sum(s1.transaction_volume_3m)  as transaction_volume_3m
	,sum(s1.transaction_volume_6m)  as transaction_volume_6m
	,sum(s1.transaction_volume_1y)  as transaction_volume_1y
	,sum(s1.transaction_volume_2y) as transaction_volume_2y
	,sum(s1.transaction_count_3d)  as transaction_count_3d
	,sum(s1.transaction_count_7d)  as transaction_count_7d
	,sum(s1.transaction_count_15d) as transaction_count_15d
	,sum(s1.transaction_count_1m)  as transaction_count_1m
	,sum(s1.transaction_count_3m)  as transaction_count_3m
	,sum(s1.transaction_count_6m)  as transaction_count_6m
	,sum(s1.transaction_count_1y)  as transaction_count_1y
	,sum(s1.transaction_count_2y)  as transaction_count_2y
    ,now() as etl_update_time
 from 
(
-- 所有平台 
select 
       address
	,  project  --ALL  是产品中全部5个的平台     如果为空就是全部
	,  platform_name
	,  token
   -- ,  asset
    ,  type
	,  first_tx_time                             --最早交易时间
    ,  latest_tx_time     -- 最后交易时间 
	,  transaction_volume
	,  transaction_count
    ,  balance_count
    ,  balance_usd
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
	 ,now() as etl_update_time
from   dws_nft_index_n_tmp1
 )  as  s1 
 group  by      s1.address
	, s1.project
	, s1.platform_name
	, s1.token
	, s1.type;
insert into tag_result(table_name,batch_date)  SELECT 'dws_nft_index_n' as table_name,'${batchDate}'  as batch_date;