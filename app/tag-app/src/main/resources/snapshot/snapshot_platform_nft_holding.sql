drop table if exists snapshot_platform_nft_holding;
CREATE TABLE public.snapshot_platform_nft_holding (
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
)distributed by (address, token);
CREATE INDEX idx_pnh_address_gin_trgm ON public.snapshot_platform_nft_holding USING btree (address);
CREATE INDEX idx_pnh_platform_gin_trgm ON public.snapshot_platform_nft_holding USING btree (platform);
CREATE INDEX idx_pnh_token_gin_trgm ON public.snapshot_platform_nft_holding USING btree (token);

truncate table snapshot_platform_nft_holding;
vacuum snapshot_platform_nft_holding;
    insert into snapshot_platform_nft_holding(address,
                                     platform,
                                     quote_token,
                                     "token",
                                     total_transfer_volume,
                                     total_transfer_count ,
                                     total_transfer_to_volume,
                                     total_transfer_to_count ,
                                     total_transfer_all_volume,
                                     total_transfer_all_count ,
                                     created_at ,
                                     updated_at ,
                                     removed ,
                                     platform_group)
select address,
       platform,
       quote_token,
       "token",
       total_transfer_volume,
       total_transfer_count ,
       total_transfer_to_volume,
       total_transfer_to_count ,
       total_transfer_all_volume,
       total_transfer_all_count ,
       created_at ,
       updated_at ,
       removed ,
       platform_group from platform_nft_holding;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
