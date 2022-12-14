truncate table public.address_label_univ3_count_grade;
insert into public.address_label_univ3_count_grade (address,label_type,label_name,updated_at)
    select
    a1.address ,
    a2.label_type,
    a2.label_type || '_' || case
                                when total_transfer_count >= 1
                                    and total_transfer_count < 10 then 'L1'
                                when total_transfer_count >= 10
                                    and total_transfer_count < 40 then 'L2'
                                when total_transfer_count >= 40
                                    and total_transfer_count < 80 then 'L3'
                                when total_transfer_count >= 80
                                    and total_transfer_count < 120 then 'L4'
                                when total_transfer_count >= 120
                                    and total_transfer_count < 160 then 'L5'
                                when total_transfer_count >= 160
                                    and total_transfer_count < 200 then 'L6'
                                when total_transfer_count >= 200
                                    and total_transfer_count < 400 then 'Low'
                                when total_transfer_count >= 400
                                    and total_transfer_count < 619 then 'Medium'
                                when total_transfer_count >= 619 then 'High'
        end as label_name,
    now() as updated_at
    from
    (
        select
            token,
            address,
            total_transfer_count as total_transfer_count
        from
            dex_tx_volume_count_summary th
        where
                th.project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'

    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
            and a2.label_type  like 'Uniswap_v3%'
    where
        a1.total_transfer_count >= 1
  and a2.data_subject = 'count' and address <>'0x000000000000000000000000000000000000dead';