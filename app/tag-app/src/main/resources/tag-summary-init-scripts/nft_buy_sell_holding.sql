-- public.nft_buy_sell_holding_temp definition

-- Drop table

-- DROP TABLE public.nft_buy_sell_holding_temp;
drop table if exists nft_buy_sell_holding_temp;

CREATE TABLE public.nft_buy_sell_holding_temp (
                                             address varchar(512) NOT NULL,
                                             "token" varchar(512) NOT NULL,
                                             total_transfer_buy_volume int8 NOT NULL,
                                             total_transfer_buy_count int8 NULL,
                                             total_transfer_sell_volume int8 NOT NULL,
                                             total_transfer_sell_count int8 NULL,
                                             updated_block_height int8 NOT NULL,
                                             recent_time_code          varchar(30) NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,"token",recent_time_code);
truncate table nft_buy_sell_holding_temp;
vacuum nft_buy_sell_holding_temp;


insert
into
    nft_buy_sell_holding_temp (address,
                          token,
                          total_transfer_buy_volume,
                          total_transfer_buy_count,
                          total_transfer_sell_volume,
                          total_transfer_sell_count,
                          updated_block_height,
                          recent_time_code)
    (
        select
            address,
            token,
            sum(total_transfer_buy_volume),
            sum(total_transfer_buy_count),
            sum(total_transfer_sell_volume),
            sum(total_transfer_sell_count),
            max(updated_block_height),
            recent_time_code
        from
            nft_buy_sell_holding_middle
        group by
            address,
            token,
            recent_time_code);
insert into tag_result(table_name,batch_date)  SELECT 'nft_buy_sell_holding' as table_name,'${batchDate}'  as batch_date;
