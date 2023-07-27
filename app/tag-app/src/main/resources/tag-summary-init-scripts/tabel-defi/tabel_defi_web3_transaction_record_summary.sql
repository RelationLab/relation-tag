DROP TABLE IF EXISTS public.web3_transaction_record_summary;
CREATE TABLE  public.web3_transaction_record_summary
(
    address character varying(256) COLLATE pg_catalog."default" NOT NULL,
    total_transfer_volume numeric(125,30) NOT NULL DEFAULT 0,
    total_transfer_count bigint NOT NULL DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type character varying(50) COLLATE pg_catalog."default",
    project character varying(100) COLLATE pg_catalog."default",
    balance numeric(125,30) NOT NULL DEFAULT 0,
    recent_time_code varchar(30) NULL
)distributed by (address, project, recent_time_code);
truncate table web3_transaction_record_summary;
vacuum web3_transaction_record_summary;
update web3_transaction_record_cdc set address = lower(address),token=lower(token) where type='write';
insert into tag_result(table_name,batch_date)  SELECT 'tabel_defi_web3_transaction_record_summary' as table_name,'${batchDate}'  as batch_date;

