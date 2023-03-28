drop table if exists address_label_token_balance_rank_all;
CREATE TABLE public.address_label_token_balance_rank_all (
                                                             address varchar(512) NULL,
                                                             data numeric(250, 20) NULL,
                                                             wired_type varchar(20) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL,
                                                             "group" varchar(1) NULL,
                                                             "level" varchar(80) NULL,
                                                             category varchar(80) NULL,
                                                             trade_type varchar(80) NULL,
                                                             project varchar(80) NULL,
                                                             asset varchar(80) NULL,
                                                             bus_type varchar(20) NULL
);
truncate table public.address_label_token_balance_rank_all;
insert into public.address_label_token_balance_rank_all(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
    select
    tb1.address,
    tb2.label_type,
    tb2.label_type || '_' || 'HIGH_BALANCE' as label_name,
    tb1.zb_rate  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    'HIGH_BALANCE'  as level,
    'rank'  as category,
    'ALL' trade_type,
    '' as project,
    'ALL' as asset,
    'balance' as bus_type
    from
    (
        select
            t1.address,
            t1.token,
            t1.balance_usd,
            t1.count_sum,
            t1.count_sum_total,
            t1.zb_rate
        from
            (
                select
                    a2.address,
                    a2.token,
                    a2.balance_usd,
                    a2.count_sum,
                    a2.count_sum_total,
                    cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
                from
                    (
                        select
                            a1.address,
                            a1.token,
                            a1.balance_usd,
                            a1.count_sum,
                            a10.count_sum_total
                        from
                            (
                                select
                                    a1.address,
                                    a1.token,
                                    a1.balance_usd,
                                    row_number() over(partition by token
				order by
					balance_usd desc,
					address asc) as count_sum
                                from
                                    (
                                        select
                                            'ALL' token,
                                            s1.address,
                                            sum(round(s1.balance_usd,3)) as balance_usd
                                        from
                                            total_balance_volume_usd s1  where address <>'0x000000000000000000000000000000000000dead'
                                        group by
                                            s1.address) as a1
                                where
                                        a1.balance_usd >100) as a1
                                inner join
                            (
                                select
                                    count(distinct address) as count_sum_total,
                                    token
                                from
                                    (
                                        select
                                            'ALL' token,
                                            address
                                        from
                                            total_balance_volume_usd
                                        where
                                                balance_usd>100 and address <>'0x000000000000000000000000000000000000dead') tbvu
                                group by
                                    token
                            ) as a10
                            on
                                    a10.token = a1.token) as a2) as t1

    ) tb1
        inner join
    dim_rule_content tb2
    on
            tb1.token = tb2.token
    where
        tb1.balance_usd >= 100
  and tb1.zb_rate <= 0.1
  and tb2.data_subject = 'balance_rank'
  and tb2.token_type = 'token';
