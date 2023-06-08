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
                         transaction_hash,
                         total_transfer_count)
SELECT
    address,
    'ALL' AS token,
    TYPE,
    project,
    transaction_hash,
    max(total_transfer_count) AS total_transfer_count
FROM
    dex_tx_volume_count_record
WHERE
        token IN (
        SELECT
            token_id
        FROM
            dim_rank_token)
GROUP BY
    address,
    TYPE,
    project,
    transaction_hash;

INSERT
INTO
    dex_tx_count_summary(address,
                         token,
                         TYPE,
                         project,
                         transaction_hash,
                         total_transfer_count)
select
    th.address,
    'ALL' as token,
    th.type as type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
    transaction_hash,
    max(total_transfer_count) as total_transfer_count
from
    token_holding_uni_cal th
        inner join (
        select
            *
        from
            white_list_erc20
        where
                address in (
                select
                    token_id
                from
                    dim_rank_token)) w on
                w.address = th.price_token
            and triggered_flag = '1'
group by
    th.address,
    th.type,
    transaction_hash;