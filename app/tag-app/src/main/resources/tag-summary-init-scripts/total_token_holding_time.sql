-- public.token_holding_time definition

-- Drop table

DROP TABLE IF EXISTS public.token_holding_time;
CREATE TABLE public.token_holding_time (
                                           address varchar(42) NULL,
                                           "token" varchar(42) NULL,
                                           first_tx_time timestamp NULL,
                                           latest_tx_time timestamp NULL,
                                           updated_block_height int8 NULL,
                                           created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                           updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                           removed bool NULL DEFAULT false
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,token);

insert into token_holding_time(
    address,
    "token",
    updated_block_height,
    first_tx_time,
    latest_tx_time
)
select address,token,block_height from token_holding_vol_count_temp
    inner join
where recent_time_code='ALL';
