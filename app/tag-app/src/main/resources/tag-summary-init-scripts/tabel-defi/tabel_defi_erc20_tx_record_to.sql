drop table if exists erc20_tx_record_to;
CREATE TABLE public.erc20_tx_record_to(
                                            address varchar(256) NULL,
                                            "token" varchar(256) NULL,
                                            block_height bigint NULL,
                                            total_transfer_volume numeric(125, 30) NULL,
                                            total_transfer_count bigint NULL,
                                            created_at timestamp NULL,
                                            recent_time_code varchar(30) NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,"token",recent_time_code);
truncate table erc20_tx_record_to;
vacuum erc20_tx_record_to;
insert into tag_result(table_name,batch_date)  SELECT 'tabel_defi_erc20_tx_record_to' as table_name,'${batchDate}'  as batch_date;
