drop table if exists address_label_nft_time_rank;
CREATE TABLE public.address_label_nft_time_rank
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
truncate table public.address_label_nft_time_rank;
vacuum
address_label_nft_time_rank;

insert into public.address_label_nft_time_rank(address, label_type, label_name, data, wired_type, updated_at, "group",
                                               level, category, trade_type, project, asset, bus_type)
select a1.address,
       a2.label_type,
       a2.label_type || case
                            when counter >= 155 then '7g'
                            when counter >= 1
                                and counter < 155 then '7h'
           end                                                as label_name,
       counter                                                as data,
       'NFT'                                                  as wired_type,
       now()                                                  as updated_at,
       't'                                                    as "group",
       case
           when counter >= 155 then 'LONG_TERM_HOLDER'
           when counter >= 1
               and counter < 155 then 'SHORT_TERM_HOLDER' end as level,
       'rank'                                                 as category,
       a2.type                                                as trade_type,
       ''                                                     as project,
       a2.token_name                                          as asset,
       'time'                                                 as bus_type
from (select token,
             address,
             floor((floor( EXTRACT(epoch FROM CAST('${batchDate}' AS TIMESTAMP))) - floor(extract(epoch from nht.latest_tx_time))) /
                   (24 * 3600)) as counter
      from nft_holding_time_temp nht
      where nht.latest_tx_time is not null
        and balance > 0
        and token in (select token_id from dim_project_token_type_rank_temp dpttr)) a1
         inner join
     dim_project_token_type_temp a2
     on
         a1.token = a2.token
where a2.data_subject = 'time_special'
 and a2.wired_type='NFT'
  and counter >= 1
  and counter <= 365
  and (a2.type = ''
    or a2.type = 'ALL')
  and a2.project = ''
  and address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_time_rank' as table_name, '${batchDate}' as batch_date;
