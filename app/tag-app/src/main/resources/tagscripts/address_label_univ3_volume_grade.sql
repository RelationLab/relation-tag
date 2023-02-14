truncate table public.address_label_univ3_volume_grade;
insert into public.address_label_univ3_volume_grade(address,label_type,label_name,data,wired_type,updated_at)
    select
    a1.address,
    a2.label_type,
    a2.label_type || '_' || case
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
                                when volume_usd >= 500000
                                    and volume_usd < 1000000 then 'L6'
                                when volume_usd >= 1000000
                                    and volume_usd < 1000000000 then 'Million'
                                when volume_usd >= 1000000000 then 'Billion'
        end as label_name,
    volume_usd  as data,
    'DEFI'  as wired_type,
    now() as updated_at
    from
    (
        select
            address,
            token,
            total_transfer_volume_usd as volume_usd
        from
            dex_tx_volume_count_summary dtvcs
        where
                dtvcs.project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
          and dtvcs.total_transfer_volume_usd >= 100
    )
        a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
            and a2.label_type  like 'Uniswap_v3%'
    where
        a2.data_subject = 'volume_grade' and address <>'0x000000000000000000000000000000000000dead';