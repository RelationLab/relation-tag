DROP TABLE if EXISTS public.nft_buy_sell_holding;
DROP TABLE if EXISTS public.nft_holding;
DROP TABLE if EXISTS public.token_holding;
DROP TABLE if EXISTS public.eth_holding;
DROP TABLE if EXISTS public.platform_nft_holding;
DROP TABLE if EXISTS public.nft_holding_time;
DROP TABLE if EXISTS public.eth_holding_time;
DROP TABLE if EXISTS public.token_holding_time;
DROP TABLE if EXISTS public.white_list_lp;
DROP TABLE if EXISTS public.white_list_price;

CREATE TABLE public.platform_nft_holding (
                                             id bigserial NOT NULL,
                                             address varchar(512) NOT NULL,
                                             platform varchar(512) NOT NULL,
                                             quote_token varchar(512) NOT NULL,
                                             "token" varchar(512) NOT NULL,
                                             total_transfer_volume numeric(128, 30) NULL,
                                             total_transfer_count int8 NULL,
                                             total_transfer_to_volume numeric(128, 30) NULL,
                                             total_transfer_to_count int8 NULL,
                                             total_transfer_all_volume numeric(128, 30) NULL,
                                             total_transfer_all_count int8 NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT false,
                                             weth_token_flag varchar(1) NULL,
                                             platform_group varchar(256) NULL
);

create table nft_buy_sell_holding as select * from nft_buy_sell_holding_cdc;
create table nft_holding as select * from nft_holding_cdc;
create table token_holding as select * from token_holding_cdc;
create table eth_holding as select * from eth_holding_cdc;

insert into platform_nft_holding(id, address, platform, quote_token, "token", total_transfer_volume, total_transfer_count, total_transfer_to_volume, total_transfer_to_count, total_transfer_all_volume, total_transfer_all_count, created_at, updated_at, removed, platform_group)
    SELECT id, address, platform, quote_token, "token", total_transfer_volume, total_transfer_count, total_transfer_to_volume, total_transfer_to_count, total_transfer_all_volume, total_transfer_all_count, created_at, updated_at, removed, platform_group
  FROM platform_nft_holding_cdc;

create table nft_holding_time as select * from nft_holding_time_cdc;
create table eth_holding_time as select * from eth_holding_time_cdc;
create table token_holding_time as select * from token_holding_time_cdc;
-- create table  white_list_lp as select * from white_list_lp_cdc;
CREATE TABLE "public"."white_list_lp" (
  "id" int8 NOT NULL,
  "chain_id" int4,
  "name" varchar(100) COLLATE "pg_catalog"."default",
  "symbol" varchar(100) COLLATE "pg_catalog"."default",
  "address" varchar(42) COLLATE "pg_catalog"."default" NOT NULL,
  "factory" varchar(42) COLLATE "pg_catalog"."default",
  "pool_id" varchar(100) COLLATE "pg_catalog"."default",
  "type" varchar(20) COLLATE "pg_catalog"."default",
  "token0" varchar(42) COLLATE "pg_catalog"."default",
  "token1" varchar(42) COLLATE "pg_catalog"."default",
  "tokens" varchar[] COLLATE "pg_catalog"."default",
  "decimals" int2,
  "price" numeric(125,18),
  "tvl" numeric(125,18),
  "total_supply" numeric(125,18),
  "remark" varchar(2000) COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "removed" bool,
  "symbol_wired" varchar(100) COLLATE "pg_catalog"."default",
  "fee" numeric(125,8),
  "factory_type" varchar(100) COLLATE "pg_catalog"."default",
  "factory_content" varchar(255) COLLATE "pg_catalog"."default",
  "symbols" varchar[] COLLATE "pg_catalog"."default"
);
create table  white_list_price as select * from white_list_price_cdc;

insert into white_list_lp(
"id", "chain_id", "name", "symbol", "address", "factory", "pool_id", "type", "token0", "token1", "tokens", "decimals", "price", "tvl", "total_supply", "remark", "created_at", "updated_at", "removed", "symbol_wired", "fee", "factory_type", "factory_content", "symbols"
) select
"id", "chain_id", "name", "symbol", "address", "factory", "pool_id", "type", "token0", "token1", "tokens", "decimals", "price", "tvl", "total_supply", "remark", "created_at", "updated_at", "removed", "symbol_wired", "fee", "factory_type", "factory_content", "symbols"
from white_list_lp_cdc;

update platform_nft_holding set quote_token='0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2',weth_token_flag='1' where quote_token='0x0000000000a39bb272e79075ade125fd351887ac';

insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

