drop table if exists dex_tx_count_summary;
CREATE TABLE public.dex_tx_count_summary (
                                             address varchar(256) NOT NULL,
                                             "token" varchar(256) NOT NULL,
                                             total_transfer_count int8 DEFAULT 0,
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
    dex_tx_volume_count_summary(address,
                                token,
                                TYPE,
                                project,
                                transaction_hash,
                                total_transfer_count)
SELECT
    address,
    token,
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
    token,
    TYPE,
    project,
    transaction_hash;

