drop table if exists address_label_eth_volume_rank;
CREATE TABLE public.address_label_eth_volume_rank (
                                                      address varchar(512) NULL,
                                                      data numeric(250, 20) NULL,
                                                      wired_type varchar(20) NULL,
                                                      label_type varchar(512) NULL,
                                                      label_name varchar(1024) NULL,
                                                      updated_at timestamp(6) NULL,
    "group" varchar(1) NULL,
    "level" varchar(50) NULL,
    category varchar(50) NULL,
    trade_type varchar(50) NULL,
    project varchar(50) NULL,
    asset varchar(50) NULL,
                                                      bus_type varchar(20) NULL
);
truncate table public.address_label_eth_volume_rank;
insert into public.address_label_eth_volume_rank(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
 select
    tb1.address,
    tb2.label_type,
    tb2.label_type || '_' || case
                                 when zb_rate > 0.01
                                     and zb_rate <= 0.025 then 'HEAVY'
                                 when zb_rate > 0.001
                                     and zb_rate <= 0.01 then 'ELITE'
                                 when zb_rate > 0.025
                                     and zb_rate <= 0.1 then 'MEDIUM'
                                 when zb_rate <= 0.001 then 'LEGENDARY'
        end as label_name,
    zb_rate  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'v'  as "group",
    case
    when zb_rate > 0.01
    and zb_rate <= 0.025 then 'HEAVY'
    when zb_rate > 0.001
    and zb_rate <= 0.01 then 'ELITE'
    when zb_rate > 0.025
    and zb_rate <= 0.1 then 'MEDIUM'
    when zb_rate <= 0.001 then 'LEGENDARY' end as level,
    'rank' as category,
    'all' trade_type,
    'all' as project,
    tb2.token_name as asset
    from
    (
        select
            t1.address,
            t1.token,
            t1.volume_usd,
            t1.count_sum,
            t1.count_sum_total,
            t1.zb_rate
        from
            (
                select
                    a2.address,
                    a2.token,
                    a2.volume_usd,
                    a2.count_sum,
                    a2.count_sum_total,
                    cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
                from
                    (
                        select
                            a1.address,
                            a1.token,
                            a1.volume_usd,
                            a1.count_sum,
                            a10.count_sum_total
                        from
                            (
                                select
                                    a1.address,
                                    a1.token,
                                    a1.volume_usd,
                                    row_number() over(
				order by
					volume_usd desc,
					address asc) as count_sum
                                from
                                    (
                                        select
                                            s1.token,
                                            s1.address,
                                            sum(s1.volume_usd) as volume_usd
                                        from
                                            (
                                                select
                                                    token,
                                                    address,
                                                    round(volume_usd,3) volume_usd
                                                from
                                                    token_volume_usd
                                                where
                                                        token = 'eth'and address <>'0x000000000000000000000000000000000000dead'
                                                  and volume_usd >= 100) s1
                                                inner join dim_rank_token s2
                                                           on
                                                                   s1.token = s2.token_id
                                        where
                                                volume_usd >= 100
                                        group by
                                            s1.token,
                                            s1.address) as a1) as a1
                                inner join
                            (
                                select
                                    count(distinct address) as count_sum_total
                                from
                                    token_volume_usd
                                where
                                        token = 'eth'and address <>'0x000000000000000000000000000000000000dead'
                                  and volume_usd >= 100) as a10
                            on
                                    1 = 1) as a2) as t1) tb1
        inner join
    dim_rule_content tb2
    on
            tb1.token = tb2.token
    where
        tb1.volume_usd >= 100
  and tb2.data_subject = 'volume_rank'
  and tb2.token_type = 'token'
  and zb_rate <= 0.1 ;