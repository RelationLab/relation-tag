truncate table public.address_label_univ3_volume_rank;
insert into public.address_label_univ3_volume_rank (address,label_type,label_name,updated_at)
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
                                            s1.token,
                                            s1.address,
                                            sum(s1.volume_usd) as volume_usd
                                        from
                                            (
                                                select
                                                    token,
                                                    address,
                                                    total_transfer_volume_usd as volume_usd
                                                from
                                                    dex_tx_volume_count_summary dtvcs
                                                where
                                                        dtvcs.project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
                                                  and dtvcs.total_transfer_volume_usd >= 100 and address <>'0x000000000000000000000000000000000000dead') s1
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
                                    count(distinct address) as count_sum_total,
                                    token
                                from
                                    (
                                        select
                                            token,
                                            address
                                        from
                                            dex_tx_volume_count_summary dtvcs
                                        where
                                                dtvcs.project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
                                          and dtvcs.total_transfer_volume_usd >= 100  and address <>'0x000000000000000000000000000000000000dead') tbvu2
                                group by
                                    token ) as a10
                            on
                                    a10.token = a1.token) as a2) as t1
    ) tb1
        inner join
    dim_rule_content tb2
    on
            tb1.token = tb2.token
            and tb2.label_type  like 'Uniswap_v3%'
where
        tb1.volume_usd >= 100
  and tb2.data_subject = 'volume_rank'
  and zb_rate <= 0.1;