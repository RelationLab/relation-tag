-- public.dms_syn_block definition

-- Drop table

-- DROP TABLE public.dms_syn_block;
DROP TABLE IF EXISTS public.dms_syn_block;
CREATE TABLE public.dms_syn_block (
                                      syn_type varchar(20) NOT NULL,
                                      block_height int8 NULL
);
truncate table dms_syn_block;
vacuum dms_syn_block;

insert into dms_syn_block(syn_type,block_height)
select 'eth_tx_record' as syn_type,max(block_number) from eth_tx_record;

insert into dms_syn_block(syn_type,block_height)
select 'erc20_tx_record' as syn_type,max(block_number) from erc20_tx_record;
