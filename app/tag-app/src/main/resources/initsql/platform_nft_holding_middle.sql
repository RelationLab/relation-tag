drop table if exists platform_nft_holding_middle;
CREATE TABLE public.platform_nft_holding_middle (
                                             address varchar(512) NOT NULL,
                                             platform varchar(512) NOT NULL,
                                             quote_token varchar(512) NOT NULL,
                                             "token" varchar(512) NOT NULL,
                                             total_transfer_volume numeric(128, 30) NULL,
                                             total_transfer_count int8 NULL,
                                             total_transfer_to_volume numeric(128, 30) NULL,
                                             total_transfer_to_count int8 NULL,
                                             total_transfer_all_volume numeric(128, 30) NULL,
                                             total_transfer_all_count int8 NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT false,
                                             platform_group varchar(256) NULL
) distributed by (address, token, quote_token, platform);
truncate table platform_nft_holding_middle;
vacuum platform_nft_holding_middle;

insert into platform_nft_holding_middle (address, platform, quote_token, token, total_transfer_volume, total_transfer_count,
                                  total_transfer_to_volume, total_transfer_to_count, total_transfer_all_volume,
                                  total_transfer_all_count) (select from_address,
                                                                    platform_address,
                                                                    quote_token,
                                                                    token,
                                                                    sum(value),
                                                                    sum(count),
                                                                    0,
                                                                    0,
                                                                    sum(value),
                                                                    sum(count)
                                                             from platform_nft_tx_record
                                                             group by from_address, platform_address, quote_token, token);


insert into platform_nft_holding_middle (address, platform, quote_token, token, total_transfer_volume, total_transfer_count,
                                  total_transfer_to_volume, total_transfer_to_count, total_transfer_all_volume,
                                  total_transfer_all_count) (select to_address,
                                                                    platform_address,
                                                                    quote_token,
                                                                    token,
                                                                    0,
                                                                    0,
                                                                    sum(value),
                                                                    sum(count),
                                                                    sum(value),
                                                                    sum(count)
                                                             from platform_nft_tx_record
                                                             group by to_address, platform_address, quote_token, token);
insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_holding_middle' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
