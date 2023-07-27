update dex_tx_volume_count_record_cdc
set project='0x1111111254fb6c44bac0bed2854e76f90643097d'
where project = '0x1111111254fb6c44bAC0beD2854e76F90643097d';

update dex_tx_volume_count_record_cdc
set token='eth'
where (project = '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
    or project = '0x4d05e3d48a938db4b7a9a59a802d5b45011bde58'
    or project = '0xbafa44efe7901e04e39dad13167d089c559c1138')
  and token = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2';

update dex_tx_volume_count_record_cdc
set token='eth'
where (project = '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
    or project = '0x4d05e3d48a938db4b7a9a59a802d5b45011bde58'
    or project = '0xbafa44efe7901e04e39dad13167d089c559c1138')
  and (token = '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
    or token = '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
    or token = '0xae78736cd615f374d3085123a210448e74fc6393'
    or token = '0xac3e018457b222d93114458476f3e3416abbe38f'
    or token = '0x5e8422345238f34275888049021821e8e08caa1f')
  and type = 'withdraw';

DROP TABLE IF EXISTS public.token_platform;
CREATE TABLE public.token_platform
(
    address       varchar NOT NULL,
    platform      varchar NOT NULL,
    platform_name varchar NULL,
    created_at    timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    timestamp NULL DEFAULT CURRENT_TIMESTAMP
) DISTRIBUTED BY (address,platform);
truncate table token_platform;
vacuum token_platform;
insert into token_platform (address, platform)
select token, project
from (select token, project
      from dex_tx_volume_count_record
      union all
      select price_token token, '0xc36442b4a4522e871399cd717abdd847ab11fe88' project
      from token_holding_uni) outt
group by token, project;
insert into tag_result(table_name, batch_date)
SELECT 'data_cal_token_platform' as table_name, '${batchDate}' as batch_date;
