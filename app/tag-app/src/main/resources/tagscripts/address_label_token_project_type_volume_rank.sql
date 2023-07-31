drop table if exists address_label_token_project_type_volume_rank;
CREATE TABLE public.address_label_token_project_type_volume_rank (
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
                                                                     bus_type varchar(20) NULL,
                                                                     recent_time_code varchar(30) NULL
);
truncate table public.address_label_token_project_type_volume_rank;
vacuum address_label_token_project_type_volume_rank;

insert into public.address_label_token_project_type_volume_rank(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type, recent_time_code )
    select
    address ,
    label_type,
    label_type || '_' || case
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
    when zb_rate <= 0.001 then 'LEGENDARY' end   as level,
    'rank' as category,
    t.type as trade_type,
    t.project_name as project,
    t.token_name as asset,
    'volume' as bus_type,
    recent_time_code
    from
    (
        select
            address,
            dptt.label_type as label_type,
            dptt.type as type,
            dptt.project_name as project_name,
            dptt.token_name as token_name,
            zb_rate,
            recent_time_code
        from
            (
                select
                    t1.id,
                    t1.address,
                    t1.token,
                    t1.seq_flag,
                    t1.type,
                    t1.total_transfer_volume_usd,
                    t1.count_sum,
                    t1.count_sum_total,
                    t1.zb_rate,
                    recent_time_code
                from
                    (
                        select
                            a2.id,
                            a2.address,
                            a2.token,
                            a2.seq_flag,
                            a2.type,
                            a2.total_transfer_volume_usd,
                            a2.count_sum,
                            a2.count_sum_total,
                            cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                            recent_time_code
                        from
                            (
                                select
                                    a1.id,
                                    a1.address,
                                    a1.token,
                                    a1.seq_flag,
                                    a1.type,
                                    a1.total_transfer_volume_usd,
                                    a1.count_sum,
                                    a10.count_sum_total,
                                    a1.recent_time_code
                                from
                                    (
                                        select
                                            md5(cast(random() as varchar)) as id,
                                            a1.address,
                                            a1.token,
                                            a1.seq_flag,
                                            a1.type,
                                            a1.total_transfer_volume_usd,
                                            row_number() over(partition by seq_flag,recent_time_code
					                        order by total_transfer_volume_usd desc,address asc) as count_sum,
                                            recent_time_code
                                        from
                                            (
                                                select
                                                    s1.address,
                                                    s2.seq_flag,
                                                    s1.token,
                                                    s1.type,
                                                    sum(s1.total_transfer_volume_usd) as total_transfer_volume_usd,
                                                    recent_time_code
                                                from
                                                    (
                                                        -- project-token-type
                                                        select
                                                            address,
                                                            token,
                                                            total_transfer_volume_usd,
                                                            type,
                                                            project,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd  > 0 and address not in (select address from exclude_address)
                                                                and token in (select distinct token from dim_project_token_type_temp)
                                                        union all
                                                        -- project(ALL)-token(ALL)-type
                                                        select
                                                            address,
                                                            'ALL' as token,
                                                            total_transfer_volume_usd,
                                                            type,
                                                            'ALL' as project,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd > 0 and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                        union all
                                                        -- project(ALL)-token-type(ALL)
                                                        select
                                                            address,
                                                            token,
                                                            total_transfer_volume_usd,
                                                            'ALL' as type,
                                                            'ALL' as project,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd  > 0 and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                        union all
                                                        -- project-token(ALL)-type
                                                        select
                                                            address,
                                                            'ALL' as token,
                                                            total_transfer_volume_usd,
                                                            type,
                                                            project,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd > 0 and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                        union all
                                                        -- project(ALL)-token-type
                                                        select
                                                            address,
                                                            token,
                                                            total_transfer_volume_usd,
                                                            type,
                                                            'ALL' as project,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd  > 0 and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                            ) s1
                                                        inner join dim_project_token_type_temp s2
                                                                   on
                                                                               s1.token = s2.token
                                                                           and s1.project = s2.project
                                                                           and s1.type = s2.type
                                                                           and s2.data_subject = 'volume_rank'
                                                                           and s1.recent_time_code = s2.recent_code
                                                where
                                                        total_transfer_volume_usd >= 100
                                                group by
                                                    s1.address,
                                                    s1.token,
                                                    s1.type,
                                                    s2.seq_flag,
                                                    recent_time_code) as a1) as a1
                                        inner join (
                                        select
                                            count(distinct address) as count_sum_total,
                                            tb2.token,
                                            seq_flag,
                                            tb2.type,
                                            recent_time_code
                                        from
                                            (
                                                select
                                                    address,
                                                    token,
                                                    type,
                                                    project,
                                                    sum(total_transfer_volume_usd) total_transfer_volume_usd,
                                                    recent_time_code
                                                from
                                                    (
                                                        select
                                                            address,
                                                            token,
                                                            type,
                                                            project,
                                                            total_transfer_volume_usd,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd  > 0  and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                        union all
                                                        -- project(ALL)-token(ALL)-type
                                                        select
                                                            address,
                                                            'ALL' as token,
                                                            type,
                                                            'ALL' as project,
                                                            total_transfer_volume_usd,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd > 0  and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                        union all
                                                        -- project-token(ALL)-type
                                                        select
                                                            address,
                                                            'ALL' as token,
                                                            type,
                                                            project,
                                                            total_transfer_volume_usd,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd > 0 and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                        union all
                                                        -- project(ALL)-token-type
                                                        select
                                                            address,
                                                            token,
                                                            type,
                                                            'ALL' as project,
                                                            total_transfer_volume_usd,
                                                            recent_time_code
                                                        from
                                                            dex_tx_volume_count_summary_temp
                                                        where
                                                                total_transfer_volume_usd  > 0 and address not in (select address from exclude_address)
                                                          and token in (select distinct token from dim_project_token_type_temp)
                                                    ) ta
                                                group by
                                                    address,
                                                    token,
                                                    type,
                                                    project,
                                                    recent_time_code) totala
                                                inner join dim_project_token_type_temp tb2 on
                                                        totala.token = tb2.token
                                                    and totala.project = tb2.project
                                                    and totala.type = tb2.type
                                                    and tb2.data_subject = 'volume_rank'
                                                    and totala.recent_time_code = tb2.recent_code
                                        where
                                                total_transfer_volume_usd >= 100
                                        group by
                                            tb2.token,
                                            tb2.seq_flag,
                                            tb2.type,
                                            recent_time_code ) as a10
                                                   on
                                                               a10.token = a1.token
                                                           and a10.seq_flag = a1.seq_flag
                                                           and a10.type = a1.type and a1.recent_time_code=a10.recent_time_code) as a2) as t1
            ) tb1 inner join dim_project_token_type_temp dptt on (dptt.token = tb1.token
                  and dptt."type" = tb1.type
                  and dptt.seq_flag = tb1.seq_flag
                  and dptt.data_subject = 'volume_rank'
                  and label_type not like '%NFT%'
                and tb1.recent_time_code = dptt.recent_code)
        where
                tb1.total_transfer_volume_usd >= 100
          and zb_rate <= 0.1) t ;
insert into tag_result(table_name,batch_date)  SELECT 'address_label_token_project_type_volume_rank' as table_name,'${batchDate}'  as batch_date;
