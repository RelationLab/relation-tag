-- public.nft_holding definition

-- Drop table

-- DROP TABLE public.nft_holding;
drop table if exists nft_holding;
CREATE TABLE public.nft_holding (
                                    address varchar(512) NOT NULL,
                                    "token" varchar(512) NOT NULL,
                                    balance int8 NOT NULL,
                                    total_transfer_volume int8 NOT NULL,
                                    total_transfer_count int8 NULL,
                                    total_transfer_to_volume int8 NOT NULL,
                                    total_transfer_to_count int8 NULL,
                                    total_transfer_mint_volume int8 NOT NULL,
                                    total_transfer_mint_count int8 NULL,
                                    total_transfer_burn_volume int8 NOT NULL,
                                    total_transfer_burn_count int8 NULL,
                                    total_transfer_all_volume int8 NOT NULL,
                                    total_transfer_all_count int8 NULL,
                                    updated_block_height int8 NOT NULL,
                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    removed bool NULL DEFAULT false
)distributed by (address,"token");
truncate table nft_holding;
vacuum nft_holding;

insert
into nft_holding (address,
                  token,
                  balance,
                  total_transfer_volume,
                  total_transfer_count,
                  total_transfer_to_volume,
                  total_transfer_to_count,
                  total_transfer_mint_volume,
                  total_transfer_mint_count,
                  total_transfer_burn_volume,
                  total_transfer_burn_count,
                  total_transfer_all_volume,
                  total_transfer_all_count,
                  updated_block_height)
select address,
       token,
       sum(balance)                    balance,
       sum(total_transfer_volume)      total_transfer_volume,
       sum(total_transfer_count)       total_transfer_count,
       sum(total_transfer_to_volume)   total_transfer_to_volume,
       sum(total_transfer_to_count)    total_transfer_to_count,
       sum(total_transfer_mint_volume) total_transfer_mint_volume,
       sum(total_transfer_mint_count)  total_transfer_mint_count,
       sum(total_transfer_burn_volume) total_transfer_burn_volume,
       sum(total_transfer_burn_count)  total_transfer_burn_count,
       sum(total_transfer_volume + total_transfer_to_volume + total_transfer_mint_volume +
           total_transfer_burn_volume) total_transfer_all_volume,
       sum(total_transfer_count + total_transfer_to_count + total_transfer_mint_count + total_transfer_burn_count)       total_transfer_all_count,
       max(updated_block_height)       updated_block_height
from (
         select address,
                case
                    when token = '0x6ba6f2207e343923ba692e5cae646fb0f566db8d'
                        then '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb'
                    else token
                    end as                      token,
                sum(balance)                    balance,
                sum(total_transfer_volume)      total_transfer_volume,
                sum(total_transfer_count)       total_transfer_count,
                sum(total_transfer_to_volume)   total_transfer_to_volume,
                sum(total_transfer_to_count)    total_transfer_to_count,
                sum(total_transfer_mint_volume) total_transfer_mint_volume,
                sum(total_transfer_mint_count)  total_transfer_mint_count,
                sum(total_transfer_burn_volume) total_transfer_burn_volume,
                sum(total_transfer_burn_count)  total_transfer_burn_count,
                max(updated_block_height)       updated_block_height
         from nft_holding_record
         group by address, token, transaction_hash, nft_token_id) t
group by address,
         token;


insert into nft_holding(address, token, balance, total_transfer_volume, total_transfer_count,
                        total_transfer_to_volume,
                        total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                        total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                        total_transfer_all_count, updated_block_height)

select from_address,
       token,
       sum(balance),
       sum(total_transfer_volume),
       sum(total_transfer_count),
       sum(total_transfer_to_volume),
       sum(total_transfer_to_count),
       sum(total_transfer_mint_volume),
       sum(total_transfer_mint_count),
       sum(total_transfer_burn_volume),
       sum(total_transfer_burn_count),
       sum(total_transfer_all_volume),
       sum(total_transfer_all_count),
       max(block_number)
from nft_holding_temp
group by address, token;
insert into tag_result(table_name,batch_date)  SELECT 'nft_holding' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
