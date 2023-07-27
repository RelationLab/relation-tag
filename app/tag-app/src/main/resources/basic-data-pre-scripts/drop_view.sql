DROP VIEW if EXISTS public.dex_tx_volume_count_record;
DROP VIEW if EXISTS public.erc20_tx_record;
DROP VIEW if EXISTS public.eth_tx_record;
DROP VIEW if EXISTS public.token_holding_uni;
DROP VIEW if EXISTS public.web3_transaction_record;

DROP VIEW if EXISTS public.nft_holding_record;
DROP VIEW if EXISTS public.erc721_tx_record;
DROP VIEW if EXISTS public.platform_nft_tx_record;

DROP VIEW if EXISTS public.platform_bid_tx_record;
DROP VIEW if EXISTS public.platform_deposit_withdraw_tx_record;
DROP VIEW if EXISTS public.platform_lend_tx_record;

insert into tag_result(table_name,batch_date)  SELECT 'drop_view' as table_name,'${batchDate}'  as batch_date;
insert into tag_result(table_name,batch_date)  SELECT 'tagging' as table_name,'${batchDate}'  as batch_date;

