truncate table public.address_label_nft_project_type_volume_top;
insert into public.address_label_nft_project_type_volume_top (address,label_type,label_name,updated_at)
    select
    s1.address,
    s1.label_type,
    s1.label_type||'_'||'TOP' as label_name,
        now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by seq_flag
	order by
		volume_usd desc) as rn
        from (select address
                   ,platform_group
                   ,project
                   ,quote_token
                   ,token
                   ,type
                   ,sum(volume_usd) as volume_usd from (
                                select
                                    address
                                     ,platform_group
                                     ,platform as project
                                     ,quote_token
                                     ,token
                                     ,type
                                     ,volume_usd
                                from
                                    platform_nft_type_volume_count
                                union all
                                -- project-token(ALL)-type
                                select
                                    address
                                     ,platform_group
                                     ,platform as project
                                     ,quote_token
                                     ,'ALL' as token
                                     ,type
                                     ,volume_usd
                                from
                                    platform_nft_type_volume_count
                                union all
                                -- project-token(ALL)-type(ALL)
                                select
                                    address
                                     ,platform_group
                                     ,platform as project
                                     ,quote_token
                                     ,'ALL' as token
                                     ,'ALL' as type
                                     ,volume_usd
                                from
                                    platform_nft_type_volume_count
                                union all
                                -- project-token-type(ALL)
                                select
                                    address
                                     ,platform_group
                                     ,platform as project
                                     ,quote_token
                                     ,token
                                     ,'ALL' as type
                                     ,volume_usd
                                from
                                    platform_nft_type_volume_count ) tatola where tatola.volume_usd>=100
                                    group by address,platform_group,project,quote_token,token,type) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'volume_top'
                                   and a1.platform_group =a2.project and a1.type=a2.type
    ) s1
    where
        s1.rn <= 100;