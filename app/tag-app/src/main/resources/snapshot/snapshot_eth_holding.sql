drop table if exists snapshot_eth_holding;
CREATE TABLE public.snapshot_eth_holding (
                                    address varchar(256) NOT NULL,
                                    balance numeric(125, 30) NOT NULL DEFAULT 0,
                                    total_transfer_count int8 NOT NULL DEFAULT 0,
                                    block_height int8 NOT NULL,
                                    total_transfer_volume numeric(120, 30) NOT NULL DEFAULT 0,
                                    status varchar(128) NULL DEFAULT 'PENDING'::character varying,
                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    removed bool NULL DEFAULT false,
                                    fail_count int4 NULL DEFAULT 0,
                                    error_code int4 NULL DEFAULT 0,
                                    error_message text NULL,
                                    node_name varchar(512) NULL,
                                    total_transfer_to_count int8 NULL DEFAULT 0,
                                    total_transfer_all_count int8 NULL DEFAULT 0,
                                    total_transfer_to_volume numeric(120, 30) NULL DEFAULT 0,
                                    total_transfer_all_volume numeric(120, 30) NULL DEFAULT 0
) distributed by (address);
truncate table snapshot_eth_holding;
vacuum snapshot_eth_holding;

insert into snapshot_eth_holding(address ,
                        balance ,
                        total_transfer_count,
                        block_height,
                        total_transfer_volume,
                        status,
                        created_at ,
                        updated_at ,
                        removed ,
                        fail_count,
                        error_code,
                        error_message ,
                        node_name ,
                        total_transfer_to_count ,
                        total_transfer_all_count ,
                        total_transfer_to_volume ,
                        total_transfer_all_volume )
select address ,
       balance ,
       total_transfer_count,
       block_height,
       total_transfer_volume,
       status,
       created_at ,
       updated_at ,
       removed ,
       fail_count,
       error_code,
       error_message ,
       node_name ,
       total_transfer_to_count ,
       total_transfer_all_count ,
       total_transfer_to_volume ,
       total_transfer_all_volume from eth_holding;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

