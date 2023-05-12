DROP TABLE if EXISTS public.nft_buy_sell_holding;
DROP TABLE if EXISTS public.nft_holding;
DROP TABLE if EXISTS public.token_holding;
DROP TABLE if EXISTS public.eth_holding;
DROP TABLE if EXISTS public.platform_nft_holding;

create table nft_buy_sell_holding as select * from nft_buy_sell_holding_cdc;
create table nft_holding as select * from nft_holding_cdc;
create table token_holding as select * from token_holding_cdc;
create table eth_holding as select * from eth_holding_cdc;
create table platform_nft_holding as select * from platform_nft_holding_cdc;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

