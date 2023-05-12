DROP VIEW if EXISTS public.dex_tx_volume_count_record;
DROP VIEW if EXISTS public.erc20_tx_record;
DROP VIEW if EXISTS public.eth_tx_record;
DROP VIEW if EXISTS public.token_holding_uni;
DROP VIEW if EXISTS public.web3_transaction_record;
insert into tag_result(table_name,batch_date)  SELECT 'drop_view' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

