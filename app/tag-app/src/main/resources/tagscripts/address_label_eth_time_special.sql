drop table if exists address_label_eth_time_special;
CREATE TABLE public.address_label_eth_time_special
(
    address          varchar(512) NULL,
    data             numeric(280, 20) NULL,
    wired_type       varchar(20) NULL,
    label_type       varchar(512) NULL,
    label_name       varchar(1024) NULL,
    updated_at       timestamp(6) NULL,
    "group"          varchar(1) NULL,
    "level"          varchar(80) NULL,
    category         varchar(80) NULL,
    trade_type       varchar(80) NULL,
    project          varchar(80) NULL,
    asset            varchar(80) NULL,
    bus_type         varchar(20) NULL,
    recent_time_code varchar(30) NULL
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    distributed by
(
    address,
    label_name,
    recent_time_code
);
truncate table public.address_label_eth_time_special;
vacuum
address_label_eth_time_special;

insert into public.address_label_eth_time_special(address, label_type, label_name, data, wired_type, updated_at,
                                                  "group", level, category, trade_type, project, asset, bus_type)
select a1.address,
       a2.label_type,
       a2.label_type || case
                            when counter >= 155 then '3g'
                            when counter >= 1
                                and counter < 155 then '3h'
           end       as label_name,
       a1.counter    as data,
       'DEFI'        as wired_type,
       now()         as updated_at,
       't'           as "group",
       case
           when counter >= 155 then 'LONG_TERM_HOLDER'
           when counter >= 1
               and counter < 155 then 'SHORT_TERM_HOLDER'
           end       as level,
       'other'       as category,
       'ALL'            trade_type,
       'ALL'         as project,
       a2.token_name as asset,
       'time'        as bus_type
from (select address,
             'eth'                                                                                               as token,
             floor((floor( EXTRACT(epoch FROM CAST('${batchDate}' AS TIMESTAMP))) - floor(extract(epoch from latest_tx_time))) /
                   (24 * 3600))                                                                                  as counter
      from eth_holding_time_temp tbvutk) a1
         inner join
     dim_rule_content_temp a2
     on
         a1.token = a2.token
where a2.data_subject = 'time_special'
  and counter >= 1
  and a2.token_type = 'token'
  and address not in (select address from exclude_address);

drop table if exists address_label_crowd_long_term_holder;
CREATE TABLE public.address_label_crowd_long_term_holder
(
    address          varchar(512) NULL,
    data             numeric(280, 20) NULL,
    wired_type       varchar(20) NULL,
    label_type       varchar(512) NULL,
    label_name       varchar(1024) NULL,
    updated_at       timestamp(6) NULL,
    "group"          varchar(1) NULL,
    "level"          varchar(80) NULL,
    category         varchar(80) NULL,
    trade_type       varchar(80) NULL,
    project          varchar(80) NULL,
    asset            varchar(80) NULL,
    bus_type         varchar(20) NULL,
    recent_time_code varchar(30) NULL
);
truncate table public.address_label_crowd_long_term_holder;
insert into public.address_label_crowd_long_term_holder(address, label_type, label_name, data, wired_type, updated_at,
                                                        "group", level, category, trade_type, project, asset, bus_type)
select distinct a1.address,
                'clth' as label_type,
                'clth' as label_name,
                0                        as data,
                'CROWD'                  as wired_type,
                now()                    as updated_at,
                'g'                      as "group",
                'clth'    level,
                'other'                  as category,
                'ALL'                       trade_type,
                ''                       as project,
                'ALL'                    as asset,
                'CROWD'                  as bus_type
from (select address
      from address_label_eth_time_special
      where label_name = 't832ts3g'
--           label_name = 'ETH_HOLDING_TIME_SPECIAL_LONG_TERM_HOLDER'
      union all
      select address
      from address_label_token_time_special
      where label_name like 't%ts3g'
--           label_name like '%_HOLDING_TIME_SPECIAL_LONG_TERM_HOLDER'
      union all
      select address
      from address_label_nft_time_rank
      where  label_name like 'n%ts7g'
--           label_name like '%_NFT_TIME_SPECIAL_LONG_TERM_HOLDER'
      ) a1
where address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_eth_time_special' as table_name, '${batchDate}' as batch_date;
