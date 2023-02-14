truncate table public.address_label_web3_type_count_grade;
insert into public.address_label_web3_type_count_grade(address,label_type,label_name,data,wired_type,updated_at)
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
    now() as updated_at
    from
    (
        -- project-type
        select
            a1.address,
            a2.label_type,
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
            a2.label_type
            -- project(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
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
            a2.label_type
            -- project(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
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
            a2.label_type
            -- project-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
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
            a2.label_type
    ) t
    where
        total_transfer_count >= 1 and address <>'0x000000000000000000000000000000000000dead';

truncate table public.address_label_crowd_web3_active_users;
insert into public.address_label_crowd_web3_active_users(address,label_type,label_name,data,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
           a1.address ,
           'crowd_web3_active_users' as label_type,
           'crowd_web3_active_users' as label_name,
           0  as data,
           now() as updated_at
       from  address_label_web3_type_count_grade a1
       where (label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_High'
           or label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_Medium'
           or label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_Low')
         and address <>'0x000000000000000000000000000000000000dead';