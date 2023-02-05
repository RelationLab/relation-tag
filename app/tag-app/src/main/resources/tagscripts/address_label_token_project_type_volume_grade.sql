truncate table public.address_label_token_project_type_volume_grade;
insert into public.address_label_token_project_type_volume_grade(address,label_type,label_name,updated_at)
    select
    address,
    label_type,
    label_type || '_' || case
                             when total_transfer_volume_usd >= 100
                                 and total_transfer_volume_usd < 1000 then 'L1'
                             when total_transfer_volume_usd >= 1000
                                 and total_transfer_volume_usd < 10000 then 'L2'
                             when total_transfer_volume_usd >= 10000
                                 and total_transfer_volume_usd < 50000 then 'L3'
                             when total_transfer_volume_usd >= 50000
                                 and total_transfer_volume_usd < 100000 then 'L4'
                             when total_transfer_volume_usd >= 100000
                                 and total_transfer_volume_usd < 500000 then 'L5'
                             when total_transfer_volume_usd >= 500000
                                 and total_transfer_volume_usd < 1000000 then 'L6'
                             when total_transfer_volume_usd >= 1000000
                                 and total_transfer_volume_usd < 1000000000 then 'Million'
                             when total_transfer_volume_usd >= 1000000000 then 'Billion'
        end as label_name,
    now() as updated_at
    from
    (
        -- project-token-type
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = 'volume_grade'
                                   and a2.label_type not like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
        group by
            a1.address,
            a2.label_type
            -- project(ALL)-token(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a2.token = 'ALL'
                                   and a2.project = 'ALL'
                                   and a1.type = a2.type
                                   and a2.data_subject = 'volume_grade'
                                   and a2.label_type not like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
        where  (a1.token,a1.project) in (select distinct token,project from dim_project_token_type)
        group by
            a1.address,
            a2.label_type
            -- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a2.token = 'ALL'
                                   and a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = 'volume_grade'
                                   and a2.label_type not like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
        where  a1.token in (select distinct(token) from dim_project_token_type)
        group by
            a1.address,
            a2.label_type
            -- project(ALL)-token-type
        union all
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.project = 'ALL'
                                   and a1.type = a2.type
                                   and a2.data_subject = 'volume_grade'
                                   and a2.label_type not like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
        where (a1.token,a1.project) in (select distinct token,project from dim_project_token_type)
        group by
            a1.address,
            a2.label_type
    ) t where
        total_transfer_volume_usd >= 100 and address <>'0x000000000000000000000000000000000000dead';