DROP TABLE IF EXISTS public.snapshot_dms_syn_block;
CREATE TABLE public.snapshot_dms_syn_block (
                                      syn_type varchar(100) NOT NULL,
                                      block_height int8 NULL
);
truncate table snapshot_dms_syn_block;
vacuum snapshot_dms_syn_block;
insert into snapshot_dms_syn_block select * from dms_syn_block;
insert into tag_result(table_name,batch_date)  SELECT 'table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
