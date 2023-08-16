drop table if exists address_label_univ3_volume_grade;
CREATE TABLE public.address_label_univ3_volume_grade
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
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    distributed by
(
    address,
    label_name,
    recent_time_code
);
truncate table public.address_label_univ3_volume_grade;
vacuum
address_label_univ3_volume_grade;

insert into public.address_label_univ3_volume_grade(address, label_type, label_name, data, wired_type, updated_at,
                                                    "group", level, category, trade_type, project, asset, bus_type,
                                                    recent_time_code)
select a1.address,
       a2.label_type,
       a2.label_type || case
                            when volume_usd >= 100
                                and volume_usd < 1000 then '1a'
                            when volume_usd >= 1000
                                and volume_usd < 10000 then '1b'
                            when volume_usd >= 10000
                                and volume_usd < 50000 then '1c'
                            when volume_usd >= 50000
                                and volume_usd < 100000 then '1d'
                            when volume_usd >= 100000
                                and volume_usd < 500000 then '1e'
                            when volume_usd >= 500000
                                and volume_usd < 1000000 then '1f'
                            when volume_usd >= 1000000
                                and volume_usd < 1000000000 then '1g'
                            when volume_usd >= 1000000000 then '1h'
           end                                              as label_name,
       volume_usd                                           as data,
       'DEFI'                                               as wired_type,
       now()                                                as updated_at,
       'v'                                                  as "group",
       case
           when volume_usd >= 100
               and volume_usd < 1000 then 'L1'
           when volume_usd >= 1000
               and volume_usd < 10000 then 'L2'
           when volume_usd >= 10000
               and volume_usd < 50000 then 'L3'
           when volume_usd >= 50000
               and volume_usd < 100000 then 'L4'
           when volume_usd >= 100000
               and volume_usd < 500000 then 'L5'
           when volume_usd >= 500000
               and volume_usd < 1000000 then 'L6'
           when volume_usd >= 1000000
               and volume_usd < 1000000000 then 'Million'
           when volume_usd >= 1000000000 then 'Billion' end as level,
       'grade'                                              as category,
       'ALL'                                                   trade_type,
       ''                                                   as project,
       a2.token_name                                        as asset,
       'volume'                                             as bus_type,
       recent_time_code
from (select dtvcs.address,
             dtvcs.token,
             round(total_transfer_volume_usd, 8) as volume_usd,
             recent_time_code
      from dex_tx_volume_count_summary_univ3_temp dtvcs
               inner join dim_rule_content_temp drc
                          on (dtvcs.token = drc.token and drc.data_subject = 'volume_grade'
                              and dtvcs.recent_time_code = drc.recent_code)
      where dtvcs.project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
        and dtvcs.total_transfer_volume_usd >= 100) a1
         inner join
     dim_rule_content_temp a2
     on
                 a1.token = a2.token
             and a2.label_type like 'Uniswap_v3%'
             and a1.recent_time_code = a2.recent_code
where a2.data_subject = 'volume_grade'
  and address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_univ3_volume_grade' as table_name, '${batchDate}' as batch_date;
