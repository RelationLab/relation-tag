drop table if exists dex_tx_volume_count_summary;
CREATE TABLE public.dex_tx_volume_count_summary (
                                                    address varchar(256) NOT NULL,
                                                    "token" varchar(256) NOT NULL,
                                                    block_height int8 NOT NULL,
                                                    total_transfer_volume_usd numeric(125, 30) DEFAULT 0,
                                                    total_transfer_count int8 DEFAULT 0,
                                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    removed bool NULL DEFAULT false,
                                                    first_updated_block_height int8 NOT NULL DEFAULT 99999999,
                                                    transaction_hash varchar(100) NULL,
                                                    router varchar(150) NULL,
                                                    "type" varchar(10) NULL,
                                                    project varchar(100) NULL,
                                                    in_transfer_volume numeric(125, 30) NULL,
                                                    out_transfer_volume numeric(125, 30) NULL,
                                                    in_transfer_count int8 NULL,
                                                    out_transfer_count int8 NULL,
                                                    balance_usd numeric(125, 30) DEFAULT 0
) DISTRIBUTED BY (address);
truncate table dex_tx_volume_count_summary;
vacuum dex_tx_volume_count_summary;

---汇总UNIv3的LP数据
insert
into
    dex_tx_volume_count_summary(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                balance_usd)
select
    th.address,
    th.price_token as token,
    th.type as type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
    max(th.block_height) as block_height,
    sum(round(th.total_transfer_volume * round(cast(w.price as numeric), 18),8)) as total_transfer_volume_usd,
    sum(total_transfer_count) as total_transfer_count,
    min(first_updated_block_height) as first_updated_block_height,
    sum(round(th.balance * round(cast (w.price as numeric), 18),8)) as balance_usd
        from
        token_holding_uni_cal th
        inner join (
            select
                white_list_erc20.*
            from
                white_list_erc20
                    INNER JOIN (select address from top_token_1000 tt2  where tt2.holders>=100 and removed<>true)
                    top_token_1000 ON (white_list_erc20.address = top_token_1000.address)) w on
        w.address = th.price_token
        group by
        th.address,
        th.price_token,
        th.type;

---汇总UNIv3的LP数据
insert
into
    dex_tx_volume_count_summary(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                balance_usd)
select
    th.address,
    'ALL' as token,
    th.type as type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
    max(th.block_height) as block_height,
    sum(round(th.total_transfer_volume * round(cast(w.price as numeric), 18),8)) as total_transfer_volume_usd,
    sum(total_transfer_count) as total_transfer_count,
    min(first_updated_block_height) as first_updated_block_height,
    sum(round(th.balance * round(cast (w.price as numeric), 18),8)) as balance_usd
from
    token_holding_uni_cal th
        inner join (
        select
            white_list_erc20.*
        from
            white_list_erc20
                INNER JOIN (select address from top_token_1000 tt2  where tt2.holders>=100 and removed<>true)
                top_token_1000 ON (white_list_erc20.address = top_token_1000.address)) w on
            w.address = th.price_token
            and triggered_flag = '1'
group by
    th.address,
    th.type;

---先把dex_tx_volume_count_record的USD计算出来
insert
into
    dex_tx_volume_count_summary(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                balance_usd)
select
    dtvcr.address,
    token,
    dtvcr.type,
    project,
    max(block_height) block_height,
    sum(round(total_transfer_volume * round(cast (w.price as numeric), 18),8) ) as total_transfer_volume_usd,
    sum(total_transfer_count) total_transfer_count,
    min(first_updated_block_height) first_updated_block_height,
    sum(round(balance * round(cast (w.price as numeric), 18),8)) as balance_usd
from
    dex_tx_volume_count_record_hash  dtvcr
        inner join (
        select
            white_list_erc20.*
        from
            white_list_erc20   INNER JOIN (select address from top_token_1000 tt2  where tt2.holders>=100 and removed<>true)
                top_token_1000 ON (white_list_erc20.address = top_token_1000.address) ) w on
            w.address = dtvcr."token"
                and  (token,project) not in(('0x5e8422345238f34275888049021821e8e08caa1f','0xbafa44efe7901e04e39dad13167d089c559c1138'),
                                  ('0xae7ab96520de3a18e5e111b5eaab095312d7fe84','0xae7ab96520de3a18e5e111b5eaab095312d7fe84'),
                                    ('0xae78736cd615f374d3085123a210448e74fc6393','0x4d05e3d48a938db4b7a9a59a802d5b45011bde58'),
                                    ('0xac3e018457b222d93114458476f3e3416abbe38f','0xbafa44efe7901e04e39dad13167d089c559c1138'))
group by
    dtvcr.address,
    token,
    dtvcr.type,
    project;

---计算token为ALL的 也是从dex_tx_volume_count_record的USD计算出来
insert
into
    dex_tx_volume_count_summary(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                balance_usd)
select
    dtvcr.address,
    'ALL' AS token,
    dtvcr.type,
    project,
    max(block_height) block_height,
    sum(round(total_transfer_volume * round(cast (w.price as numeric), 18),8) ) as total_transfer_volume_usd,
    sum(total_transfer_count) total_transfer_count,
    min(first_updated_block_height) first_updated_block_height,
    sum(round(balance * round(cast (w.price as numeric), 18),8)) as balance_usd
from
    dex_tx_volume_count_record  dtvcr
        inner join (
        select
            white_list_erc20.*
        from
            white_list_erc20   INNER JOIN (select address from top_token_1000 tt2  where tt2.holders>=100 and removed<>true)
                top_token_1000 ON (white_list_erc20.address = top_token_1000.address) ) w on
                w.address = dtvcr."token"
            and  (token,project) not in(('0x5e8422345238f34275888049021821e8e08caa1f','0xbafa44efe7901e04e39dad13167d089c559c1138'),
                                        ('0xae7ab96520de3a18e5e111b5eaab095312d7fe84','0xae7ab96520de3a18e5e111b5eaab095312d7fe84'),
                                        ('0xae78736cd615f374d3085123a210448e74fc6393','0x4d05e3d48a938db4b7a9a59a802d5b45011bde58'),
                                        ('0xac3e018457b222d93114458476f3e3416abbe38f','0xbafa44efe7901e04e39dad13167d089c559c1138'))
            and triggered_flag = '1'
group by
    dtvcr.address,
    dtvcr.type,
    project;


---再计算dex_tx_volume_count_summary的ALL(有些同一笔交易txHash同时LP和SWAP)
insert
into
    dex_tx_volume_count_summary (address,
                                 token,
                                 type,
                                 project,
                                 block_height,
                                 total_transfer_volume_usd,
                                 total_transfer_count,
                                 first_updated_block_height,
                                 balance_usd)

select dtvcr.address as address
     ,dtvcr.token as token
     ,'ALL' as type
     ,dtvcr.project as project
     ,min(dtvcr.block_height) as block_height
     ,sum(dtvcr.total_transfer_volume_usd) as total_transfer_volume_usd
     ,sum(dtvcr.total_transfer_count) as total_transfer_count
     ,min(dtvcr.first_updated_block_height) as first_updated_block_height
     ,max(dtvcr.balance_usd)  as balance_usd from
    dex_tx_volume_count_summary dtvcr
group by
    dtvcr.address,
    dtvcr."token",
    dtvcr.project;
insert into tag_result(table_name,batch_date)  SELECT 'dex_tx_volume_count_summary' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;


