drop table if exists address_label_nft_project_type_volume_top;
CREATE TABLE public.address_label_nft_project_type_volume_top (
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
truncate table public.address_label_nft_project_type_volume_top;
vacuum address_label_nft_project_type_volume_top;

insert into public.address_label_nft_project_type_volume_top(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type, recent_time_code )
select
    address,
    label_type,
    label_type || '_' || 'TOP' as label_name,
    rn  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'v'  as "group",
    'TOP'    as level,
    'top' as category,
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
            s1.rn,
            recent_time_code
        from
            (
                select
                    address,
                    platform_group,
                    seq_flag,
                    type,
                    -- 分组字段很关键
                    row_number() over( partition by seq_flag,platform_group,type,recent_time_code
		            order by volume_usd desc,address asc) as rn,
                        recent_time_code
                from
                    (
                        select
                            address,
                            a2.seq_flag,
                            platform_group,
                            tatola.type,
                            sum(volume_usd) as volume_usd,
                            recent_time_code
                        from
                            (
                                select
                                    address,
                                    platform_group,
                                    token,
                                    type,
                                    volume_usd,
                                    recent_time_code
                                from
                                    platform_nft_type_volume_count_temp
                                where (volume_usd >= 100 and type not in('Lend','Bid')) or (volume_usd > 0 and type  in('Lend','Bid'))
                                    and address not in (select address from exclude_address)
                                    and token in (select token_id from dim_project_token_type_rank_temp dpttr)
                                union all
                                -- project-token(ALL)-type
                                select
                                    address,
                                    platform_group,
                                    'ALL' as token,
                                    type,
                                    volume_usd,
                                    recent_time_code
                                from
                                    platform_nft_type_volume_count_temp
                                where (volume_usd >= 100 and type not in('Lend','Bid')) or (volume_usd > 0 and type  in('Lend','Bid'))
                                    and     address not in (select address from exclude_address)
                                    and token in (select token_id from dim_project_token_type_rank_temp dpttr)
                                union all
                                -- project(ALL)-token(ALL)-type
                                select
                                    address,
                                    'ALL' as platform_group,
                                    'ALL' as token,
                                    type,
                                    volume_usd,
                                    recent_time_code
                                from
                                    platform_nft_type_volume_count_temp
                                where (volume_usd >= 100 and type not in('Lend','Bid')) or (volume_usd > 0 and type  in('Lend','Bid'))
                                    and       address not in (select address from exclude_address)
                                    and token in (select token_id from dim_project_token_type_rank_temp dpttr)
                                union all
                                -- project(ALL)-token(ALL)-type
                                select
                                    address,
                                    'ALL' as platform_group,
                                    token,
                                    type,
                                    volume_usd,
                                    recent_time_code
                                from
                                    platform_nft_type_volume_count_temp
                                where (volume_usd >= 100 and type not in('Lend','Bid')) or (volume_usd > 0 and type  in('Lend','Bid'))
                                    and   address not in (select address from exclude_address)
                                    and token in (select token_id from dim_project_token_type_rank_temp dpttr)
                            )
                                tatola
                                inner join dim_project_token_type_temp a2
                                           on
                                                       tatola.token = a2.token
                                                   and a2.data_subject = 'volume_top'
                                                   and tatola.platform_group = a2.project
                                                   and tatola.type = a2.type
                                                   and a2.recent_code = tatola.recent_time_code
                        group by
                            address,
                            a2.seq_flag,
                            platform_group,
                            tatola.type,
                            recent_time_code) a1
            ) s1 inner join dim_project_token_type_temp dptt on (
                        dptt.seq_flag = s1.seq_flag
                    and dptt.project = s1.platform_group
                    and dptt.recent_code = s1.recent_time_code
                    and dptt.type = s1.type
                    and dptt.data_subject = 'volume_top'
                )
        where
                s1.rn <= 100 and label_type not like '%_DEX_%' ) t;
insert into tag_result(table_name,batch_date)  SELECT 'address_label_nft_project_type_volume_top' as table_name,'${batchDate}'  as batch_date;
