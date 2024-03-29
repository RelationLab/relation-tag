drop table if exists address_label_token_balance_grade_all;
CREATE TABLE public.address_label_token_balance_grade_all
(
    address          varchar(512) NULL,
    data             numeric(250, 20) NULL,
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
truncate table public.address_label_token_balance_grade_all;
vacuum
address_label_token_balance_grade_all;

insert into public.address_label_token_balance_grade_all(address, label_type, label_name, data, wired_type, updated_at,
                                                         "group", level, category, trade_type, project, asset, bus_type)
select address,
       a2.label_type,
       a2.label_type || case
                            when balance_usd >= 100
                                and balance_usd < 1000 then '0a'
                            when balance_usd >= 1000
                                and balance_usd < 10000 then '0b'
                            when balance_usd >= 10000
                                and balance_usd < 50000 then '0c'
                            when balance_usd >= 50000
                                and balance_usd < 100000 then '0d'
                            when balance_usd >= 100000
                                and balance_usd < 500000 then '0e'
                            when balance_usd >= 500000
                                and balance_usd < 1000000 then '0f'
                            when balance_usd >= 1000000
                                and balance_usd < 1000000000 then '0g'
                            when balance_usd >= 1000000000 then '0h'
           end                                                   as label_name,
       balance_usd                                               as data,
       'DEFI'                                                    as wired_type,
       now()                                                     as updated_at,
       'b'                                                       as "group",
       case
           when balance_usd >= 100
               and balance_usd < 1000 then 'L1'
           when balance_usd >= 1000
               and balance_usd < 10000 then 'L2'
           when balance_usd >= 10000
               and balance_usd < 50000 then 'L3'
           when balance_usd >= 50000
               and balance_usd < 100000 then 'L4'
           when balance_usd >= 100000
               and balance_usd < 500000 then 'L5'
           when balance_usd >= 500000
               and balance_usd < 1000000 then 'L6'
           when balance_usd >= 1000000
               and balance_usd < 1000000000 then 'Millionaire'
           when balance_usd >= 1000000000 then 'Billionaire' end as level,
       'grade'                                                   as category,
       'ALL'                                                        trade_type,
       ''                                                        as project,
       'ALL'                                                     as asset,
       'balance'                                                 as bus_type
from (select address,
             'ALL'                      as token,
             sum(round(balance_usd, 8)) as balance_usd
      from total_balance_volume_usd_temp tbvu
      where balance_usd >= 100
      group by address) a1
         inner join
     dim_rule_content_temp a2
     on
         a1.token = a2.token
where a1.balance_usd >= 100
  and a2.data_subject = 'balance_grade'
  and a2.token_type = 'token'
  and address not in (select address from exclude_address);

drop table if exists address_label_crowd_token_whale;
CREATE TABLE public.address_label_crowd_token_whale
(
    address          varchar(512) NULL,
    data             numeric(250, 20) NULL,
    wired_type       varchar(20) NULL,
    label_type       varchar(512) NULL,
    label_name       varchar(1024) NULL,
    updated_at       timestamp(6) NULL,
    "group"          varchar(1) NULL,
    "level"          varchar(100) NULL,
    category         varchar(100) NULL,
    trade_type       varchar(100) NULL,
    project          varchar(100) NULL,
    asset            varchar(100) NULL,
    bus_type         varchar(20) NULL,
    recent_time_code varchar(30) NULL
);
truncate table public.address_label_crowd_token_whale;
insert into public.address_label_crowd_token_whale(address, label_type, label_name, data, wired_type, updated_at,
                                                   "group", level, category, trade_type, project, asset, bus_type)
select distinct a1.address,
                'ctw' as label_type,
                'ctw' as label_name,
                0                   as data,
                'CROWD'             as wired_type,
                now()               as updated_at,
                'g'                 as "group",
                'ctw' as level,
                'other'             as category,
                'ALL'                  trade_type,
                'ALL'               as project,
                'ALL'               as asset,
                'CROWD'             as bus_type
from (select address
      from address_label_token_balance_grade_all
      where
          label_name = 'bt0j'
         or label_name = 'bg0g'
         or label_name = 'bg0h'
--           label_name = 'ALL_ALL_ALL_BALANCE_GRADE_Millionaire'
--          or label_name = 'ALL_ALL_ALL_BALANCE_GRADE_Billionaire'
--          or label_name = 'ALL_ALL_ALL_BALANCE_TOP_WHALE'
      union all
      select address
      from address_label_token_balance_rank_all) a1
where address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_token_balance_grade_all' as table_name, '${batchDate}' as batch_date;

