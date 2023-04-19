drop table if exists snapshot_address_info;
CREATE TABLE public.snapshot_address_info (
                                              address varchar(512) NOT NULL,
                                              first_up_chain_timestamp int8 NULL,
                                              first_up_chain_block_height int8 NULL,
                                              first_up_chain_tx_hash int8 NULL,
                                              days int8 NULL,
                                              CONSTRAINT address_info_pk PRIMARY KEY (address)
)distributed by (address);
truncate table snapshot_address_info;
vacuum snapshot_address_info;

insert into snapshot_address_info select * from  address_info;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
