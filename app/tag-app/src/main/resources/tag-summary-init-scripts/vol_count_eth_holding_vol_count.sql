drop table if exists eth_holding_vol_count_temp;
-- ALTER TABLE public.eth_holding_vol_count_temp RENAME TO eth_holding_vol_count_temp_tmp;
CREATE TABLE public.eth_holding_vol_count_temp
(
    address               varchar(256) NULL,
    balance               numeric(125, 30) NULL,
    total_transfer_count  int8 NULL,
    block_height          int8 NULL,
    total_transfer_volume numeric(120, 30) NULL,
    recent_time_code varchar(30) NULL,
    created_at            timestamp NULL,
    updated_at            timestamp NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,recent_time_code);
truncate table eth_holding_vol_count_temp;
vacuum eth_holding_vol_count_temp;

insert
into eth_holding_vol_count_temp(address,
                           block_height,
                           total_transfer_volume,
                           total_transfer_count,
                           recent_time_code)
select address,
       max(block_height) as       block_height,
       sum(total_transfer_volume) total_transfer_volume,
       sum(total_transfer_count)  total_transfer_count,
       recent_time_code
from eth_tx_record_from_to etr
group by address,recent_time_code;
insert into tag_result(table_name, batch_date)
SELECT 'vol_count_eth_holding_vol_count' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;



