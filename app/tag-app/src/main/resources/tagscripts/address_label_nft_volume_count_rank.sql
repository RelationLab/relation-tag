drop table if exists address_label_nft_volume_count_rank;
CREATE TABLE public.address_label_nft_volume_count_rank
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
truncate table public.address_label_nft_volume_count_rank;
vacuum
address_label_nft_volume_count_rank;

insert into public.address_label_nft_volume_count_rank(address, label_type, label_name, data, wired_type, updated_at,
                                                       "group", level, category, trade_type, project, asset, bus_type,
                                                       recent_time_code)
select address,
       label_type,
       label_type || '5l' as label_name,
       zb_rate            as data,
       'NFT'              as wired_type,
       now()              as updated_at,
       'e'                as "group",
       'ELITE_NFT_TRADER' as level,
       'top'              as category,
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
                   t1.type,
                   t1.transfer_volume,
                   t1.count_sum,
                   t1.count_sum_total,
                   t1.zb_rate,
                   t1.zb_rate_transfer_count,
                   recent_time_code
            from (select a2.address,
                         a2.seq_flag,
                         a2.type,
                         a2.transfer_volume,
                         a2.count_sum,
                         a2.count_sum_total,
                         recent_time_code,
                         cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8))          as zb_rate,
                         cast(a2.transfer_count_sum as numeric(20, 8)) /
                         cast(a2.count_sum_total as numeric(20, 8))                                                 as zb_rate_transfer_count
                  from (select a1.address,
                               a1.seq_flag,
                               a1.type,
                               a1.transfer_volume,
                               a1.count_sum,
                               a1.transfer_count_sum,
                               a10.count_sum_total,
                               a1.recent_time_code
                        from (select a1.address,
                                     a1.seq_flag,
                                     a1.type,
                                     recent_time_code,
                                     a1.transfer_volume,
                                     a1.transfer_count,
                                     row_number() over(partition by seq_flag,type,recent_time_code
					                        order by transfer_volume desc,address asc) as count_sum, row_number() over(partition by seq_flag,type,recent_time_code
                                            order by transfer_count desc,address asc) as transfer_count_sum
                              from (select s1.address,
                                           s2.seq_flag,
                                           s1.type,
                                           sum(transfer_volume) as transfer_volume,
                                           sum(transfer_count)  as transfer_count,
                                           recent_time_code
                                    from (
                                             -- project(null)+nft+type
                                             select address,
                                                    token,
                                                    type,
                                                    transfer_volume,
                                                    transfer_count,
                                                    recent_time_code
                                             from nft_volume_count_temp
                                             where transfer_volume > 0
                                               and address not in (select address from exclude_address)
                                               and token in(select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                                             union all
                                             -- project(null)+nft（ALL）+type
                                             select address,
                                                    'ALL' as token,
                                                    type,
                                                    transfer_volume,
                                                    transfer_count,
                                                    recent_time_code
                                             from nft_volume_count_temp
                                             where transfer_volume > 0
                                               and address not in (select address from exclude_address)
                                               and token in(select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')) s1
                                             inner join dim_project_token_type_temp s2 on
                                                s1.token = s2.token
                                            and s1.type = s2.type
                                            and s2.project = ''
                                                            and s2.data_subject = 'volume_elite'
                                                            and s2.wired_type='NFT'
                                    where
                                        transfer_volume >= 1
                                    group by
                                        s1.address,
                                        s1.type,
                                        s2.seq_flag,
                                        recent_time_code) as a1) as a1
                                 inner join (select count(distinct address) as count_sum_total,
                                                    seq_flag,
                                                    tb2.type,
                                                    recent_time_code
                                             from (
                                                      -- project(null)+nft+type
                                                      select address,
                                                             token,
                                                             type,
                                                             recent_time_code
                                                      from nft_volume_count_temp
                                                      where transfer_volume > 0
                                                        and address not in (select address from exclude_address)
                                                        and token in(select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                                                      union all
                                                      -- project(null)+nft（ALL）+type
                                                      select address,
                                                             'ALL' as token,
                                                             type,
                                                             recent_time_code
                                                      from nft_volume_count_temp
                                                      where transfer_volume > 0
                                                        and address not in (select address from exclude_address)
                                                        and token in(select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')) totala
                                                      inner join dim_project_token_type_temp tb2 on
                                                         totala.token = tb2.token
                                                     and totala.type = tb2.type
                                                     and tb2.project = ''
                                                    and tb2.data_subject = 'volume_elite'
                                            and tb2.wired_type='NFT'
                                                    and  totala.recent_time_code = tb2.recent_code

                                             group by
                                                 seq_flag,
                                                 tb2.type,
                                                 recent_time_code) as a10 on
                                    a10.seq_flag = a1.seq_flag and a10.recent_time_code = a1.recent_time_code
                                and a10.type = a1.type) as a2) as t1) tb1
               inner join dim_project_token_type_temp dptt
                          on (dptt.seq_flag = tb1.seq_flag
                              and dptt.type = tb1.type
                              and dptt.project = ''
                              and dptt.data_subject = 'volume_elite'
                             and dptt.wired_type='NFT'
    and  tb1.recent_time_code = dptt.recent_code)
      where tb1.transfer_volume >= 1
        and zb_rate <= 0.01
        and zb_rate_transfer_count <= 0.01) t;
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_volume_count_rank' as table_name, '${batchDate}' as batch_date;
