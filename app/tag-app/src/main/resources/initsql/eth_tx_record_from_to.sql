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
) distributed by (address);
truncate table eth_tx_record_from_to;
vacuum eth_tx_record_from_to;