truncate table public.address_label_token_volume_grade_all;
insert into public.address_label_token_volume_grade_all (address,label_type,label_name,updated_at)
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
    now() as updated_at
    from
    (
        select
            address,
            'ALL' as token ,
            volume_usd as volume_usd
        from
            total_balance_volume_usd tbvu
    )
        a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a1.volume_usd >= 100
  and a2.data_subject = 'volume_grade'
  and a2.token_type = 'token' and address <>'0x000000000000000000000000000000000000dead';