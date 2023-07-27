drop table if exists address_label_nft_transfer_volume_count_rank;
CREATE TABLE public.address_label_nft_transfer_volume_count_rank (
                                                                     address varchar(512) NULL,
                                                                     data numeric(250, 20) NULL,
                                                                     wired_type varchar(20) NULL,
                                                                     label_type varchar(512) NULL,
                                                                     label_name varchar(1024) NULL,
                                                                     updated_at timestamp(6) NULL,
                                                                     "group" varchar(1) NULL,
                                                                     "level" varchar(100) NULL,
                                                                     category varchar(100) NULL,
                                                                     trade_type varchar(100) NULL,
                                                                     project varchar(100) NULL,
                                                                     asset varchar(100) NULL,
                                                                     bus_type varchar(20) NULL
);
truncate table public.address_label_nft_transfer_volume_count_rank;
vacuum address_label_nft_transfer_volume_count_rank;

insert into public.address_label_nft_transfer_volume_count_rank(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    address ,
    label_type,
    label_type || '_ELITE_NFT_TRADER' as label_name,
    zb_rate  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'e'  as "group",
    'ELITE_NFT_TRADER'      as level,
    'rank' as category,
    t.type as trade_type,
    '' as project ,
    t.token_name as asset,
    'volume' as bus_type
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
                    t1.total_transfer_volume,
                    t1.count_sum,
                    t1.count_sum_total,
                    t1.zb_rate,
                    t1.zb_rate_transfer_count,
                    recent_time_code
                from
                    (
                        select
                            a2.address,
                            a2.seq_flag,
                            a2.total_transfer_volume,
                            a2.count_sum,
                            a2.count_sum_total,
                            cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                            cast(a2.transfer_count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate_transfer_count,
                            recent_time_code
                        from
                            (
                                select
                                    a1.address,
                                    a1.seq_flag,
                                    a1.total_transfer_volume,
                                    a1.count_sum,
                                    a1.transfer_count_sum,
                                    a10.count_sum_total,
                                    a1.recent_time_code
                                from
                                    (
                                        select
                                            a1.address,
                                            a1.seq_flag,
                                            a1.total_transfer_volume,
                                            row_number() over(partition by seq_flag,a1.recent_time_code
					    order by total_transfer_volume desc,address asc) as count_sum,
                                                row_number() over(partition by seq_flag,a1.recent_time_code
					    order by total_transfer_count desc,address asc) as transfer_count_sum,
                                                a1.recent_time_code
                                        from
                                            (
                                                select
                                                    s1.address,
                                                    s2.seq_flag,
                                                    sum(s1.total_transfer_volume) as total_transfer_volume,
                                                    sum(s1.total_transfer_count) as total_transfer_count,
                                                    recent_time_code
                                                from
                                                    (
                                                        -- project-token-type
                                                        select
                                                            address,
                                                            token,
                                                            total_transfer_volume,
                                                            total_transfer_count,
                                                            recent_time_code
                                                        from
                                                            nft_transfer_holding
                                                        where
                                                                total_transfer_volume >= 1 and address not in (select address from exclude_address)
                                                          and token in (select token_id from dim_project_token_type_rank dpttr)
                                                        union all
                                                        -- project(null)+nft（ALL）+type
                                                        select
                                                            address,
                                                            'ALL' as token,
                                                            total_transfer_volume,
                                                            total_transfer_count,
                                                            recent_time_code
                                                        from
                                                            nft_transfer_holding
                                                        where
                                                                total_transfer_volume >= 1
                                                          and address not in (select address from exclude_address)
                                                          and token in (select token_id from dim_project_token_type_rank dpttr)
                                                    ) s1
                                                        inner join dim_project_token_type s2
                                                                   on
                                                                               s1.token = s2.token
                                                                           and s2.type = 'Transfer'
                                                                           and (s2.project = ''
                                                                           or s2.project = 'ALL')
                                                                           and s2.type = 'Transfer'
                                                                           and (s2.project = ''
                                                                           or s2.project = 'ALL')
                                                                           and s2.data_subject = 'volume_elite'
                                                                           and s2.label_type like '%NFT%'
                                                                           and s2.label_type not like '%WEB3%'
                                                                           and  s1.recent_time_code = s2.recent_code
                                                where
                                                        total_transfer_volume >= 1
                                                group by
                                                    s1.address,
                                                    s1.recent_time_code,
                                                    s2.seq_flag) as a1) as a1
                                        inner join
                                    (
                                        select
                                            count(distinct address) as count_sum_total ,
                                            seq_flag,
                                            recent_time_code
                                        from
                                            (
                                                -- project-token-type
                                                select
                                                    address,
                                                    token,
                                                    recent_time_code
                                                from
                                                    nft_transfer_holding
                                                where
                                                        total_transfer_volume >= 1 and address not in (select address from exclude_address)
                                                  and token in (select token_id from dim_project_token_type_rank dpttr)
                                                union all
                                                -- project(null)+nft（ALL）+type
                                                select
                                                    address,
                                                    'ALL' as token,
                                                    recent_time_code
                                                from
                                                    nft_transfer_holding
                                                where
                                                        total_transfer_volume >= 1
                                                  and address not in (select address from exclude_address)
                                                  and token in (select token_id from dim_project_token_type_rank dpttr)
                                            ) totala
                                                inner join
                                            dim_project_token_type tb2
                                            on
                                                        totala.token = tb2.token
                                                    and tb2.type = 'Transfer'
                                                    and (tb2.project = ''
                                                    or tb2.project = 'ALL')
                                                    and tb2.type = 'Transfer'
                                                    and (tb2.project = ''
                                                    or tb2.project = 'ALL')
                                                    and tb2.data_subject = 'volume_elite'
                                                    and tb2.label_type like '%NFT%'
                                                    and tb2.label_type not like '%WEB3%'
                                                    and  totala.recent_time_code = tb2.recent_code
                                        group by recent_time_code,
                                                 seq_flag) as a10
                                    on
                                                a10.seq_flag = a1.seq_flag and a10.recent_time_code=a1.recent_time_code) as a2) as t1
            ) tb1 inner join dim_project_token_type dptt on(dptt.seq_flag = tb1.seq_flag
                and dptt.type = 'Transfer'
                and (dptt.project = ''
                    or dptt.project = 'ALL')
                and dptt.type = 'Transfer'
                and (dptt.project = ''
                    or dptt.project = 'ALL')
                and dptt.data_subject = 'volume_elite'
                and dptt.label_type like '%NFT%'
                and dptt.label_type not like '%WEB3%' and  tb1.recent_time_code = dptt.recent_code)
        where
                tb1.total_transfer_volume >= 1
          and zb_rate <= 0.001
          and zb_rate_transfer_count <= 0.001) t ;
insert into tag_result(table_name,batch_date)  SELECT 'address_label_nft_transfer_volume_count_rank' as table_name,'${batchDate}'  as batch_date;
