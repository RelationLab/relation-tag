drop table if exists address_label_nft_balance_rank;
CREATE TABLE public.address_label_nft_balance_rank
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
truncate table public.address_label_nft_balance_rank;
vacuum
address_label_nft_balance_rank;

insert into public.address_label_nft_balance_rank(address, label_type, label_name, data, wired_type, updated_at,
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
                                             select a1.address,
                                                    a1.token,
                                                    a1.balance
                                             from nft_holding_temp a1
                                                      inner join dim_project_token_type_rank_temp a2 on (a1.token = a2.token_id)
                                             where balance >= 1
                                               and address not in (select address from exclude_address)
                                               and recent_time_code = 'ALL'
                                             union all
                                             -- project(null)-token(ALL)-type(null)
                                             select a1.address,
                                                    'ALL' as token,
                                                    a1.balance
                                             from nft_holding_temp a1
                                                      inner join dim_project_token_type_rank_temp a2 on (a1.token = a2.token_id)
                                             where balance >= 1
                                               and address not in (select address from exclude_address)
                                               and recent_time_code = 'ALL') s1
                                             inner join dim_project_token_type_temp s2
                                                        on
                                                                    s1.token = s2.token
                                                                and s2.project = ''
                                                                and (s2.type = ''
                                                                or s2.type = 'ALL')
                                                                and s2.data_subject = 'balance_rank'
                                                                and s2.label_type like '%NFT%'
                                                                and s2.label_type not like '%WEB3%'
                                    where balance >= 1
                                    group by s1.address,
                                             s2.seq_flag) as a1) as a1
                                 inner join
                             (select count(distinct address) as count_sum_total,
                                     seq_flag
                              from (select a1.address,
                                           a1.token,
                                           a1.balance
                                    from nft_holding_temp a1
                                             inner join dim_project_token_type_rank_temp a2 on (a1.token = a2.token_id)
                                    where balance >= 1
                                      and address not in (select address from exclude_address)
                                      and recent_time_code = 'ALL'
                                    union all
                                    -- project(null)-token(ALL)-type(null)
                                    select a1.address,
                                           'ALL' as token,
                                           a1.balance
                                    from nft_holding_temp a1
                                             inner join dim_project_token_type_rank_temp a2 on (a1.token = a2.token_id)
                                    where balance >= 1
                                      and address not in (select address from exclude_address)
                                      and recent_time_code = 'ALL') totala
                                       inner join dim_project_token_type_temp tb2
                                                  on
                                                              totala.token = tb2.token
                                                          and tb2.project = ''
                                                          and (tb2.type = ''
                                                          or tb2.type = 'ALL')
                                                          and tb2.data_subject = 'balance_rank'
                                                          and tb2.label_type like '%NFT%'
                                                          and tb2.label_type not like '%WEB3%'
                              group by seq_flag) as a10
                             on
                                 a10.seq_flag = a1.seq_flag) as a2) as t1) tb1
               inner join dim_project_token_type_temp dptt on (dptt.seq_flag = tb1.seq_flag
          and dptt.project = ''
          and (dptt.type = ''
              or dptt.type = 'ALL')
          and dptt.data_subject = 'balance_rank'
          and dptt.label_type like '%NFT%'
          and dptt.label_type not like '%WEB3%')
      where tb1.balance >= 1
        and zb_rate <= 0.1) t;

drop table if exists address_label_crowd_nft_whale;
CREATE TABLE public.address_label_crowd_nft_whale
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
truncate table public.address_label_crowd_nft_whale;
insert into public.address_label_crowd_nft_whale(address, label_type, label_name, data, wired_type, updated_at, "group",
                                                 level, category, trade_type, project, asset, bus_type)
select distinct a1.address,
                'cnw' as label_type,
                'cnw' as label_name,
                0                 as data,
                'CROWD'           as wired_type,
                now()             as updated_at,
                'g'               as "group",
                'cnw' as level,
                'other'           as category,
                'ALL'             as trade_type,
                'ALL'             as project,
                'ALL'             as asset,
                'CROWD'           as bus_type
from (select address
      from address_label_nft_balance_rank
      where  label_name = 'nbr4j'
         or label_name = 'nbr4i'
         or label_name = 'nbr4g'
         or label_name = 'nbr4h'
--           label_name = 'ALL_NFT_BALANCE_RANK_RARE_NFT_COLLECTOR'
--          or label_name = 'ALL_NFT_BALANCE_RANK_UNCOMMON_NFT_COLLECTOR'
--          or label_name = 'ALL_NFT_BALANCE_RANK_EPIC_NFT_COLLECTOR'
--          or label_name = 'ALL_NFT_BALANCE_RANK_LEGENDARY_NFT_COLLECTOR'
      union all
      select address
      from address_label_nft_balance_top) a1
where address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_balance_rank' as table_name, '${batchDate}' as batch_date;
