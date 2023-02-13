truncate  table public.address_label_nft_volume_rank;
insert into public.address_label_nft_volume_rank(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    address ,
    label_type,
    label_type || '_' || case
                             when zb_rate > 0.01
                                 and zb_rate <= 0.025 then 'RARE_NFT_TRADER'
                             when zb_rate > 0.001
                                 and zb_rate <= 0.01 then 'EPIC_NFT_TRADER'
                             when zb_rate > 0.025
                                 and zb_rate <= 0.1 then 'UNCOMMON_NFT_TRADER'
                             when zb_rate <= 0.001 then 'LEGENDARY_NFT_TRADER'
        end as label_name,
    zb_rate  as `data`,
    now() as updated_at
    from
    (
        select
            address,
            (
                select
                    distinct  label_type
                from
                    dim_project_token_type dptt
                where
                        dptt.seq_flag = tb1.seq_flag
                  and dptt.type = tb1.type
                  and (dptt.project = ''
                    or dptt.project = 'ALL')
                  and dptt.data_subject = 'volume_rank'
                  and dptt.label_type like '%NFT%'
                  and dptt.label_type not like '%WEB3%') as label_type,
            zb_rate
        from
            (
                select
                    t1.address,
                    t1.seq_flag,
                    t1.type,
                    t1.transfer_volume,
                    t1.count_sum,
                    t1.count_sum_total,
                    t1.zb_rate
                from
                    (
                        select
                            a2.address,
                            a2.seq_flag,
                            a2.type,
                            a2.transfer_volume,
                            a2.count_sum,
                            a2.count_sum_total,
                            cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
                        from
                            (
                                select
                                    a1.address,
                                    a1.seq_flag,
                                    a1.type,
                                    a1.transfer_volume,
                                    a1.count_sum,
                                    a10.count_sum_total
                                from
                                    (
                                        select
                                            a1.address,
                                            a1.seq_flag,
                                            a1.type,
                                            a1.transfer_volume,
                                            row_number() over(partition by seq_flag,
						type
					order by
						transfer_volume desc,
						address asc) as count_sum
                                        from
                                            (
                                                select
                                                    s1.address,
                                                    s2.seq_flag,
                                                    s1.type,
                                                    sum(transfer_volume) as transfer_volume
                                                from
                                                    (
                                                        -- project(null)+nft+type
                                                        select
                                                            address,
                                                            token,
                                                            type,
                                                            transfer_volume
                                                        from
                                                            nft_volume_count
                                                        where
                                                                transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
                                                        union all
                                                        -- project(null)+nft（ALL）+type
                                                        select
                                                            address,
                                                            'ALL' as token,
                                                            type,
                                                            transfer_volume
                                                        from
                                                            nft_volume_count
                                                        where
                                                                transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead') s1
                                                        inner join dim_project_token_type s2
                                                                   on
                                                                               s1.token = s2.token
                                                                           and s1.type = s2.type
                                                                           and (s2.project = ''
                                                                           or s2.project = 'ALL')
                                                                           and s2.data_subject = 'volume_rank'
                                                                           and s2.label_type like '%NFT%'
                                                                           and s2.label_type not like '%WEB3%'
                                                where
                                                        transfer_volume >= 1
                                                group by
                                                    s1.address,
                                                    s1.type,
                                                    s2.seq_flag) as a1) as a1
                                        inner join
                                    (
                                        select
                                            count(distinct address) as count_sum_total,
                                            seq_flag,
                                            totala.type
                                        from
                                            (
                                                -- project(null)+nft+type
                                                select
                                                    address,
                                                    token,
                                                    type
                                                from
                                                    nft_volume_count
                                                where
                                                        transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
                                                union all
                                                -- project(null)+nft（ALL）+type
                                                select
                                                    address,
                                                    'ALL' as token,
                                                    type
                                                from
                                                    nft_volume_count
                                                where
                                                        transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead') totala
                                                inner join dim_project_token_type tb2
                                                           on
                                                                       totala.token = tb2.token
                                                                   and totala.type = tb2.type
                                                                   and (tb2.project = ''
                                                                   or tb2.project = 'ALL')
                                                                   and tb2.data_subject = 'volume_rank'
                                                                   and tb2.label_type like '%NFT%'
                                                                   and tb2.label_type not like '%WEB3%'
                                        group by
                                            seq_flag,
                                            totala.type ) as a10
                                    on
                                                a10.seq_flag = a1.seq_flag
                                            and a10.type = a1.type) as a2) as t1
            ) tb1
        where
                tb1.transfer_volume >= 1
          and zb_rate <= 0.1) t ) atb;