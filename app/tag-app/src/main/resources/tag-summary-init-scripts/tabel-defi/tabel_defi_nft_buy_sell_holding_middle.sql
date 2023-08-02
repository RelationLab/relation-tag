-- public.nft_buy_sell_holding_middle definition

-- Drop table

-- DROP TABLE public.nft_buy_sell_holding_middle;
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
                                             recent_time_code varchar(30) NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,"token",recent_time_code);
truncate table nft_buy_sell_holding_middle;
vacuum nft_buy_sell_holding_middle;
insert into tag_result(table_name,batch_date)  SELECT 'tabel_defi_nft_buy_sell_holding_middle' as table_name,'${batchDate}'  as batch_date;


