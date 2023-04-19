-- public.dms_syn_block definition

-- Drop table

-- DROP TABLE public.dms_syn_block;
DROP TABLE IF EXISTS public.dms_syn_block;
CREATE TABLE public.dms_syn_block (
                                      syn_type varchar(100) NOT NULL,
                                      block_height int8 NULL
);
truncate table dms_syn_block;
vacuum dms_syn_block;

insert into dms_syn_block(syn_type,block_height)
select 'eth_tx_record' as syn_type,max(block_height) from eth_holding_vol_count;

insert into dms_syn_block(syn_type,block_height)
select 'erc20_tx_record' as syn_type,max(block_height) from token_holding_vol_count;
insert into tag_result(table_name,batch_date)  SELECT 'dms_syn_block' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

