drop table if exists address_label_nft_project_type_volume_top;
CREATE TABLE public.address_label_nft_project_type_volume_top (
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
    asset varchar(50) NULL
);
truncate table public.address_label_nft_project_type_volume_top;
insert into public.address_label_nft_project_type_volume_top(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
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
    t.token_name as asset
    from
    (
        select
            address,
    dptt.label_type as label_type,
    dptt.type as type,
    dptt.project_name as project_name,
    dptt.token_name as token_name,
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
                               )
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
            ) s1 inner join dim_project_token_type dptt on (
    dptt.seq_flag = s1.seq_flag
    and dptt.project = s1.platform_group
    and dptt.type = s1.type
    and dptt.data_subject = 'volume_top'
            )
        where
                s1.rn <= 100 ) t;