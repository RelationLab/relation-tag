drop table if exists address_label_nft_volume_grade;
CREATE TABLE public.address_label_nft_volume_grade
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
truncate table public.address_label_nft_volume_grade;
vacuum
address_label_nft_volume_grade;

insert into public.address_label_nft_volume_grade(address, label_type, label_name, data, wired_type, updated_at,
                                                  "group", level, category, trade_type, project, asset, bus_type,
                                                  recent_time_code)
select address,
       label_type,
       label_type || case
                         when volume_usd >= 1
                             and volume_usd < 3 then '5a'
                         when volume_usd >= 3
                             and volume_usd < 7 then '5b'
                         when volume_usd >= 7
                             and volume_usd < 21 then '5c'
                         when volume_usd >= 21
                             and volume_usd < 101 then '5d'
                         when volume_usd >= 101
                             and volume_usd < 201 then '5e'
                         when volume_usd >= 201 then '5f'
           end                                  as label_name,
       volume_usd                               as data,
       'NFT'                                    as wired_type,
       now()                                    as updated_at,
       'v'                                      as "group",
       case
           when volume_usd >= 1
               and volume_usd < 3 then 'L1'
           when volume_usd >= 3
               and volume_usd < 7 then 'L2'
           when volume_usd >= 7
               and volume_usd < 21 then 'L3'
           when volume_usd >= 21
               and volume_usd < 101 then 'L4'
           when volume_usd >= 101
               and volume_usd < 201 then 'L5'
           when volume_usd >= 201 then 'L6' end as level,
       'grade'                                  as category,
       t.type                                   as trade_type,
       t.project_name                           as project,
       t.token_name                             as asset,
       'volume'                                 as bus_type,
       recent_time_code
from (
         -- project(null)+nft+type
         select a1.address,
                a2.label_type,
                a2.type,
                ''                   as project_name,
                a2.token_name,
                sum(transfer_volume) as volume_usd,
                recent_time_code
         from nft_volume_count_temp a1
                  inner join dim_project_token_type_temp a2
                             on
                                         a1.token = a2.token
                                     and a2.project = ''
                                     and a1.type = a2.type
                                      and a2.wired_type = 'NFT'
                                   and  a1.recent_time_code = a2.recent_code
		and
                                a2.data_subject = 'volume_grade'
         where a1.token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
         group by
             a1.address,
             a2.label_type,
             a2.type,
             a2.project_name,
             a2.token_name,
             recent_time_code
         union all
         -- project(null)+nft（ALL）+type
         select
             a1.address, a2.label_type, a2.type, '' as project_name, a2.token_name, sum (transfer_volume) as volume_usd, recent_time_code
         from
             nft_volume_count_temp a1
             inner join dim_project_token_type_temp a2
         on
             a2.token = 'ALL'
             and a2.project = ''
             and a1.type = a2.type
             and a2.data_subject = 'volume_grade'
             and a2.wired_type = 'NFT'
             and a1.recent_time_code = a2.recent_code
         where a1.token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
         group by
             a1.address,
             a2.label_type,
             a2.type,
             a2.project_name,
             a2.token_name,
             recent_time_code) t
where volume_usd >= 1
  and address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_volume_grade' as table_name, '${batchDate}' as batch_date;
