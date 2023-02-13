truncate table public.address_label_nft_transfer_count_grade;
insert into public.address_label_nft_transfer_count_grade(address,label_type,label_name,data,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    address,
    label_type,
    label_type || '_' || case
                             when sum_count >= 1
                                 and sum_count < 10 then 'L1'
                             when sum_count >= 10
                                 and sum_count < 40 then 'L2'
                             when sum_count >= 40
                                 and sum_count < 80 then 'L3'
                             when sum_count >= 80
                                 and sum_count < 120 then 'L4'
                             when sum_count >= 120
                                 and sum_count < 160 then 'L5'
                             when sum_count >= 160
                                 and sum_count < 200 then 'L6'
                             when sum_count >= 200
                                 and sum_count < 400 then 'Low'
                             when sum_count >= 400
                                 and sum_count < 619 then 'Medium'
                             when sum_count >= 619 then 'High'
        end as label_name,
    sum_count  as data,
    now() as updated_at
    from
    (
        -- project(null)+nft+type
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_count) as sum_count
        from
            nft_transfer_holding a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and
                                       a2.type = 'Transfer'
                                   and
                                       a2.data_subject = 'count'
                                   and a2.label_type like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and (a2.project = ''
                                   or a2.project = 'ALL')
        where
                total_transfer_count >= 1
        group by
            a1.address,
            a2.label_type
        union all
        -- project(null)+nft（ALL）+type
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_count) as sum_count
        from
            nft_transfer_holding a1
                inner join dim_project_token_type a2
                           on
                                       a2.token = 'ALL'
                                   and
                                       a2.type = 'Transfer'
                                   and
                                       a2.data_subject = 'count'
                                   and a2.label_type like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and (a2.project = ''
                                   or a2.project = 'ALL')
        where
                total_transfer_count >= 1
        group by
            a1.address,
            a2.label_type) t
    where
        sum_count >= 1 and address <>'0x000000000000000000000000000000000000dead') atb;