drop table if exists nft_holding;
CREATE TABLE public.nft_holding
(
    address                    varchar(512) NOT NULL,
    "token"                    varchar(512) NOT NULL,
    balance                    int8         NOT NULL,
    total_transfer_volume      int8         NOT NULL,
    total_transfer_count       int8 NULL,
    total_transfer_to_volume   int8         NOT NULL,
    total_transfer_to_count    int8 NULL,
    total_transfer_mint_volume int8         NOT NULL,
    total_transfer_mint_count  int8 NULL,
    total_transfer_burn_volume int8         NOT NULL,
    total_transfer_burn_count  int8 NULL,
    total_transfer_all_volume  int8         NOT NULL,
    total_transfer_all_count   int8 NULL,
    updated_block_height       int8         NOT NULL,
    recent_time_code           varchar(30) NULL,
    created_at                 timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                 timestamp NULL DEFAULT CURRENT_TIMESTAMP
) distributed by (address, token);
truncate table nft_holding;
vacuum nft_holding;
insert into tag_result(table_name, batch_date)
SELECT 'nft_holding' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;
