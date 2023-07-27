drop table if exists dex_tx_count_summary;
CREATE TABLE public.dex_tx_count_summary
(
    address              varchar(256) NOT NULL,
    "token"              varchar(256) NOT NULL,
    total_transfer_count int8 DEFAULT 0,
    transaction_hash     varchar(100) NULL,
    created_at           timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    removed              bool NULL DEFAULT FALSE,
    "type"               varchar(10) NULL,
    project              varchar(100) NULL,
    recent_time_code varchar(30) NULL
) DISTRIBUTED BY (address,"token",project,recent_time_code );
truncate table dex_tx_count_summary;
vacuum dex_tx_count_summary;
insert into tag_result(table_name, batch_date)
SELECT 'tabel_defi_dex_tx_count_summary' as table_name, '${batchDate}' as batch_date;
