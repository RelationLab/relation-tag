drop table if exists address_label_nft_volume_rank;
CREATE TABLE public.address_label_nft_volume_rank
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
truncate table public.address_label_nft_volume_rank;
vacuum
address_label_nft_volume_rank;

insert into public.address_label_nft_volume_rank(address, label_type, label_name, data, wired_type, updated_at, "group",
                                                 level, category, trade_type, project, asset, bus_type,
                                                 recent_time_code)
select address,
       label_type,
       label_type || case
                         when zb_rate > 0.01
                             and zb_rate <= 0.025 then '5h'
                         when zb_rate > 0.001
                             and zb_rate <= 0.01 then '5i'
                         when zb_rate > 0.025
                             and zb_rate <= 0.1 then '5g'
                         when zb_rate <= 0.001 then '5j'
           end                                                   as label_name,
       zb_rate                                                   as data,
       'NFT'                                                     as wired_type,
       now()                                                     as updated_at,
       'v'                                                       as "group",
       case
           when zb_rate > 0.01
               and zb_rate <= 0.025 then 'RARE_NFT_TRADER'
           when zb_rate > 0.001
               and zb_rate <= 0.01 then 'EPIC_NFT_TRADER'
           when zb_rate > 0.025
               and zb_rate <= 0.1 then 'UNCOMMON_NFT_TRADER'
           when zb_rate <= 0.001 then 'LEGENDARY_NFT_TRADER' end as level,
       'rank'                                                    as category,
       t.type                                                    as trade_type,
       t.project_name                                            as project,
       t.token_name                                              as asset,
       'volume'                                                  as bus_type,
       recent_time_code
from (select address,
             dptt.label_type as label_type,
             dptt.type       as type,
             ''              as project_name,
             dptt.token_name as token_name,
             zb_rate,
             recent_time_code
      from (select t1.address,
                   t1.seq_flag,
                   t1.type,
                   t1.transfer_volume,
                   t1.count_sum,
                   t1.count_sum_total,
                   t1.zb_rate,
                   recent_time_code
            from (select a2.address,
                         a2.seq_flag,
                         a2.type,
                         a2.transfer_volume,
                         a2.count_sum,
                         a2.count_sum_total,
                         cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                         recent_time_code
                  from (select a1.address,
                               a1.seq_flag,
                               a1.type,
                               a1.transfer_volume,
                               a1.count_sum,
                               a10.count_sum_total,
                               a1.recent_time_code
                        from (select a1.address,
                                     a1.seq_flag,
                                     a1.type,
                                     recent_time_code,
                                     a1.transfer_volume,
                                     row_number() over(partition by seq_flag,type,recent_time_code
					                        order by transfer_volume desc,address asc) as count_sum
                              from (select s1.address,
                                           s2.seq_flag,
                                           s1.type,
                                           sum(transfer_volume) as transfer_volume,
                                           recent_time_code
                                    from (
                                             -- project(null)+nft+type
                                             select address,
                                                    token,
                                                    type,
                                                    transfer_volume,
                                                    recent_time_code
                                             from nft_volume_count_temp
                                             where transfer_volume >= 1
                                               and address not in (select address from exclude_address)
                                               and token in(select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                                             union all
                                             -- project(null)+nft（ALL）+type
                                             select address,
                                                    'ALL' as token,
                                                    type,
                                                    transfer_volume,
                                                    recent_time_code
                                             from nft_volume_count_temp
                                             where transfer_volume >= 1
                                               and address not in (select address from exclude_address)
                                               and token in(select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')) s1
                                             inner join dim_project_token_type_temp s2
                                                        on
                                                                    s1.token = s2.token
                                                                and s1.type = s2.type
                                                                and s2.project = ''
                                                                           and s2.data_subject = 'volume_rank'
                                                                           and s2.wired_type='NFT'
                                                                            and  s1.recent_time_code = s2.recent_code
                                    where
                                        transfer_volume >= 1
                                    group by
                                        s1.address,
                                        s1.type,
                                        s2.seq_flag,
                                        recent_time_code) as a1) as a1
                                 inner join
                             (select count(distinct address) as count_sum_total,
                                     seq_flag,
                                     totala.type,
                                     recent_time_code
                              from (
                                       -- project(null)+nft+type
                                       select address,
                                              token,
                                              type,
                                              recent_time_code
                                       from nft_volume_count_temp
                                       where transfer_volume >= 1
                                         and address not in (select address from exclude_address)
                                         and token in(select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                                       union all
                                       -- project(null)+nft（ALL）+type
                                       select address,
                                              'ALL' as token,
                                              type,
                                              recent_time_code
                                       from nft_volume_count_temp
                                       where transfer_volume >= 1
                                         and address not in (select address from exclude_address)
                                         and token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')) totala
                                       inner join dim_project_token_type_temp tb2
                                                  on
                                                              totala.token = tb2.token
                                                          and totala.type = tb2.type
                                                          and tb2.project = ''
                                                                   and tb2.data_subject = 'volume_rank'
                                                                   and tb2.wired_type='NFT'
                                                                   and  totala.recent_time_code = tb2.recent_code
                              group by
                                  seq_flag,
                                  totala.type,
                                  recent_time_code) as a10
                             on
                                         a10.seq_flag = a1.seq_flag and a10.recent_time_code = a1.recent_time_code
                                     and a10.type = a1.type) as a2) as t1) tb1
               inner join dim_project_token_type_temp dptt on (dptt.seq_flag = tb1.seq_flag
          and dptt.type = tb1.type
          and dptt.project = ''
          and dptt.data_subject = 'volume_rank'
                and dptt.wired_type='NFT')
      where tb1.transfer_volume >= 1
        and zb_rate <= 0.1) t;

drop table if exists address_label_crowd_nft_high_demander;
CREATE TABLE public.address_label_crowd_nft_high_demander
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
);
truncate table public.address_label_crowd_nft_high_demander;
insert into public.address_label_crowd_nft_high_demander(address, label_type, label_name, data, wired_type, updated_at,
                                                         "group", level, category, trade_type, project, asset, bus_type)
select distinct a1.address,
                'cnhd' as label_type,
                'cnhd' as label_name,
                0                         as data,
                'CROWD'                   as wired_type,
                now()                     as updated_at,
                'g'                       as "group",
                'cnhd' as level,
                'other'                   as category,
                'ALL'                     as trade_type,
                'ALL'                     as project,
                'ALL'                     as asset,
                'CROWD'                   as bus_type
from address_label_nft_volume_rank a1
where (
        label_name = 'no0vr5j'
        or label_name = 'no0vr5h'
        or label_name = 'no0vr5g'
        or label_name = 'no0vr5i'
--     label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_RARE_NFT_TRADER'
--     or label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_EPIC_NFT_TRADER'
--     or label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER'
--     or label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER'
    )
  and address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_volume_rank' as table_name, '${batchDate}' as batch_date;