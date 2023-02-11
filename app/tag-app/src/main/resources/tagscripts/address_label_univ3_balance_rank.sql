truncate table public.address_label_univ3_balance_rank;
insert into public.address_label_univ3_balance_rank (address,label_type,label_name,data,updated_at)
    select
    tb1.address ,
    tb2.label_type,
    tb2.label_type || '_' || 'HIGH_BALANCE' as label_name,
    zb_rate,
    now() as updated_at
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
                                            s1.token,
                                            s1.address,
                                            sum(s1.balance_usd) as balance_usd
                                        from
                                            (
                                                select
                                                    token,
                                                    address,
                                                    balance_usd
                                                from
                                                    dex_tx_volume_count_summary
                                                where
                                                        project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
                                                  and balance_usd >= 100
                                                  and type = 'lp' and address <>'0x000000000000000000000000000000000000dead') s1
                                                inner join dim_rank_token s2
                                                           on
                                                                   s1.token = s2.token_id
                                        where
                                                balance_usd >= 100
                                        group by
                                            s1.token,
                                            s1.address) as a1) as a1
                                inner join
                            (
                                select
                                    count(distinct address) as count_sum_total,
                                    token
                                from
                                    (
                                        select
                                            token,
                                            address
                                        from
                                            dex_tx_volume_count_summary
                                        where
                                                project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
                                          and balance_usd >= 100
                                          and type = 'lp'  and address <>'0x000000000000000000000000000000000000dead') tbvu2
                                group by
                                    token) as a10
                            on
                                    a10.token = a1.token) as a2) as t1
    ) tb1
        inner join
    dim_rule_content tb2
    on
            tb1.token = tb2.token
            and tb2.label_type  like 'Uniswap_v3%'
    where
        tb1.balance_usd >= 100
  and tb1.zb_rate <= 0.1
  and tb2.data_subject = 'balance_rank';