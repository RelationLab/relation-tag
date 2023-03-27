-- DROP TABLE if EXISTS  token_address_activity;
-- create table token_address_activity
-- (
--     address  varchar(200) not null,
--     token  varchar(200) not null,
--     activity_num numeric(250, 20) NULL,
--     code_type varchar(10) not null
-- );
--
-- truncate table token_address_activity;
-- insert
-- into
--     token_address_activity(activity_num,
--                            address,
--                            token,
--                            code_type)
-- select
--     sum(activity_num),
--     address,
--     token,
--     code_type
-- from
--     (
--         select
--             sum(total_transfer_count) as activity_num,
--             address,
--             token,
--             'DEFI' as code_type
--         from
--             token_holding_vol_count
--         group by
--             address,
--             token
--         union all
--         select
--             sum(total_transfer_all_count) as activity_num,
--             address,
--             token,
--             'NFT' as code_type
--         from
--             nft_holding
--         group by
--             address,
--             token)
--         out_t
-- group by
--     address,
--     token,
--     code_type;

DROP TABLE if EXISTS  static_asset_level_data;
create table static_asset_level_data
(
    static_code  varchar(200) not null,
    address_num numeric(250, 20) NULL,
    dimension_type varchar(50)  null,---维度类型:token\project\action
    bus_type varchar(50)  null,---业务类型:vol balance activity
    "level" varchar(50)  null----级别类型 L1\L2....
);

insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    token as static_code,
    count(1) as address_num,
    'token' as dimension_type,
    'balance' AS bus_type,
        as level
from
    address_label_gp
group by token
UNION ALL
select
    token as code,
    count(1) as volume_address_num,
    'token' as code_type,
    'NFT' AS token_type
from
    nft_holding
group by token;


UPDATE
    static_total_data
SET
    activity_address_num = subquery.activity_address_num
    FROM
	(
	SELECT
		count(address) AS activity_address_num,
		token as code,
		'token' AS code_type
	FROM
		token_volume_usd
	GROUP BY
		token
	) AS subquery
WHERE
    static_total_data.code = subquery.code
  AND static_total_data.code_type = subquery.code_type;


update
    static_total_data
set
    balance_address_num = subquery.balance_address_num
    from
	(
	select
    token as code,
    count(1) as balance_address_num,
    'token' as code_type
from
    token_volume_usd
group by token
UNION ALL
select
    token as code,
    count(1) as balance_address_num,
    'token' as code_type
from
    nft_holding
group by token
	) as subquery
where
    static_total_data.code = subquery.code
    and static_total_data.code_type=subquery.code_type;


insert into static_asset_data  (code,volume_address_num,activity_address_num,code_type,token_type)
select
    token as code,
    count(1) as volume_address_num,
    count(1) as activity_address_num,
    'platform' as code_type,
    'DEFI' AS token_type
from
    dex_tx_volume_count_summary
group by project
UNION ALL
select
    token as code,
    count(1) as volume_address_num,
    count(1) as activity_address_num,
    'platform' as code_type,
    'NFT' AS token_type
from
    platform_nft_volume_usd
group by platform;


insert into static_asset_data  (code,volume_address_num,activity_address_num,code_type,token_type)
select
    type as code,
    count(1) as volume_address_num,
    count(1) as activity_address_num,
    'type' as code_type,
    'DEFI' AS token_type
from
    dex_tx_volume_count_summary
group by type
UNION ALL
select
    type as code,
    count(1) as volume_address_num,
    count(1) as activity_address_num,
    'type' as code_type,
    'NFT' AS token_type
from
    platform_nft_type_volume_count
group by type;


