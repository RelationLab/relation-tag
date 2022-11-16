truncate table public.address_label_token_project_type_balance_grade;
insert into public.address_label_token_project_type_balance_grade(address,label_type,label_name,updated_at)
    select
    address,
    label_type,
    label_type||'_'||case
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
            and balance_usd < 1000000000 then 'Million'
        when balance_usd >= 1000000000 then 'Billion'
        end as label_name,
        now() as updated_at
    from
    (
        -- project-token-type
        select
            a1.address,
            a2.label_type,
            sum(balance_usd) as balance_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token
                                                            and a1.project = a2.project
                                                           and a2.data_subject = 'balance_grade'
        group by
            a1.address,
            a2.label_type
    ) t where balance_usd >= 100;