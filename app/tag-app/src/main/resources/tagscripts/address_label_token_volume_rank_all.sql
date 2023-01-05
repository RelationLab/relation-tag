truncate table public.address_label_token_volume_rank_all;
insert into public.address_label_token_volume_rank_all (address,label_type,label_name,updated_at)
    select
    tb1.address,
    tb2.label_type,
    tb2.label_type || '_' || case
                                 when zb_rate > 0.025
                                     and zb_rate <= 0.1 then 'MEDIUM'
                                 when zb_rate > 0.01
                                     and zb_rate <= 0.025 then 'HEAVY'
                                 when zb_rate > 0.001
                                     and zb_rate <= 0.01 then 'ELITE'
                                 when zb_rate <= 0.001 then 'LEGENDARY'
        end as label_name,
    now() as updated_at
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
                                    row_number() over(partition by token
				order by
					volume_usd desc,
					address asc) as count_sum
                                from
                                    (
                                        select
                                            'ALL' token,
                                            s1.address,
                                            s1.volume_usd
                                        from
                                            total_volume_usd s1
                                        where
                                                volume_usd >0 and address <>'0x000000000000000000000000000000000000dead') as a1) as a1
                                inner join
                            (
                                select
                                    count(distinct address) as count_sum_total,
                                    token
                                from
                                    (
                                        select
                                            token,
                                            address,
                                            sum(volume_usd) as volume_usd
                                        from
                                            (
                                                select
                                                    'ALL' token,
                                                    address,
                                                    volume_usd
                                                from
                                                    total_volume_usd
                                                where
                                                        volume_usd >= 100 and address <>'0x000000000000000000000000000000000000dead') totala
                                        group by
                                            token,
                                            address) tbvu
                                where
                                        volume_usd >= 100
                                group by
                                    token) as a10
                            on
                                    a10.token = a1.token) as a2) as t1) tb1
        inner join
    dim_rule_content tb2
    on
            tb1.token = tb2.token
    where
        tb1.volume_usd >= 100
  and tb2.data_subject = 'volume_rank'
  and tb2.token_type = 'token'
  and zb_rate <= 0.1;