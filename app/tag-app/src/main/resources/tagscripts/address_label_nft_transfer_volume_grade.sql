truncate table public.address_label_nft_transfer_volume_grade;
insert into public.address_label_nft_transfer_volume_grade(address,label_type,label_name,updated_at)
    select
    address,
    label_type,
    label_type || '_' || case
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
        -- project(null)+nft+type
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_volume) as volume_usd
        from
            nft_transfer_holding a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and
                                       a2.type = 'Transfer'
                                   and
                                       a2.data_subject = 'volume_grade'
                                   and a2.label_type like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and (a2.project = ''
                                   or a2.project = 'ALL')
        group by
            a1.address,
            a2.label_type
        union all
        -- project(null)+nft（ALL）+type
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_volume) as volume_usd
        from
            nft_transfer_holding a1
                inner join dim_project_token_type a2
                           on
                                       a2.token = 'ALL'
                                   and
                                       a2.type = 'Transfer'
                                   and
                                       a2.data_subject = 'volume_grade'
                                   and a2.label_type like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and (a2.project = ''
                                   or a2.project = 'ALL')
        group by
            a1.address,
            a2.label_type) t
    where
        volume_usd >= 100 and address <>'0x000000000000000000000000000000000000dead';