-- DROP TABLE public.token_holding_uni_cal;
DROP TABLE IF EXISTS public.token_holding_uni_cal;
CREATE TABLE public.token_holding_uni_cal (
                                              address varchar(256) NULL,
                                              "token" varchar(256) NULL,
                                              balance numeric(125, 30) NULL,
                                              block_height int8 NULL,
                                              total_transfer_volume numeric(125, 30) NULL,
                                              total_transfer_count int8 NULL,
                                              status varchar(128) NULL,
                                              created_at timestamp NULL,
                                              updated_at timestamp NULL,
                                              removed bool NULL,
                                              fail_count int4 NULL,
                                              error_code int4 NULL,
                                              error_message text NULL,
                                              node_name varchar(512) NULL,
                                              nft_token_id varchar(150) NULL,
                                              in_transfer_volume numeric(125, 30) NULL,
                                              out_transfer_volume numeric(125, 30) NULL,
                                              in_transfer_count int8 NULL,
                                              out_transfer_count int8 NULL,
                                              "event" varchar(10) NULL,
                                              first_updated_block_height int8 NULL,
                                              transaction_hash varchar(100) NULL,
                                              price_token varchar(150) NULL,
                                              liquidity numeric(125, 30) NULL,
                                              token0 varchar(150) NULL,
                                              token1 varchar(150) NULL,
                                              handle bool NULL,
                                              "type" varchar(30) NULL,
                                              triggered_flag varchar(1) NULL
);
truncate table token_holding_uni_cal;
vacuum token_holding_uni_cal;

insert into token_holding_uni_cal(address
                                 ,token
                                 ,balance
                                 ,block_height
                                 ,total_transfer_volume
                                 ,total_transfer_count
                                 ,nft_token_id
                                 ,in_transfer_volume
                                 ,out_transfer_volume
                                 ,in_transfer_count
                                 ,out_transfer_count
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
     ,in_transfer_volume
     ,out_transfer_volume
     ,in_transfer_count
     ,out_transfer_count
     ,first_updated_block_height
     ,price_token
     ,liquidity
     ,type
     ,triggered_flag
from (
         select address
              ,token
              ,sum(case when (type!='lp'  or nft_token_id='-1') then 0 else balance end ) balance
              ,max(block_height) block_height
              ,sum(total_transfer_volume) total_transfer_volume
              ,sum(total_transfer_count) total_transfer_count
              ,nft_token_id
              ,sum(in_transfer_volume) in_transfer_volume
              ,sum(out_transfer_volume) out_transfer_volume
              ,sum(in_transfer_count) in_transfer_count
              ,sum(out_transfer_count) out_transfer_count
              ,max(first_updated_block_height) first_updated_block_height
              ,price_token
              ,sum(liquidity) liquidity
              ,max(type) as type
              ,max(triggered_flag) as triggered_flag from token_holding_uni
         group by address,token,nft_token_id,price_token ) tb1 ;
insert into tag_result(table_name,batch_date)  SELECT 'token_holding_uni_cal' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

