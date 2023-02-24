drop table if exists address_label_web3_type_balance_grade;
CREATE TABLE public.address_label_web3_type_balance_grade (
                                                              address varchar(512) NULL,
                                                              data numeric(250, 20) NULL,
                                                              wired_type varchar(20) NULL,
                                                              label_type varchar(512) NULL,
                                                              label_name varchar(1024) NULL,
                                                              updated_at timestamp(6) NULL,
                                                              "group" varchar(1) NULL,
                                                              "level" varchar(50) NULL,
                                                              category varchar(50) NULL,
                                                              trade_type varchar(50) NULL,
                                                              project varchar(50) NULL,
                                                              asset varchar(50) NULL
);
truncate table public.address_label_web3_type_balance_grade;
insert into public.address_label_web3_type_balance_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
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
    balance  as data,
    'WEB3'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    case
        when balance = 1 then 'L1'
        when balance >= 2
            and balance < 4 then 'L2'
        when balance >= 4
            and balance < 11 then 'L3'
        when balance >= 11
            and balance < 51 then 'L4'
        when balance >= 51
            and balance < 101 then 'L5'
        when balance >= 101 then 'L6' end    as level,
    'grade' as category,
    t.type as trade_type,
    'all' as project,
    t.token_name as asset
from
    (
        -- project-type
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.token_name,
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
            a2.label_type,
            a2.type,
            a2.token_name
            -- project(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.token_name,
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
            a2.label_type,
            a2.type,
            a2.token_name
            -- project(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.token_name,
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
            a2.label_type,
            a2.type,
            a2.token_name
            -- project-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.token_name,
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
            a2.label_type,
            a2.type,
            a2.token_name
    ) t
where
        balance >= 1 and address <>'0x000000000000000000000000000000000000dead';