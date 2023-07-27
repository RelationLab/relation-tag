drop table if exists erc20_tx_record_from;
CREATE TABLE public.erc20_tx_record_from(
                                                 address varchar(256) NULL,
                                                 "token" varchar(256) NULL,
                                                 block_height bigint NULL,
                                                 total_transfer_volume numeric(125, 30) NULL,
                                                 total_transfer_count bigint NULL,
                                                 created_at timestamp NULL,
                                                 recent_time_code varchar(30) NULL
) distributed by (address,"token",recent_time_code);
truncate table erc20_tx_record_from;
vacuum erc20_tx_record_from;
insert into tag_result(table_name,batch_date)  SELECT 'tabel_defi_erc20_tx_record_from' as table_name,'${batchDate}'  as batch_date;

