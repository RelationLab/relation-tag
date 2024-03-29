drop table if exists eth_tx_record_from_to;
CREATE TABLE public.eth_tx_record_from_to (
                                              address varchar(256) NULL,
                                              balance numeric(125, 30) NULL,
                                              total_transfer_count int8 NULL,
                                              block_height int8 NULL,
                                              total_transfer_volume numeric(120, 30) NULL,
                                              recent_time_code varchar(30) NULL,
                                              created_at timestamp NULL,
                                              updated_at timestamp NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,recent_time_code);
truncate table eth_tx_record_from_to;
vacuum eth_tx_record_from_to;
insert into tag_result(table_name,batch_date)  SELECT 'tabel_defi_eth_tx_record_from_to' as table_name,'${batchDate}'  as batch_date;
