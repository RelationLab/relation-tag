drop table if exists address_label_nft_project_type_volume_count_rank;
CREATE TABLE public.address_label_nft_project_type_volume_count_rank (
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
truncate table public.address_label_nft_project_type_volume_count_rank;
insert into public.address_label_nft_project_type_volume_count_rank(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    address,
    label_type,
    label_type || '_ELITE_NFT_TRADER' as label_name,
    zb_rate  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'e'  as "group",
    'ELITE_NFT_TRADER'    as level,
    'rank' as category,
    t.type as trade_type,
    t.project_name as project,
    t.token_name as asset
from
    (
        select
            address,
            dptt.label_type as label_type,
            dptt.type as type,
            dptt.project_name as project_name,
            dptt.token_name as token_name,
            zb_rate
        from
            (
                select
                    t1.address,
                    t1.seq_flag,
                    t1.project,
                    t1.type,
                    t1.volume_usd,
                    t1.count_sum,
                    t1.count_sum_total,
                    t1.zb_rate,
                    t1.zb_rate_transfer_count
                from
                    (
                        select
                            a2.id,
                            a2.address,
                            a2.seq_flag,
                            a2.project,
                            a2.type,
                            a2.volume_usd,
                            a2.count_sum,
                            a2.count_sum_total,
                            cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                            cast(a2.transfer_count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate_transfer_count
                        from
                            (
                                select
                                    a1.id,
                                    a1.address,
                                    a1.seq_flag,
                                    a1.project,
                                    a1.type,
                                    a1.volume_usd,
                                    a1.count_sum,
                                    a1.transfer_count_sum,
                                    a10.count_sum_total
                                from
                                    (
                                        select
                                            md5(cast(random() as varchar)) as id,
                                            a1.address,
                                            a1.seq_flag,
                                            a1.project,
                                            a1.type,
                                            a1.volume_usd,
                                            row_number() over(partition by seq_flag,
						project,
						type
					order by
						volume_usd desc,
						address asc) as count_sum,
                                                row_number() over(partition by seq_flag,
						project,
						type
					order by
						transfer_count desc,
						address asc) as transfer_count_sum
                                        from
                                            (
                                                select
                                                    s1.address,
                                                    s2.seq_flag,
                                                    s1.platform_group as project,
                                                    s1.type,
                                                    sum(volume_usd) as volume_usd,
                                                    sum(transfer_count) as transfer_count
                                                from
                                                    (
                                                        -- project-token-type
                                                        select
                                                            address,
                                                            platform_group,
                                                            platform,
                                                            token,
                                                            type,
                                                            round(volume_usd,3) as volume_usd,
                                                            transfer_count
                                                        from
                                                            platform_nft_type_volume_count
                                                        where
                                                                volume_usd >= 100 and address <>'0x000000000000000000000000000000000000dead'
                                                        union all
                                                        -- project-token(ALL)-type
                                                        select
                                                            address,
                                                            platform_group,
                                                            platform,
                                                            'ALL' as token,
                                                            type,
                                                            round(volume_usd,3) as volume_usd,
                                                            transfer_count
                                                        from
                                                            platform_nft_type_volume_count
                                                        where
                                                                volume_usd > 0 and address <>'0x000000000000000000000000000000000000dead'
                                                          and token in (select token_id from dim_project_token_type_rank dpttr)
                                                        ) s1
                                                        inner join dim_project_token_type s2
                                                                   on
                                                                               s1.token = s2.token
                                                                           and s1.platform_group = s2.project
                                                                           and s1.type = s2.type
                                                                           and s2.data_subject = 'volume_elite'
                                                where
                                                        volume_usd >= 100
                                                group by
                                                    s1.address,
                                                    s2.seq_flag,
                                                    s1.type,
                                                    s1.platform_group) as a1) as a1
                                        inner join
                                    (
                                        select
                                            count(distinct address) as count_sum_total,
                                            platform_group,
                                            seq_flag,
                                            type
                                        from
                                            (
                                                select
                                                    address,
                                                    platform_group,
                                                    seq_flag,
                                                    totala.type,
                                                    sum(volume_usd) as volume_usd
                                                from
                                                    (
                                                        -- project-token-type
                                                        select
                                                            address,
                                                            platform_group,
                                                            token,
                                                            type,
                                                            round(volume_usd,3) as volume_usd
                                                        from
                                                            platform_nft_type_volume_count
                                                        where
                                                                volume_usd >= 100 and address <>'0x000000000000000000000000000000000000dead'
                                                        union all
                                                        -- project-token(ALL)-type
                                                        select
                                                            address,
                                                            platform_group,
                                                            'ALL' as token,
                                                            type,
                                                            round(volume_usd,3) as volume_usd
                                                        from
                                                            platform_nft_type_volume_count
                                                        where
                                                                volume_usd >0 and address <>'0x000000000000000000000000000000000000dead'
                                                          and token in (select token_id from dim_project_token_type_rank dpttr)
                                                    ) totala
                                                        inner join
                                                    dim_project_token_type tb2
                                                    on
                                                                totala.token = tb2.token
                                                            and totala.platform_group = tb2.project
                                                            and totala.type = tb2.type
                                                group by
                                                    address,
                                                    platform_group,
                                                    seq_flag,
                                                    totala.type) pntvc
                                        where
                                                volume_usd >= 100
                                        group by
                                            platform_group,
                                            seq_flag,
                                            type) as a10
                                    on
                                                a10.platform_group = a1.project
                                            and a10.seq_flag = a1.seq_flag
                                            and a10.type = a1.type) as a2) as t1
            ) tb1 inner join dim_project_token_type dptt on(dptt.project = tb1.project
                and dptt."type" = tb1.type
                and dptt.seq_flag = tb1.seq_flag
                and dptt.data_subject = 'volume_elite')
        where
                tb1.volume_usd >= 100
          and zb_rate <= 0.01
          and zb_rate_transfer_count <= 0.01) t;