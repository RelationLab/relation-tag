drop table if exists snapshot_nft_holding;

CREATE TABLE public.snapshot_nft_holding (
                                    address varchar(512) NOT NULL,
                                    "token" varchar(512) NOT NULL,
                                    balance int8 NOT NULL,
                                    total_transfer_volume int8 NOT NULL,
                                    total_transfer_count int8 NULL,
                                    total_transfer_to_volume int8 NOT NULL,
                                    total_transfer_to_count int8 NULL,
                                    total_transfer_mint_volume int8 NOT NULL,
                                    total_transfer_mint_count int8 NULL,
                                    total_transfer_burn_volume int8 NOT NULL,
                                    total_transfer_burn_count int8 NULL,
                                    total_transfer_all_volume int8 NOT NULL,
                                    total_transfer_all_count int8 NULL,
                                    updated_block_height int8 NOT NULL,
                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    removed bool NULL DEFAULT false
)distributed by (address, token);
CREATE INDEX idx_nbv_updatedblockheight ON public.snapshot_nft_holding USING btree (updated_block_height DESC);
CREATE INDEX nft_activity_balance_volume_address_gin_trgm ON public.snapshot_nft_holding USING btree (address);
CREATE INDEX nft_activity_balance_volume_token_gin_trgm ON public.snapshot_nft_holding USING btree (token);
truncate table snapshot_nft_holding;
vacuum snapshot_nft_holding;

insert into snapshot_nft_holding(address,
    "token",
    balance ,
    total_transfer_volume ,
    total_transfer_count,
    total_transfer_to_volume ,
    total_transfer_to_count,
    total_transfer_mint_volume ,
    total_transfer_mint_count,
    total_transfer_burn_volume ,
    total_transfer_burn_count,
    total_transfer_all_volume ,
    total_transfer_all_count,
    updated_block_height ,
    created_at ,
    updated_at ,
    removed )
select  address,
        "token",
        balance ,
        total_transfer_volume ,
        total_transfer_count,
        total_transfer_to_volume ,
        total_transfer_to_count,
        total_transfer_mint_volume ,
        total_transfer_mint_count,
        total_transfer_burn_volume ,
        total_transfer_burn_count,
        total_transfer_all_volume ,
        total_transfer_all_count,
        updated_block_height ,
        created_at ,
        updated_at ,
        removed from nft_holding;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
