DROP TABLE IF EXISTS public.web3_transaction_record_summary;
CREATE TABLE  public.web3_transaction_record_summary
(
    address character varying(256) COLLATE pg_catalog."default" NOT NULL,
    total_transfer_volume numeric(125,30) NOT NULL DEFAULT 0,
    total_transfer_count bigint NOT NULL DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    removed boolean DEFAULT false,
    type character varying(50) COLLATE pg_catalog."default",
    project character varying(100) COLLATE pg_catalog."default",
    balance numeric(125,30) NOT NULL DEFAULT 0
);
truncate table web3_transaction_record_summary;
vacuum web3_transaction_record_summary;
update web3_transaction_record_cdc set address = lower(address) where type='write';
    insert
    into
        web3_transaction_record_summary(address,
                                        total_transfer_volume,
                                        total_transfer_count,
                                        type,
                                        project,
                                        balance)
    select
        lower(address) as address,
        sum(total_transfer_volume) as total_transfer_volume ,
        sum(total_transfer_count) as total_transfer_count ,
        type ,
        project,
        sum(balance) as balance
    from
        web3_transaction_record
    group by
        address,
        type ,
        project;

update web3_transaction_record_summary set type ='mint' where type='Mint';
insert into tag_result(table_name,batch_date)  SELECT 'web3_transaction_record_summary' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

