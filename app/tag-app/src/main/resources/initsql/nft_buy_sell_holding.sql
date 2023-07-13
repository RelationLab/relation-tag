-- public.nft_buy_sell_holding definition

-- Drop table

-- DROP TABLE public.nft_buy_sell_holding;
drop table if exists nft_buy_sell_holding;

CREATE TABLE public.nft_buy_sell_holding (
                                             address varchar(512) NOT NULL,
                                             "token" varchar(512) NOT NULL,
                                             total_transfer_buy_volume int8 NOT NULL,
                                             total_transfer_buy_count int8 NULL,
                                             total_transfer_sell_volume int8 NOT NULL,
                                             total_transfer_sell_count int8 NULL,
                                             updated_block_height int8 NOT NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT false,
                                             CONSTRAINT uk_nbsh_address_token UNIQUE (address, token)
);
CREATE INDEX idx_nbsh_gin_trgm ON public.nft_buy_sell_holding USING btree (address);
CREATE INDEX idx_nbsh_updatedblockheight ON public.nft_buy_sell_holding USING btree (updated_block_height DESC);
truncate table nft_buy_sell_holding;
vacuum nft_buy_sell_holding;


insert into nft_buy_sell_holding (address, token, total_transfer_buy_volume, total_transfer_buy_count,
                                       total_transfer_sell_volume, total_transfer_sell_count, updated_block_height)
    (select address, token,  sum(total_transfer_buy_volume),  sum(total_transfer_buy_count),
            sum(total_transfer_sell_volume), sum(total_transfer_sell_count), max(updated_block_height)
     from nft_buy_sell_holding_temp
     group by address, token);
insert into tag_result(table_name,batch_date)  SELECT 'nft_buy_sell_holding' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
