-- public.token_holding_time_temp definition

-- Drop table

DROP TABLE IF EXISTS public.token_holding_time_temp;
CREATE TABLE public.token_holding_time_temp (
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

insert into token_holding_time_temp(
    address,
    "token",
    updated_block_height,
    first_tx_time,
    latest_tx_time
)
select
    token_holding_temp.address,
    token_holding_temp.token,
    token_holding_vol_count_temp.block_height,
    TO_TIMESTAMP(block_timestamp.timestamp)  as first_tx_time,
    TO_TIMESTAMP(block_timestamp.timestamp) as latest_tx_time
from
    token_holding_temp
        inner join token_holding_vol_count_temp on
        (token_holding_vol_count_temp.address = token_holding_temp.address
            and token_holding_vol_count_temp.token = token_holding_temp.token)
        inner join block_timestamp on
        (token_holding_vol_count_temp.block_height = block_timestamp.height)
where
        recent_time_code = 'ALL'
  and token_holding_temp.balance>0 ;
insert into tag_result(table_name,batch_date) SELECT 'total_token_holding_time' as table_name, '${batchDate}' as batch_date;


