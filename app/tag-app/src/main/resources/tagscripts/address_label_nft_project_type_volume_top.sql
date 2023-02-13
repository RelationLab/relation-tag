truncate table public.address_label_nft_project_type_volume_top;
insert into public.address_label_nft_project_type_volume_top(address,label_type,label_name,data,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from (  select
    address,
    label_type,
    label_type || '_' || 'TOP' as label_name,
    rn  as data,
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
                        dptt.seq_flag = s1.seq_flag
                  and dptt.project = s1.platform_group
                  and dptt.type = s1.type
                  and dptt.data_subject = 'volume_top') as label_type,
                  s1.rn
        from
            (
                select
                    address,
                    platform_group,
                    seq_flag,
                    type,
                    -- 分组字段很关键
                    row_number() over( partition by seq_flag,platform_group,type
		order by
			volume_usd desc,
			address asc) as rn
                from
                    (
                        select
                            address,
                            a2.seq_flag,
                            platform_group,
                            tatola.type,
                            sum(volume_usd) as volume_usd
                        from
                            (
                                select
                                    address,
                                    platform_group,
                                    token,
                                    type,
                                    volume_usd
                                from
                                    platform_nft_type_volume_count where   address <>'0x000000000000000000000000000000000000dead'
                                union all
                                -- project-token(ALL)-type
                                select
                                    address,
                                    platform_group,
                                    'ALL' as token,
                                    type,
                                    volume_usd
                                from
                                    platform_nft_type_volume_count where   address <>'0x000000000000000000000000000000000000dead'
                                union all
                                -- project-token(ALL)-type(ALL)
                                select
                                    address,
                                    platform_group,
                                    'ALL' as token,
                                    'ALL' as type,
                                    volume_usd
                                from
                                    platform_nft_type_volume_count where   address <>'0x000000000000000000000000000000000000dead'
                                union all
                                -- project-token-type(ALL)
                                select
                                    address,
                                    platform_group,
                                    token,
                                    'ALL' as type,
                                    volume_usd
                                from
                                    platform_nft_type_volume_count  where address <>'0x000000000000000000000000000000000000dead')
                                tatola
                                inner join dim_project_token_type a2
                                           on
                                                       tatola.token = a2.token
                                                   and a2.data_subject = 'volume_top'
                                                   and tatola.platform_group = a2.project
                                                   and tatola.type = a2.type
                        where
                                tatola.volume_usd >= 100
                        group by
                            address,
                            a2.seq_flag,
                            platform_group,
                            tatola.type) a1
            ) s1
        where
                s1.rn <= 100 ) t) atb;