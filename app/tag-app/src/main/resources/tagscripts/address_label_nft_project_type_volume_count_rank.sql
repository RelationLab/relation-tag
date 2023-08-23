drop table if exists address_label_nft_project_type_volume_count_rank;
CREATE TABLE public.address_label_nft_project_type_volume_count_rank
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
truncate table public.address_label_nft_project_type_volume_count_rank;
vacuum
address_label_nft_project_type_volume_count_rank;

insert into public.address_label_nft_project_type_volume_count_rank(address, label_type, label_name, data, wired_type,
                                                                    updated_at, "group", level, category, trade_type,
                                                                    project, asset, bus_type, recent_time_code)


select address,
       label_type,
       label_type || '5l' as label_name,
       zb_rate            as data,
       'NFT'              as wired_type,
       now()              as updated_at,
       'e'                as "group",
       'ELITE_NFT_TRADER' as level,
       'rank'             as category,
       t.type             as trade_type,
       t.project_name     as project,
       t.token_name       as asset,
       'volume'           as bus_type,
       recent_time_code
from (select address,
             dptt.label_type   as label_type,
             dptt.type         as type,
             dptt.project_name as project_name,
             dptt.token_name   as token_name,
             zb_rate,
             recent_time_code
      from (select t1.address,
                   t1.seq_flag,
                   t1.project,
                   t1.type,
                   t1.volume_usd,
                   t1.count_sum,
                   t1.count_sum_total,
                   t1.zb_rate,
                   t1.zb_rate_transfer_count,
                   recent_time_code
            from (select a2.id,
                         a2.address,
                         a2.seq_flag,
                         a2.project,
                         a2.type,
                         a2.volume_usd,
                         a2.count_sum,
                         a2.count_sum_total,
                         cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8))          as zb_rate,
                         cast(a2.transfer_count_sum as numeric(20, 8)) /
                         cast(a2.count_sum_total as numeric(20, 8))                                                 as zb_rate_transfer_count,
                         recent_time_code
                  from (select a1.id,
                               a1.address,
                               a1.seq_flag,
                               a1.project,
                               a1.type,
                               a1.volume_usd,
                               a1.count_sum,
                               a1.transfer_count_sum,
                               a10.count_sum_total,
                               a1.recent_time_code
                        from (select md5(cast(random() as varchar)) as id,
                                     a1.address,
                                     a1.seq_flag,
                                     a1.project,
                                     a1.type,
                                     a1.volume_usd,
                                     row_number()                      over(partition by seq_flag,project,type,recent_time_code
                                            order by volume_usd desc,address asc) as count_sum, row_number() over(partition by seq_flag,project,type,recent_time_code
                                            order by transfer_count desc,address asc) as transfer_count_sum, recent_time_code
                              from (select s1.address,
                                           seq_flag,
                                           s1.platform_group   as project,
                                           s1.type,
                                           sum(volume_usd)     as volume_usd,
                                           sum(transfer_count) as transfer_count,
                                           recent_time_code
                                    from (
                                             -- project-token-type
                                             select a1.address,
                                                    a1.platform_group,
                                                    a1.platform,
                                                    a1.token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    transfer_count,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = a1.token and
                                                                    a1.platform_group = a2.project
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and address not in (select address from exclude_address)
                                             union all
                                             -- project-token(ALL)-type
                                             select a1.address,
                                                    a1.platform_group,
                                                    a1.platform,
                                                    'ALL'                as token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    transfer_count,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = 'ALL' and a1.platform_group = a2.project
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                        and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and address not in (select address from exclude_address)
                                               and a1.nft_type = 'ERC721'
                                               and a2.nft_type = 'ERC721'
                                             union all
                                             -- project-token(ALL)-type
                                             select a1.address,
                                                    a1.platform_group,
                                                    a1.platform,
                                                    'ALL'                as token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    transfer_count,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = 'ALL' and a1.platform_group = a2.project
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and address not in (select address from exclude_address)
                                               and a1.nft_type = 'ERC721-token'
                                               and a2.nft_type = 'ERC721-token'
                                             union all
                                             -- project(ALL)-token(ALL)-type
                                             select a1.address,
                                                    'ALL'                as platform_group,
                                                    a1.platform,
                                                    'ALL'                as token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    transfer_count,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = 'ALL' and a2.project = 'ALL'
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and address not in (select address from exclude_address)
                                               and a1.nft_type = 'ERC721'
                                             union all
                                             -- project(ALL)-token-type
                                             select a1.address,
                                                    'ALL'                as platform_group,
                                                    a1.platform,
                                                    a1.token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    transfer_count,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = a1.token and a2.project = 'ALL'
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and address not in (select address from exclude_address)) s1
                                    group by s1.address,
                                             seq_flag,
                                             s1.type,
                                             s1.platform_group,
                                             recent_time_code) as a1) as a1
                                 inner join
                             (select count(distinct address) as count_sum_total,
                                     platform_group,
                                     seq_flag,
                                     type,
                                     recent_time_code
                              from (select address,
                                           platform_group,
                                           seq_flag,
                                           totala.type,
                                           sum(volume_usd) as volume_usd,
                                           recent_time_code
                                    from (
                                             -- project-token-type
                                             select a1.address,
                                                    a1.platform_group,
                                                    a1.token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = a1.token and
                                                                    a1.platform_group = a2.project
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and a1.address not in (select address from exclude_address)
                                             union all
                                             -- project-token(ALL)-type
                                             select a1.address,
                                                    a1.platform_group,
                                                    'ALL'                as token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = 'ALL' and a1.platform_group = a2.project
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and a1.address not in (select address from exclude_address)
                                               and a1.nft_type = 'ERC721'
                                               and a2.nft_type = 'ERC721'
                                             union all
                                             -- project-token(ALL)-type
                                             select a1.address,
                                                    a1.platform_group,
                                                    'ALL'                as token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = 'ALL' and a1.platform_group = a2.project
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and a1.address not in (select address from exclude_address)
                                               and a1.nft_type = 'ERC721-token'
                                               and a2.nft_type = 'ERC721-token'
                                             union all
                                             -- project(ALL)-token(ALL)-type
                                             select a1.address,
                                                    'ALL'                as platform_group,
                                                    'ALL'                as token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = 'ALL' and a2.project = 'ALL'
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and a1.address not in (select address from exclude_address)
                                               and a1.nft_type = 'ERC721'
                                             union all
                                             -- project(ALL)-token-type
                                             select a1.address,
                                                    'ALL'                as platform_group,
                                                    a1.token,
                                                    a1.type,
                                                    round(volume_usd, 8) as volume_usd,
                                                    a1.recent_time_code,
                                                    seq_flag
                                             from platform_nft_type_volume_count_temp a1
                                                      inner join dim_project_token_type_temp a2
                                                                 on a2.token = a1.token and a2.project = 'ALL'
                                                                     and a1.type = a2.type and
                                                                    a2.data_subject = 'volume_elite'
                                                                     and a1.recent_time_code = a2.recent_code
                                                                     and a2.wired_type = 'NFT'
                                             where volume_usd >= 100
                                               and a1.address not in (select address from exclude_address)) totala
                                    group by address,
                                             platform_group,
                                             seq_flag,
                                             type,
                                             recent_time_code) pntvc
                              group by platform_group,
                                       seq_flag,
                                       type,
                                       recent_time_code) as a10
                             on
                                         a10.platform_group = a1.project
                                     and a10.seq_flag = a1.seq_flag
                                     and a10.type = a1.type and
                                         a1.recent_time_code = a10.recent_time_code) as a2) as t1) tb1
               inner join dim_project_token_type_temp dptt on (dptt.project = tb1.project
          and dptt."type" = tb1.type
          and dptt.seq_flag = tb1.seq_flag
          and dptt.data_subject = 'volume_elite' and tb1.recent_time_code = dptt.recent_code)
          and dptt.wired_type = 'NFT'
      where zb_rate <= 0.01
        and zb_rate_transfer_count <= 0.01) t;
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_project_type_volume_count_rank' as table_name, '${batchDate}' as batch_date;
