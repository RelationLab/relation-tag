DROP TABLE if EXISTS  address_label_gp;
create table address_label_gp
(
    "owner" varchar(256) NULL,
    address varchar(512) NULL,
    "data" numeric(250, 20) NULL,
    wired_type varchar(100) NULL,
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
    bus_type varchar(100) NULL
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
select address,label_type,label_name,'OTHER' as wired_type,0 as data,updated_at, owner, source ,'' "group",'' level,'other' category,'' trade_type,'' project,'' asset,'' bus_type  from address_label_third_party_${tableSuffix} union all
select address,label_type,label_name,'OTHER' as wired_type,0 as data,updated_at,owner, source ,'' "group",'' level,'other' category,'' trade_type,'' project,'' asset,'' bus_type  from address_label_ugc_${tableSuffix};

DROP TABLE IF EXISTS address_labels_json_gin CASCADE;
CREATE TABLE address_labels_json_gin
(
    address TEXT  NOT NULL,
    data    JSONB NOT NULL
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY (address);

INSERT INTO address_labels_json_gin(address, data)
SELECT address_label_gp.address,
       JSONB_BUILD_OBJECT(

               'address', address_label_gp.address,
               'address_type', CASE WHEN COUNT(contract_address) > 0 THEN 'c' ELSE 'p' END,
               'labels', JSONB_AGG(
                       JSONB_BUILD_OBJECT(
                               'type', label_type,
                               'name', label_name,
                               'wired_type', wired_type,
                               'data', data :: TEXT,
                               'group', "group",
                               'level', level,
                               'category', category,
                               'trade_type', trade_type,
                               'project', project,
                               'asset', asset
                           )
                           ORDER BY label_type DESC
                   ),
               'updated_at', CURRENT_TIMESTAMP
           )
FROM address_label_gp
         LEFT JOIN contract ON (address_label_gp.address = contract.contract_address)
GROUP BY (address_label_gp.address);
insert into tag_result(table_name,batch_date)  SELECT 'address_labels_json_gin_${tableSuffix}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
delete from  tag_result where  table_name='tagging';




