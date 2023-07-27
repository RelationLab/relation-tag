-- DROP TABLE public.token_holding_uni_filter;
DROP TABLE IF EXISTS public.token_holding_uni_filter;
CREATE TABLE public.token_holding_uni_filter (
                                              address varchar(256) NULL,
                                              "token" varchar(256) NULL,
                                              balance numeric(125, 30) NULL,
                                              block_height int8 NULL,
                                              total_transfer_volume numeric(125, 30) NULL,
                                              total_transfer_count int8 NULL,
                                              created_at timestamp NULL,
                                              updated_at timestamp NULL,
                                              nft_token_id varchar(150) NULL,
                                              first_updated_block_height int8 NULL,
                                              transaction_hash varchar(100) NULL,
                                              price_token varchar(150) NULL,
                                              liquidity numeric(125, 30) NULL,
                                              "type" varchar(30) NULL,
                                              triggered_flag varchar(1) NULL
) DISTRIBUTED BY (address,"token");
truncate table token_holding_uni_filter;
vacuum token_holding_uni_filter;

insert into token_holding_uni_filter(address
                                 ,token
                                 ,balance
                                 ,block_height
                                 ,total_transfer_volume
                                 ,total_transfer_count
                                 ,nft_token_id
                                 ,first_updated_block_height
                                 ,price_token
                                 ,liquidity
                                 ,type,triggered_flag)

select
    address
     ,token
     ,case  when liquidity<=0 THEN 0 ELSE balance end balance
     ,block_height
     ,total_transfer_volume
     ,total_transfer_count
     ,nft_token_id
     ,first_updated_block_height
     ,price_token
     ,liquidity
     ,type
     ,triggered_flag
from (
         select token_holding_uni.address
              ,token_holding_uni.token
              ,sum(case when (token_holding_uni.type!='lp'  or token_holding_uni.nft_token_id='-1') then 0 else round(token_holding_uni.balance * round(cast(w.price as numeric), 18),8) end ) balance
              ,max(token_holding_uni.block_height) block_height
              ,sum(round(token_holding_uni.total_transfer_volume * round(cast(w.price as numeric), 18),8)) total_transfer_volume
              ,sum(token_holding_uni.total_transfer_count) total_transfer_count
              ,token_holding_uni.nft_token_id
              ,min(token_holding_uni.first_updated_block_height) first_updated_block_height
              ,token_holding_uni.price_token
              ,sum(liquidity) liquidity
              ,max(token_holding_uni.type) as type
              ,max(token_holding_uni.triggered_flag) as triggered_flag from token_holding_uni
                                                                       inner join (
             select
                 white_list_erc20.*
             from
                 white_list_erc20
                     INNER JOIN (select address from top_token_1000 tt2  where tt2.holders>=100 and removed<>true)
                     top_token_1000 ON (white_list_erc20.address = top_token_1000.address)) w on
             (w.address = token_holding_uni.price_token)
         group by token_holding_uni.address,token_holding_uni.token,token_holding_uni.nft_token_id,token_holding_uni.price_token ) tb1 ;
insert into tag_result(table_name,batch_date)  SELECT 'filter_token_holding_uni_filter' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

