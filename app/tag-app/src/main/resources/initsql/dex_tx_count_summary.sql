drop table if exists dex_tx_count_summary;
CREATE TABLE public.dex_tx_count_summary (
                                             address varchar(256) NOT NULL,
                                             "token" varchar(256) NOT NULL,
                                             total_transfer_count int8 DEFAULT 0,
                                             transaction_hash varchar(100) NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT FALSE,
                                             "type" varchar(10) NULL,
                                             project varchar(100) NULL
) DISTRIBUTED BY (address);
truncate table dex_tx_count_summary;
vacuum dex_tx_count_summary;

INSERT
INTO
    dex_tx_count_summary(address,
                         token,
                         TYPE,
                         project,
                         total_transfer_count)
select
    address,
    'ALL' as token,
    type,
    project,
    sum(total_transfer_count) total_transfer_count
from
    (
        select
            dex_tx_volume_count_record.address,
            dex_tx_volume_count_record.TYPE,
            dex_tx_volume_count_record.project,
            max(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_record
                inner join (
                select
                    address
                from
                    top_token_1000 tt2
                where
                        tt2.holders >= 100
                  and removed <> true)
                top_token_1000 on
                (dex_tx_volume_count_record.token = top_token_1000.address)
        where
                triggered_flag = '1'
          and total_transfer_count = 1
        group by
            dex_tx_volume_count_record.address,
            dex_tx_volume_count_record.TYPE,
            dex_tx_volume_count_record.project,
            dex_tx_volume_count_record.transaction_hash) outt
group by
    address,
    type,
    project;

INSERT
INTO
    dex_tx_count_summary(address,
                         token,
                         TYPE,
                         project,
                         total_transfer_count)
select
    address,
    'ALL' token,
    type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' project,
    sum(total_transfer_count)
from
    (
        select
            th.address,
            'ALL' as token,
            th.type as type,
            max(total_transfer_count) as total_transfer_count
        from
            token_holding_uni th
                inner join (
                select
                    address
                from
                    top_token_1000 tt2
                where
                        tt2.holders >= 100
                  and removed <> true)
                top_token_1000 on
                (th.price_token = top_token_1000.address)
        where triggered_flag = '1'
        group by
            th.address,
            th.type,
            th.transaction_hash) outt
group by
    address,
    type;


INSERT
INTO
    dex_tx_count_summary(address,
                         token,
                         TYPE,
                         project,
                         total_transfer_count)
SELECT
    address,
    'ALL' AS token,
    'ALL' as TYPE,
    project,
    sum(total_transfer_count) AS total_transfer_count
FROM
    dex_tx_count_summary
GROUP BY
    address,
    project;

insert into tag_result(table_name,batch_date)  SELECT 'dex_tx_count_summary' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
