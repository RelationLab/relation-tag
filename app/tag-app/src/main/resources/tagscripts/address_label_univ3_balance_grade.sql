truncate table public.address_label_univ3_balance_grade;
insert into public.address_label_univ3_balance_grade (address,label_type,label_name,updated_at)
    select
    address,
    a2.label_type,
    a2.label_type || '_' || case
                                when balance_usd >= 100
                                    and balance_usd < 1000 then 'L1'
                                when balance_usd >= 1000
                                    and balance_usd < 10000 then 'L2'
                                when balance_usd >= 10000
                                    and balance_usd < 50000 then 'L3'
                                when balance_usd >= 50000
                                    and balance_usd < 100000 then 'L4'
                                when balance_usd >= 100000
                                    and balance_usd < 500000 then 'L5'
                                when balance_usd >= 500000
                                    and balance_usd < 1000000 then 'L6'
                                when balance_usd >= 1000000
                                    and balance_usd < 1000000000 then 'Millionaire'
                                when balance_usd >= 1000000000 then 'Billionaire'
        end as label_name,
    now() as updated_at
    from
    (
        select
            address,
            token,
            balance_usd,
            project,
            type
        from
            dex_tx_volume_count_summary_univ3 tbvutk
        where
                project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
          and balance_usd >= 100
          and type = 'lp'
    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a2.data_subject = 'balance_grade';


