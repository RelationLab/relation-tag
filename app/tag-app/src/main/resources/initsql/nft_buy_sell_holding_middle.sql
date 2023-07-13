-- public.nft_buy_sell_holding definition

-- Drop table

-- DROP TABLE public.nft_buy_sell_holding;
drop table if exists nft_buy_sell_holding_middle;

CREATE TABLE public.nft_buy_sell_holding_middle (
                                             address varchar(512) NOT NULL,
                                             "token" varchar(512) NOT NULL,
                                             total_transfer_buy_volume int8 NOT NULL,
                                             total_transfer_buy_count int8 NULL,
                                             total_transfer_sell_volume int8 NOT NULL,
                                             total_transfer_sell_count int8 NULL,
                                             updated_block_height int8 NOT NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT false
) distributed by (address,"token");
truncate table nft_buy_sell_holding_middle;
vacuum nft_buy_sell_holding_middle;

insert into nft_buy_sell_holding_middle (address, token, total_transfer_buy_volume, total_transfer_buy_count,
                                  total_transfer_sell_volume, total_transfer_sell_count, updated_block_height)
    (select from_address, token, 0, 0, sum(count), sum(value), max(block_number)
     from (select from_address, token, 0, 0, 1 as count, sum(1) as value, max(block_number) as block_number
           from platform_nft_tx_record
           group by from_address, token,hash
           ) platform_nft_tx_record
     group by from_address, token);

insert into nft_buy_sell_holding (address, token, total_transfer_buy_volume, total_transfer_buy_count,
                                  total_transfer_sell_volume, total_transfer_sell_count, updated_block_height)
    (select to_address, token, sum(count), sum(value), 0, 0, max(block_number)
     from (select
               to_address,
               token,
               1 as count,
	            sum(1) as value,
	0,
	0,
	max(block_number) as block_number
           from
               platform_nft_tx_record
           group by
               to_address,
               token,hash) platform_nft_tx_record
     group by to_address, token);
insert into tag_result(table_name,batch_date)  SELECT 'nft_buy_sell_holding_middle' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;


