truncate table public.address_label_web3_type_balance_grade;
insert into public.address_label_web3_type_balance_grade (address,label_type,label_name,updated_at)
    select
    address,
    label_type,
    label_type || '_' || case
                             when balance = 1 then 'L1'
                             when balance >= 2
                                 and balance < 4 then 'L2'
                             when balance >= 4
                                 and balance < 11 then 'L3'
                             when balance >= 11
                                 and balance < 51 then 'L4'
                             when balance >= 51
                                 and balance < 101 then 'L5'
                             when balance >= 101 then 'L6'
        end as label_name,
    now() as updated_at
    from
    (
        -- project-type
        select
            a1.address,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = 'balance_grade'
        group by
            a1.address,
            a2.label_type
            -- project(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a2.project = 'ALL'
                                   and a1.type = a2.type
                                   and a2.data_subject = 'balance_grade'
        group by
            a1.address,
            a2.label_type
            -- project(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a2.project = 'ALL'
                                   and a2.type = 'ALL'
                                   and a2.data_subject = 'balance_grade'
        group by
            a1.address,
            a2.label_type
            -- project-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a1.project = a2.project
                                   and a2.type = 'ALL'
                                   and a2.data_subject = 'balance_grade'
        group by
            a1.address,
            a2.label_type
    ) t
    where
        balance >= 1;