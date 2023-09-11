drop table if exists dex_tx_volume_count_summary_stake_temp;
CREATE TABLE public.dex_tx_volume_count_summary_stake_temp (
                                                    address varchar(256) NOT NULL,
                                                    "token" varchar(256) NOT NULL,
                                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    first_updated_block_height int8 NOT NULL DEFAULT 99999999,
                                                    "type" varchar(10) NULL,
                                                    project varchar(100) NULL,
                                                    balance_usd numeric(125, 30) DEFAULT 0
) with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address);
truncate table dex_tx_volume_count_summary_stake_temp;
vacuum dex_tx_volume_count_summary_stake_temp;

insert
into
    dex_tx_volume_count_summary_stake_temp(address,
                                token,
                                type,
                                project,
                                first_updated_block_height,
                                balance_usd)
select
    dtvcr.address,
    token,
    dtvcr.type,
    project,
    min(first_updated_block_height) first_updated_block_height,
    sum(round(balance * round(cast (w.price as numeric), 18),8)) as balance_usd
from
    dex_tx_volume_count_record  dtvcr
        inner join (
        select
            white_list_erc20_temp.*
        from
            white_list_erc20_temp   INNER JOIN (select wlp.id,
                                                       wlp.name,
                                                       wlp.symbol_wired,
                                                       wlp.address               as pool,
                                                       wlp.factory,
                                                       wlp.factory_type,
                                                       wlp.factory_content,
                                                       wlp.pool_id,
                                                       wlp.symbols[1]            as symbol1,
                                                       wlp.symbols[2]            as symbol2,
                                                       wlp.type,
                                                       wlp.tokens,
                                                       wlp.decimals,
                                                       wlp.price,
                                                       wlp.tvl,
                                                       wlp.fee                   as fee,
                                                       SUBSTR(wlp.address, 1, 6) as poolPrefix,
                                                       wlp.total_supply,
                                                       wslp.factory              AS stakePool,
                                                       wslp.factory_type         as stakeRouter
                                                from white_list_lp_temp wlp
                                                         left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
                                                where wlp.tvl > 1000000
                                                  and wlp.symbols <@ ARRAY(
                                                select
                                                    symbol
                                                from
                                                    top_token_1000_temp
                                                where
                                                    holders >= 100
                                                  and removed = false)
                                                  and wlp."type" = 'LP') lpt
            ON (white_list_erc20_temp.address = lpt.address) ) w on w.address = dtvcr."token"
    where dtvcr.type='stakelp'
group by
    dtvcr.address,
    token,
    dtvcr.type,
    project;
insert into tag_result(table_name,batch_date)  SELECT 'total_dex_tx_volume_count_summary_stake' as table_name,'${batchDate}'  as batch_date;
