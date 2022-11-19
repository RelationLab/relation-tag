truncate table public.address_label_nft_project_type_volume_grade;
insert into public.address_label_nft_project_type_volume_grade(address,label_type,label_name,updated_at)
    select
    address,
    label_type,
    label_type||'_'||case
                         when volume_usd >= 100
                             and volume_usd < 1000 then 'L1'
                         when volume_usd >= 1000
                             and volume_usd < 10000 then 'L2'
                         when volume_usd >= 10000
                             and volume_usd < 50000 then 'L3'
                         when volume_usd >= 50000
                             and volume_usd < 100000 then 'L4'
                         when volume_usd >= 100000
                             and volume_usd < 500000 then 'L5'
                         when volume_usd >= 500000 then 'L6'
        end as label_name,
        now() as updated_at
    from
    (
        -- project-token-type
        select
            a1.address,
            a2.label_type,
            sum(
                    volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a1.token=a2.token and a1.platform_group=a2.project and a2.data_subject = 'volume_grade'
        group by
            a1.address,
            a2.label_type
    -- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            sum(
            volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
        on a2.token='ALL' and a1.platform_group=a2.project and a2.data_subject = 'volume_grade'
        group by
            a1.address,
            a2.label_type
            -- project-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
        on a2.token='ALL' and a1.platform_group=a2.project and a2.type='ALL' and a2.data_subject = 'volume_grade'
        group by
            a1.address,
            a2.label_type
            -- project-token-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(
            volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
        on a1.token=a2.token and a1.platform_group=a2.project and a2.type='ALL' and a2.data_subject = 'volume_grade'
        group by
            a1.address,
            a2.label_type
    ) t where volume_usd >= 1;