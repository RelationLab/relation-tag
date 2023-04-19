drop table if exists snapshot_block_timestamp;
CREATE TABLE public.snapshot_block_timestamp (
                                        height int8 NULL,
                                        "timestamp" int8 NULL,
                                        created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                        updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                        removed bool NULL DEFAULT false
)distributed by (height);
truncate table snapshot_block_timestamp;
vacuum snapshot_block_timestamp;

insert into snapshot_block_timestamp(height,"timestamp",created_at,updated_at,removed)
select  height,"timestamp",created_at,updated_at,removed from block_timestamp;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

