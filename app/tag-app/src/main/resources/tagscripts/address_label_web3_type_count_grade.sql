drop table if exists address_label_web3_type_count_grade;
CREATE TABLE public.address_label_web3_type_count_grade (
                                                            address varchar(512) NULL,
                                                            data numeric(250, 20) NULL,
                                                            wired_type varchar(20) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL,
                                                            "group" varchar(1) NULL,
                                                            "level" varchar(20) NULL,
                                                            category varchar(20) NULL,
                                                            trade_type varchar(30) NULL,
                                                            project varchar(100) NULL,
                                                            asset varchar(100) NULL,
                                                            bus_type varchar(20) NULL
);
truncate table public.address_label_web3_type_count_grade;
insert into public.address_label_web3_type_count_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
    select
    address,
    label_type,
    label_type || '_' || case
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
    total_transfer_count as data,
    'WEB3'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    'WHALE'     as level,
    'top' as category,
    t.type as trade_type,
    'ALL' as project,
    t.token_name as asset,
    'activity' as bus_type
    from
    (
        -- project-type
        select
            a1.address,
            a2.label_type,
    a2.type,
    a2.token_name,
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = 'count'
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
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a2.project = 'ALL'
                                   and a1.type = a2.type
                                   and a2.data_subject = 'count'
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
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a2.project = 'ALL'
                                   and a2.type = 'ALL'
                                   and a2.data_subject = 'count'
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
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary a1
                inner join dim_project_type a2
                           on
                                       a1.project = a2.project
                                   and a2.type = 'ALL'
                                   and a2.data_subject = 'count'
        group by
            a1.address,
            a2.label_type,
    a2.type,
    a2.token_name
    ) t
    where
        total_transfer_count >= 1 and address <>'0x000000000000000000000000000000000000dead';

drop table if exists address_label_crowd_web3_active_users;
CREATE TABLE public.address_label_crowd_web3_active_users (
                                                              address varchar(512) NULL,
                                                              data numeric(250, 20) NULL,
                                                              wired_type varchar(20) NULL,
                                                              label_type varchar(512) NULL,
                                                              label_name varchar(1024) NULL,
                                                              updated_at timestamp(6) NULL,
                                                              "group" varchar(1) NULL,
                                                              "level" varchar(100) NULL,
                                                              category varchar(100) NULL,
                                                              trade_type varchar(100) NULL,
                                                              project varchar(100) NULL,
                                                              asset varchar(100) NULL,
                                                              bus_type varchar(20) NULL
);
truncate table public.address_label_crowd_web3_active_users;
insert into public.address_label_crowd_web3_active_users(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
 select
           a1.address ,
           'crowd_web3_active_users' as label_type,
           'crowd_web3_active_users' as label_name,
           0  as data,
           'CROWD'  as wired_type,
           now() as updated_at,
           'g'  as "group",
    'crowd_web3_active_users' level,
    'other' as category,
    'ALL' trade_type,
    'ALL' as project,
    'ALL' as asset,
    'CROWD' as bus_type
       from  address_label_web3_type_count_grade a1
       where (label_name = 'WEB3_ALL_ALL_ACTIVITY_High'
           or label_name = 'WEB3_ALL_ALL_ACTIVITY_Medium'
           or label_name = 'WEB3_ALL_ALL_ACTIVITY_Low')
         and address <>'0x000000000000000000000000000000000000dead';