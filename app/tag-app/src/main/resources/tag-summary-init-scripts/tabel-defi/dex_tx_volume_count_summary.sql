drop table if exists dex_tx_volume_count_summary;
CREATE TABLE public.dex_tx_volume_count_summary
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

) DISTRIBUTED BY (address,token,project,recent_time_code);
truncate table dex_tx_volume_count_summary;
vacuum dex_tx_volume_count_summary;
insert into tag_result(table_name, batch_date)
SELECT 'dex_tx_volume_count_summary' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;


