-- public.nft_buy_sell_holding definition
drop table if exists snapshot_nft_buy_sell_holding;
CREATE TABLE public.snapshot_nft_buy_sell_holding (
                                             address varchar(512) NOT NULL,
                                             "token" varchar(512) NOT NULL,
                                             total_transfer_buy_volume int8 NOT NULL,
                                             total_transfer_buy_count int8 NULL,
                                             total_transfer_sell_volume int8 NOT NULL,
                                             total_transfer_sell_count int8 NULL,
                                             updated_block_height int8 NOT NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT false
)distributed by (address, token);
CREATE INDEX idx_nbsh_gin_trgm ON public.snapshot_nft_buy_sell_holding USING btree (address);
CREATE INDEX idx_nbsh_updatedblockheight ON public.snapshot_nft_buy_sell_holding USING btree (updated_block_height DESC);
truncate table snapshot_nft_buy_sell_holding;
vacuum snapshot_nft_buy_sell_holding;
insert into snapshot_nft_buy_sell_holding(address ,
                                 "token" ,
                                 total_transfer_buy_volume,
                                 total_transfer_buy_count ,
                                 total_transfer_sell_volume,
                                 total_transfer_sell_count ,
                                 updated_block_height,
                                 created_at ,
                                 updated_at ,
                                 removed )
select address ,
       "token" ,
       total_transfer_buy_volume,
       total_transfer_buy_count ,
       total_transfer_sell_volume,
       total_transfer_sell_count ,
       updated_block_height,
       created_at ,
       updated_at ,
       removed  from nft_buy_sell_holding;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
