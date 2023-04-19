drop table if exists snapshot_web3_transaction_record;

CREATE TABLE public.snapshot_web3_transaction_record (
                                                address varchar(256) NOT NULL,
                                                "token" varchar(256) NOT NULL,
                                                block_height int8 NOT NULL,
                                                total_transfer_volume numeric(125, 30) NOT NULL DEFAULT 0,
                                                total_transfer_count int8 NOT NULL DEFAULT 0,
                                                status varchar(128) NULL DEFAULT 'PENDING'::character varying,
                                                created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                removed bool NULL DEFAULT false,
                                                "event" varchar(100) NULL,
                                                first_updated_block_height int8 NOT NULL DEFAULT 99999999,
                                                transaction_hash varchar(100) NULL,
                                                "type" varchar(50) NULL,
                                                project varchar(100) NULL,
                                                balance numeric(125, 30) NOT NULL DEFAULT 0,
                                                nft_token_id varchar(256) NULL
)distributed by (address, token);
truncate table snapshot_web3_transaction_record;
vacuum snapshot_web3_transaction_record;
insert into snapshot_web3_transaction_record
select * from web3_transaction_record;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

