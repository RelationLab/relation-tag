drop table if exists address_label_eth_balance_rank;
CREATE TABLE public.address_label_eth_balance_rank
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
truncate table public.address_label_eth_balance_rank;
vacuum
address_label_eth_balance_rank;

insert into public.address_label_eth_balance_rank(address, label_type, label_name, data, wired_type, updated_at,
                                                  "group", level, category, trade_type, project, asset, bus_type)
select tb1.address,
       tb2.label_type,
       tb2.label_type || '0i' as label_name,
       balance_usd            as data,
       'DEFI'                 as wired_type,
       now()                  as updated_at,
       'b'                    as "group",
       'HIGH_BALANCE'         as level,
       'rank'                 as category,
       'ALL'                     trade_type,
       ''                     as project,
       tb2.token_name         as asset,
       'balance'              as bus_type
from (select t1.address,
             t1.token,
             t1.balance_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.address,
                   a2.token,
                   a2.balance_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.address,
                         a1.token,
                         a1.balance_usd,
                         a1.count_sum,
                         a10.count_sum_total
                  from (select a1.address,
                               a1.token,
                               a1.balance_usd,
                               row_number() over(
				order by
					balance_usd desc,
					address asc) as count_sum
                        from (select s1.token,
                                     s1.address,
                                     sum(s1.balance_usd) as balance_usd
                              from (select token,
                                           address,
                                           balance_usd
                                    from token_balance_volume_usd_temp
                                    where token = 'eth'
                                      and address not in (select address from exclude_address)) s1
                                       inner join dim_rank_token_temp s2
                                                  on
                                                      s1.token = s2.token_id
                              where balance_usd >= 100
                              group by s1.token,
                                       s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd_temp
                        where token = 'eth'
                          and address not in (select address from exclude_address)
                          and balance_usd >= 100) as a10
                       on
                           1 = 1) as a2) as t1) tb1
         inner join
     dim_rule_content_temp tb2
     on
         tb1.token = tb2.token
where tb1.balance_usd >= 100
  and tb1.zb_rate <= 0.1
  and tb2.data_subject = 'balance_rank'
  and tb2.token_type = 'token';
insert into tag_result(table_name, batch_date)
SELECT 'address_label_eth_balance_rank' as table_name, '${batchDate}' as batch_date;
