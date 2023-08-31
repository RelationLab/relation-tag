    DROP VIEW if EXISTS public.address_info;
    CREATE VIEW address_info AS  select * from  address_info_cdc;
    DROP VIEW if EXISTS public.block_timestamp;
    CREATE VIEW block_timestamp AS  select * from  block_timestamp_cdc;
    DROP VIEW if EXISTS public.nft_sync_buy_sell_address;
    CREATE VIEW nft_sync_buy_sell_address AS  select * from  nft_sync_buy_sell_address_cdc;
    DROP VIEW if EXISTS public.nft_time_sync_address;
    CREATE VIEW nft_time_sync_address AS  select * from  nft_time_sync_address_cdc;
    DROP VIEW if EXISTS public.platform_nft_sync_address_temp;
    CREATE VIEW platform_nft_sync_address_temp AS  select * from  platform_nft_sync_address_cdc;
    DROP VIEW if EXISTS public.total_nft_tx_count;
    CREATE VIEW total_nft_tx_count AS  select * from  total_nft_tx_count_cdc;
    DROP VIEW if EXISTS public.total_tx_count;
    CREATE VIEW total_tx_count AS  select * from  total_tx_count_cdc;
    DROP VIEW if EXISTS public.contract;
    CREATE VIEW contract AS  select * from  contract_cdc;


    DROP VIEW if EXISTS public.dex_tx_volume_count_record;
    CREATE VIEW dex_tx_volume_count_record AS select * from dex_tx_volume_count_record_cdc
    where block_height<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.erc20_tx_record;
    CREATE VIEW erc20_tx_record AS select * from erc20_tx_record_cdc
    where block_number<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.eth_tx_record;
    CREATE VIEW eth_tx_record AS select * from eth_tx_record_cdc
    where block_number<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.token_holding_uni;
    CREATE VIEW token_holding_uni AS select * from token_holding_uni_cdc
    where block_height<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.web3_transaction_record;
    CREATE VIEW web3_transaction_record AS select * from web3_transaction_record_cdc
    where block_height<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.nft_holding_record;
    CREATE VIEW nft_holding_record AS select * from nft_holding_record_cdc
    where updated_block_height<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.erc721_tx_record;
    CREATE VIEW erc721_tx_record AS select * from erc721_tx_record_cdc
    where block_number<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.platform_nft_tx_record;
    CREATE VIEW platform_nft_tx_record AS select * from platform_nft_tx_record_cdc
    where block_number<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.platform_bid_tx_record;
    CREATE VIEW platform_bid_tx_record AS select * from platform_bid_tx_record_cdc
    where block_number<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.platform_deposit_withdraw_tx_record;
    CREATE VIEW platform_deposit_withdraw_tx_record AS select * from platform_deposit_withdraw_tx_record_cdc
    where block_number<=(select min(block_height) from dms_syn_block);

    DROP VIEW if EXISTS public.platform_lend_tx_record;
    CREATE VIEW platform_lend_tx_record AS select * from platform_lend_tx_record_cdc
    where block_number<=(select min(block_height) from dms_syn_block);

    insert into tag_result(table_name,batch_date)  SELECT 'create_view' as table_name,'${batchDate}'  as batch_date;


