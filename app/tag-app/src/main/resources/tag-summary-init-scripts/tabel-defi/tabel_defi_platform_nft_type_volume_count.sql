DROP TABLE if exists public.platform_nft_type_volume_count_temp;
CREATE TABLE public.platform_nft_type_volume_count_temp (
                                                       address varchar(512) NOT NULL,
                                                       platform_group varchar(256) NULL,
                                                       platform varchar(512) NOT NULL,
                                                       quote_token varchar(512) NOT NULL,
                                                       "token" varchar(512) NOT NULL,
                                                       type varchar(100) NOT NULL,
                                                       volume_usd numeric(128, 30) NULL,
                                                       volume int8 null,
                                                       transfer_count int8 null,
                                                       created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       removed bool NULL DEFAULT false,
                                                       recent_time_code varchar(30)  null
)distributed by (address, token, quote_token, platform,recent_time_code);
truncate table platform_nft_type_volume_count_temp;
vacuum platform_nft_type_volume_count_temp;

insert into tag_result(table_name,batch_date)  SELECT 'tabel_defi_platform_nft_type_volume_count' as table_name,'${batchDate}'  as batch_date;
