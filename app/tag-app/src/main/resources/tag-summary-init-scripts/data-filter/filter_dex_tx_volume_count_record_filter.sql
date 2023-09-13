drop table if exists dex_tx_volume_count_record_filter;
CREATE TABLE public.dex_tx_volume_count_record_filter (
                                                    address varchar(256) NOT NULL,
                                                    "token" varchar(256) NOT NULL,
                                                    block_height int8 NOT NULL,
                                                    total_transfer_volume_usd numeric(125, 30) DEFAULT 0,
                                                    total_transfer_count int8 DEFAULT 0,
                                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    first_updated_block_height int8 NOT NULL DEFAULT 99999999,
                                                    transaction_hash varchar(100) NULL,
                                                    "type" varchar(10) NULL,
                                                    triggered_flag varchar(10) NULL,
                                                    project varchar(100) NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
DISTRIBUTED BY (address,"token");
truncate table dex_tx_volume_count_record_filter;
vacuum dex_tx_volume_count_record_filter;


insert
into
    dex_tx_volume_count_record_filter(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                triggered_flag,
                                transaction_hash)
select
    dtvcr.address,
    token,
    dtvcr.type,
    project,
    max(block_height) block_height,
    max(round(total_transfer_volume * round(cast (w.price as numeric), 18),8) ) as total_transfer_volume_usd,
    sum(1) total_transfer_count,
    min(first_updated_block_height) first_updated_block_height,
    max(triggered_flag) as triggered_flag,
    transaction_hash
from
    dex_tx_volume_count_record  dtvcr
        inner join (
        select
            white_list_erc20_temp.*
        from
            white_list_erc20_temp   INNER JOIN (
            select address from top_token_1000_temp tt2  where tt2.holders>=100 and removed<>true
            union all
            select
                   wlp.address               as address
            from white_list_lp_temp wlp
                     left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
            where wlp.tvl > 1000000
             and wlp.tokens <@ ARRAY(
select
	address
from
	top_token_1000_temp
where
	holders >= 100
	and removed = false)
                and wlp."type" = 'LP'
            ) top_token_1000_temp ON (white_list_erc20_temp.address = top_token_1000_temp.address) ) w
            on w.address = dtvcr."token"
            and  (token,project) not in(('0x5e8422345238f34275888049021821e8e08caa1f','0xbafa44efe7901e04e39dad13167d089c559c1138'),
                                        ('0xae7ab96520de3a18e5e111b5eaab095312d7fe84','0xae7ab96520de3a18e5e111b5eaab095312d7fe84'),
                                        ('0xae78736cd615f374d3085123a210448e74fc6393','0x4d05e3d48a938db4b7a9a59a802d5b45011bde58'),
                                        ('0xac3e018457b222d93114458476f3e3416abbe38f','0xbafa44efe7901e04e39dad13167d089c559c1138'))
group by
    dtvcr.address,
    token,
    dtvcr.type,
    project,
    transaction_hash;
insert into tag_result(table_name,batch_date)  SELECT 'filter_dex_tx_volume_count_record_filter' as table_name,'${batchDate}'  as batch_date;
