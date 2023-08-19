drop table if exists dex_tx_volume_count_summary_temp;
CREATE TABLE public.dex_tx_volume_count_summary_temp
(
    address                    varchar(256) NOT NULL,
    "token"                    varchar(256) NOT NULL,
    block_height               int8         NOT NULL,
    total_transfer_volume_usd  numeric(125, 30)      DEFAULT 0,
    total_transfer_count       int8                  DEFAULT 0,
    created_at                 timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                 timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    first_updated_block_height int8         NOT NULL DEFAULT 99999999,
    transaction_hash           varchar(100) NULL,
    "type"                     varchar(10) NULL,
    project                    varchar(100) NULL,
    recent_time_code varchar(30) NULL

) with (appendonly='true', compresstype=zstd, compresslevel='5')
    DISTRIBUTED BY (address,token,project,recent_time_code);
truncate table dex_tx_volume_count_summary_temp;
vacuum dex_tx_volume_count_summary_temp;
insert into tag_result(table_name, batch_date)
SELECT 'tabel_defi_dex_tx_volume_count_summary' as table_name, '${batchDate}' as batch_date;


