drop table if exists address_label_nft_balance_usd_rank;
CREATE TABLE public.address_label_nft_balance_usd_rank
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
truncate table public.address_label_nft_balance_usd_rank;
vacuum
address_label_nft_balance_usd_rank;

insert into public.address_label_nft_balance_usd_rank(address, label_type, label_name, data, wired_type, updated_at,
                                                      "group", level, category, trade_type, project, asset, bus_type)
select address,
       label_type,
       label_type || case
                         when zb_rate > 0.01
                             and zb_rate <= 0.025 then '4h'
                         when zb_rate > 0.001
                             and zb_rate <= 0.01 then '4i'
                         when zb_rate > 0.025
                             and zb_rate <= 0.1 then '4g'
                         when zb_rate <= 0.001 then '4j'
           end                                                      as label_name,
       zb_rate                                                      as data,
       'NFT'                                                        as wired_type,
       now()                                                        as updated_at,
       'b'                                                          as "group",
       case
           when zb_rate > 0.01
               and zb_rate <= 0.025 then 'RARE_NFT_COLLECTOR'
           when zb_rate > 0.001
               and zb_rate <= 0.01 then 'EPIC_NFT_COLLECTOR'
           when zb_rate > 0.025
               and zb_rate <= 0.1 then 'UNCOMMON_NFT_COLLECTOR'
           when zb_rate <= 0.001 then 'LEGENDARY_NFT_COLLECTOR' end as level,
       'rank'                                                       as category,
       t.type                                                       as trade_type,
       ''                                                           as project,
       t.token_name                                                 as asset,
       'balance'                                                    as bus_type
from (select address,
             dptt.label_type   as label_type,
             dptt.type         as type,
             dptt.project_name as project_name,
             dptt.token_name   as token_name,
             zb_rate
      from (select t1.address,
                   t1.balance,
                   t1.seq_flag,
                   t1.count_sum,
                   t1.count_sum_total,
                   t1.zb_rate
            from (select a2.id,
                         a2.address,
                         a2.seq_flag,
                         a2.balance,
                         a2.count_sum,
                         a2.count_sum_total,
                         cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
                  from (select a1.id,
                               a1.address,
                               a1.seq_flag,
                               a1.balance,
                               a1.count_sum,
                               a10.count_sum_total
                        from (select md5(cast(random() as varchar)) as id,
                                     a1.address,
                                     a1.seq_flag,
                                     a1.balance,
                                     row_number()                      over(partition by seq_flag
					order by
						balance desc,
						address asc) as count_sum
                              from (select s1.address,
                                           s2.seq_flag,
                                           sum(s1.balance) as balance
                                    from (
                                             -- project(null)+nft+type(null)
                                             select address,
                                                    token,
                                                    balance_usd as balance
                                             from nft_balance_usd_temp
                                             where balance_usd >= 100
                                               and address not in (select address from exclude_address)
                                               and token in (select token_id from dim_project_token_type_rank_temp dpttr)

                                             union all
                                             -- project(null)-token(ALL)-type(null)
                                             select address,
                                                    'ALL'       as token,
                                                    balance_usd as balance
                                             from nft_balance_usd_temp
                                             where balance_usd >= 100
                                               and address not in (select address from exclude_address)
                                               and token in (select token_id from dim_project_token_type_rank_temp dpttr)) s1
                                             inner join dim_project_token_type_temp s2
                                                        on
                                                                    s1.token = s2.token
                                                                and s2.project = ''
                                                                and (s2.type = ''
                                                                or s2.type = 'ALL')
                                                                and s2.data_subject = 'balance_rank'
                                                               and s2.wired_type='NFT'
                                    where balance >= 100
                                    group by s1.address,
                                             s2.seq_flag) as a1) as a1
                                 inner join
                             (select count(distinct address) as count_sum_total,
                                     seq_flag
                              from (select address,
                                           token,
                                           balance_usd as balance
                                    from nft_balance_usd_temp
                                    where balance_usd >= 100
                                      and address not in (select address from exclude_address)
                                      and token in (select token_id from dim_project_token_type_rank_temp dpttr)

                                    union all
                                    -- project(null)-token(ALL)-type(null)
                                    select address,
                                           'ALL'       as token,
                                           balance_usd as balance
                                    from nft_balance_usd_temp
                                    where balance_usd >= 100
                                      and address not in (select address from exclude_address)
                                      and token in (select token_id from dim_project_token_type_rank_temp dpttr)) totala
                                       inner join dim_project_token_type_temp tb2
                                                  on
                                                              totala.token = tb2.token
                                                          and tb2.project = ''
                                                          and (tb2.type = ''
                                                          or tb2.type = 'ALL')
                                                          and tb2.data_subject = 'balance_rank'
                                                         and tb2.wired_type='NFT'
                              group by seq_flag) as a10
                             on
                                 a10.seq_flag = a1.seq_flag) as a2) as t1) tb1
               inner join dim_project_token_type_temp dptt on (dptt.seq_flag = tb1.seq_flag
          and dptt.project = ''
          and (dptt.type = ''
              or dptt.type = 'ALL')
          and dptt.data_subject = 'balance_rank'
          and dptt.wired_type='NFT')
      where tb1.balance >= 100
        and zb_rate <= 0.1) t;
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_balance_usd_rank' as table_name, '${batchDate}' as batch_date;
