DROP TABLE if EXISTS public.nft_buy_sell_holding_temp;
DROP TABLE if EXISTS public.token_holding_temp;
DROP TABLE if EXISTS public.eth_holding_temp;
DROP TABLE if EXISTS public.nft_holding_time_temp;
DROP TABLE if EXISTS public.eth_holding_time_temp;
DROP TABLE if EXISTS public.token_holding_time_temp;
DROP TABLE if EXISTS public.white_list_lp_temp;
DROP TABLE if EXISTS public.white_list_price_temp;
DROP TABLE if EXISTS public.top_token_1000_temp;

create table top_token_1000_temp as select * from top_token_1000_temp_cdc;
create table token_holding_temp as select * from token_holding_cdc;
create table eth_holding_temp as select * from eth_holding_cdc;

create table nft_holding_time_temp as select * from nft_holding_time_cdc;
create table eth_holding_time_temp as select * from eth_holding_time_cdc;
create table token_holding_time_temp as select * from token_holding_time_cdc;
CREATE TABLE "public"."white_list_lp_temp" (
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
create table  white_list_price_temp as select * from white_list_price_cdc;

insert into white_list_lp_temp(
"id", "chain_id", "name", "symbol", "address", "factory", "pool_id", "type", "token0", "token1", "tokens", "decimals", "price", "tvl", "total_supply", "remark", "created_at", "updated_at", "removed", "symbol_wired", "fee", "factory_type", "factory_content", "symbols"
) select
"id", "chain_id", "name", "symbol", "address", "factory", "pool_id", "type", "token0", "token1", "tokens", "decimals", "price", "tvl", "total_supply", "remark", "created_at", "updated_at", "removed", "symbol_wired", "fee", "factory_type", "factory_content", "symbols"
from white_list_lp_cdc;

insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,'${batchDate}'  as batch_date;

