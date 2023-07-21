DROP TABLE IF EXISTS public.dms_syn_block;
CREATE TABLE public.dms_syn_block (
                                      syn_type varchar(100) NOT NULL,
                                      block_height int8 NULL
);
truncate table dms_syn_block;
vacuum dms_syn_block;
insert into dms_syn_block(syn_type,block_height)
select 'dex_tx_volume_count_record' as syn_type,max(block_height)-2000 from dex_tx_volume_count_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'erc20_tx_record' as syn_type, max(block_number)-2000  from erc20_tx_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'eth_tx_record' as syn_type, max(block_number)-2000  from eth_tx_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'token_holding_uni' as syn_type, max(block_height)-2000    from token_holding_uni_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'web3_transaction_record' as syn_type, max(block_height)-2000    from web3_transaction_record_cdc;

insert into dms_syn_block(syn_type,block_height)
select 'nft_holding_record' as syn_type, max(block_height)-2000    from nft_holding_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'erc721_tx_record' as syn_type, max(block_height)-2000    from erc721_tx_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'platform_nft_tx_record' as syn_type, max(block_height)-2000    from platform_nft_tx_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'platform_bid_tx_record' as syn_type, max(block_height)-2000    from platform_bid_tx_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'platform_deposit_withdraw_tx_record' as syn_type, max(block_height)-2000    from platform_deposit_withdraw_tx_record_cdc;
insert into dms_syn_block(syn_type,block_height)
select 'platform_lend_tx_record' as syn_type, max(block_height)-2000    from platform_lend_tx_record_cdc;

insert into tag_result(table_name,batch_date)  SELECT 'dms_syn_block' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

