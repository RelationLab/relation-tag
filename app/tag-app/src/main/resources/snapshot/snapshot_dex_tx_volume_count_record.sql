-- public.dex_tx_volume_count_record definition

-- Drop table

-- DROP TABLE public.dex_tx_volume_count_record;
drop table if exists snapshot_dex_tx_volume_count_record;
CREATE TABLE public.snapshot_dex_tx_volume_count_record (
                                                            address varchar(256) NOT NULL,
                                                            "token" varchar(256) NOT NULL,
                                                            block_height int8 NOT NULL,
                                                            total_transfer_volume numeric(125, 30) NOT NULL DEFAULT 0,
                                                            total_transfer_count int8 NOT NULL DEFAULT 0,
                                                            status varchar(128) NULL DEFAULT 'PENDING'::character varying,
                                                            created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                            updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                            removed bool NULL DEFAULT false,
                                                            "event" varchar(10) NULL,
                                                            first_updated_block_height int8 NOT NULL DEFAULT 99999999,
                                                            transaction_hash varchar(100) NULL,
                                                            router varchar(150) NULL,
                                                            "type" varchar(10) NULL,
                                                            project varchar(100) NULL,
                                                            in_transfer_volume numeric(125, 30) NULL,
                                                            out_transfer_volume numeric(125, 30) NULL,
                                                            in_transfer_count int8 NULL,
                                                            out_transfer_count int8 NULL,
                                                            balance numeric(125, 30) NOT NULL DEFAULT 0
) distributed by (address,project,token);
truncate table snapshot_dex_tx_volume_count_record;
vacuum snapshot_dex_tx_volume_count_record;
CREATE INDEX snapshot_dex_tx_volume_count_record_address_idx ON public.snapshot_dex_tx_volume_count_record USING btree (address);
CREATE INDEX snapshot_dex_tx_volume_count_record_project_idx ON public.snapshot_dex_tx_volume_count_record USING btree (project);
CREATE INDEX snapshot_dex_tx_volume_count_record_token_idx ON public.snapshot_dex_tx_volume_count_record USING btree (token);
insert into snapshot_dex_tx_volume_count_record select * from  dex_tx_volume_count_record;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
