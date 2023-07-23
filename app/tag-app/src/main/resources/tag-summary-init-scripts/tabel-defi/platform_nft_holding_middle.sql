drop table if exists platform_nft_holding_middle;
CREATE TABLE public.platform_nft_holding_middle
(
    address                   varchar(512) NOT NULL,
    platform                  varchar(512) NOT NULL,
    quote_token               varchar(512) NOT NULL,
    "token"                   varchar(512) NOT NULL,
    total_transfer_volume     numeric(128, 30) NULL,
    total_transfer_count      int8 NULL,
    total_transfer_to_volume  numeric(128, 30) NULL,
    total_transfer_to_count   int8 NULL,
    total_transfer_all_volume numeric(128, 30) NULL,
    total_transfer_all_count  int8 NULL,
    recent_time_code           varchar(30) NULL,
    created_at                timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    platform_group            varchar(256) NULL
) distributed by (address, token, quote_token, platform,recent_time_code);
truncate table platform_nft_holding_middle;
vacuum platform_nft_holding_middle;
insert into tag_result(table_name, batch_date)
SELECT 'platform_nft_holding_middle' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;
