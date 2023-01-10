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
                                 ,event
                                 ,first_updated_block_height
                                 ,transaction_hash
                                 ,price_token
                                 ,liquidity
                                 ,token0
                                 ,token1
                                 ,handle
                                 ,type) select address
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
                                             ,event
                                             ,first_updated_block_height
                                             ,transaction_hash
                                             ,price_token
                                             ,liquidity
                                             ,token0
                                             ,token1
                                             ,handle
                                             ,type from token_holding_uni where type='swap';

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
                                 ,type)

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
from (
         select address
              ,token
              ,sum(balance) balance
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
              ,max(type) as type from token_holding_uni where type='lp'
         group by address,token,nft_token_id,price_token ) tb1 ;