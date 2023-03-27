DROP TABLE if EXISTS  address_label_gp;
create table address_label_gp
(
    "owner" varchar(256) NULL,
    address varchar(512) NULL,
    "data" numeric(250, 20) NULL,
    wired_type varchar(20) NULL,
    label_type varchar(512) NULL,
    label_name varchar(1024) NULL,
    "source" varchar(100) NULL,
    updated_at timestamp(6) NULL,
    "group" varchar(1) NULL,
    "level" varchar(80) NULL,
    category varchar(80) NULL,
    trade_type varchar(80) NULL,
    project varchar(80) NULL,
    asset varchar(80) NULL,
    bus_type varchar(20) NULL
) distributed by (address);


truncate table address_label_gp;
vacuum address_label_gp;
insert into public.address_label_gp(address,label_type,label_name,wired_type,data,updated_at,owner,source,"group",level,category,trade_type,project,asset,bus_type)
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_eth_count_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_project_type_count_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_project_type_volume_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_project_type_volume_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_project_type_count_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_project_type_volume_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_project_type_volume_count_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_project_type_volume_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_project_type_volume_top  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_balance_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_count_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_time_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_volume_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_balance_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_balance_top  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_time_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_time_top  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_volume_count_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_volume_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_volume_top  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_transfer_count_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_transfer_volume_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_transfer_volume_count_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_transfer_volume_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_nft_transfer_volume_top  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_count_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_time_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_volume_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_eth_balance_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_eth_volume_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_time_special  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_top  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_volume_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_usdt_balance_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_usdt_volume_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_web3_type_balance_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_web3_type_count_grade  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_web3_type_balance_rank  union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_web3_type_balance_top union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_provider union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_staked union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_time_first_lp union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_time_first_stake union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_eth_time_grade union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_eth_time_special union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_grade_all union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_volume_grade_all union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_rank_all union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_balance_top_all union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_token_volume_rank_all union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_univ3_balance_grade union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_univ3_count_grade union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_univ3_volume_grade union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_univ3_balance_rank union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_univ3_balance_top union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from address_label_univ3_volume_rank union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_active_users union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_defi_active_users union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_defi_high_demander union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_elite union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_long_term_holder union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_nft_active_users union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_nft_high_demander union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_nft_whale union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_token_whale union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_crowd_web3_active_users union all
select address,label_type,label_name,wired_type,data,updated_at,'-1' as owner,'SYSTEM' as source ,"group",level,category,trade_type,project,asset,bus_type from  address_label_univ3_balance_provider union all
select address,label_type,label_name,'OTHER' as wired_type,0 as data,updated_at, owner, source ,'' "group",'' level,'other' category,'' trade_type,'' project,'' asset,'' bus_type  from address_label_third_party union all
select address,label_type,label_name,'OTHER' as wired_type,0 as data,updated_at,owner, source ,'' "group",'' level,'other' category,'' trade_type,'' project,'' asset,'' bus_type  from address_label_ugc;

drop table if exists address_labels_json_gin;
create table address_labels_json_gin
(
    address    varchar(512),
    labels     jsonb,
    updated_at timestamp,
    address_type varchar(1),
    days int8 NULL
) distributed by (address);
-- 用户标签
truncate
    table public.address_labels_json_gin;
vacuum address_labels_json_gin;

insert into
    address_labels_json_gin(address,
                            address_type,
                            labels,
                            updated_at)
select
    address,
    'p',
    json_agg(
            json_build_object(
                    'type', label_type,
                    'name', label_name,
                    'wired_type', wired_type,
                    'data', data::text,
                    'group',"group",
                    'level',level,
                    'category',category,
                    'trade_type',trade_type,
                    'project',project,
                    'asset',asset
                )
                order by label_type desc)::jsonb as labels,
                CURRENT_TIMESTAMP as updated_at
from
    address_label_gp
group by address;

update
    address_labels_json_gin b
set
    address_type ='c'
    from
	contract  A
where
    b.address  = A.contract_address;


update
    address_labels_json_gin
set
    days = subquery.days
    from
	(
	select
		address_info.address,
		trunc((extract(epoch from cast(now() as TIMESTAMP)) - block_timestamp.timestamp) / (24 * 60 * 60)) as days
	from
		block_timestamp
	left join address_info
                         on
		(address_info.first_up_chain_block_height = block_timestamp.height)) as subquery
where
    address_labels_json_gin.address = subquery.address;


create table tag_result as select * from address_labels_json_gin limit 1;
--
-- update
--     address_info b
-- set
--     days = trunc((extract(epoch from cast( now() as TIMESTAMP)) - A."timestamp")/(24 * 60 * 60))
--     from
-- 	block_timestamp A
-- where
--     A.height = b.first_up_chain_block_height
--   and b.days is null;
--
-- UPDATE address_labels_json_gin b
-- SET days = A.days
--     FROM
-- address_info A
-- WHERE
--     A.address = b.address and b.days is null;







