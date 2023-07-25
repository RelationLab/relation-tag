-- DROP TABLE public.token_volume_usd;
DROP TABLE IF EXISTS public.token_volume_usd;
CREATE TABLE public.token_volume_usd
(
    address          varchar(512) NULL,
    "token"          varchar(512) NULL,
    volume_usd       numeric NULL,
    created_at       timestamp NULL,
    updated_at       timestamp NULL,
    recent_time_code varchar(30) NULL
) distributed by (address);
truncate table token_volume_usd;
vacuum token_volume_usd;

insert
into token_volume_usd(address,
                      token,
                      volume_usd,
                      recent_time_code)
select address,
       token,
       total_transfer_volume,
       recent_time_code
from token_holding_vol_count
where total_transfer_volume > 0
    insert
into token_volume_usd(address,
                      token,
                      volume_usd,
                      recent_time_code)
select eh.address                                                                 as address,
       'eth'                                                                      as token,
       round(eh.total_transfer_volume * round(cast(wle.price as numeric), 18), 8) as volume_usd,
       recent_time_code                                                           as recent_time_code
from (select address,
             total_transfer_volume,
             recent_time_code
      from eth_holding_vol_count
      where total_transfer_volume > 0) eh
         inner join (select price
                     from white_list_erc20
                     where symbol = 'WETH'
                     group by price) wle on
    1 = 1;
insert into tag_result(table_name, batch_date)
SELECT 'token_volume_usd' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;



