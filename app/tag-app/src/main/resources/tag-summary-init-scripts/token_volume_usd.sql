-- DROP TABLE public.token_volume_usd_temp;
DROP TABLE IF EXISTS public.token_volume_usd_temp;
CREATE TABLE public.token_volume_usd_temp
(
    address          varchar(512) NULL,
    "token"          varchar(512) NULL,
    volume_usd       numeric NULL,
    created_at       timestamp NULL,
    updated_at       timestamp NULL,
    recent_time_code varchar(30) NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,"token",recent_time_code);
truncate table token_volume_usd_temp;
vacuum
token_volume_usd_temp;


insert
into token_volume_usd_temp(address,
                      token,
                      volume_usd,
                      recent_time_code)
select th.address,
       token,
       round(total_transfer_volume * round(cast(wle.price as numeric), 18), 8) as volume_usd,
       recent_time_code
from (select address,
             token,
             total_transfer_volume,
             recent_time_code
      from token_holding_vol_count_temp
      where total_transfer_volume > 0
        and token in (select token_id
                      from dim_rank_token_temp)) th
         inner join (select *
                     from white_list_erc20_temp
                     where address in (select token_id
                                       from dim_rank_token_temp)) wle on
            th.token = wle.address
        and ignored = false;

insert
into token_volume_usd_temp(address,
                      token,
                      volume_usd,
                      recent_time_code)
select eh.address                                                                     as address,
       'eth'                                                                          as token,
       round(eh.total_transfer_volume * round(cast(wle.price as numeric), 18), 8) as volume_usd,
       recent_time_code as recent_time_code
from (select address,
             total_transfer_volume,
             recent_time_code
      from eth_holding_vol_count_temp
      where total_transfer_volume > 0) eh
         inner join (select max(price) price
                     from white_list_erc20_temp
                     where symbol = 'WETH') wle on
        1 = 1;
insert into tag_result(table_name, batch_date)
SELECT 'token_volume_usd' as table_name, '${batchDate}' as batch_date;

