drop table if exists address_label_token_project_type_count_grade;
CREATE TABLE public.address_label_token_project_type_count_grade (

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
                                                                     project varchar(50) NULL,
                                                                     asset varchar(50) NULL
);
truncate table public.address_label_token_project_type_count_grade;
insert into public.address_label_token_project_type_count_grade(address,label_type,label_name,data,wired_type,updated_at)
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
    total_transfer_count  as data,
    'DEFI'  as wired_type,
    now() as updated_at
    from
    (
        -- project-token-type(含ALL)
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = 'count'
        group by
            a1.address,
            a2.label_type
            -- project(ALL)-token(ALL)-type(含ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a2.token = 'ALL'
                                   and a2.project = 'ALL'
                                   and a1.type = a2.type
                                   and a2.data_subject = 'count'
        where  (a1.token,a1.project) in (select distinct token,project from dim_project_token_type)
        group by
            a1.address,
            a2.label_type
            -- project-token(ALL)-type(含ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a2.token = 'ALL'
                                   and a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = 'count'
        where  a1.token in (select distinct(token) from dim_project_token_type)
        group by
            a1.address,
            a2.label_type
            -- project(ALL)-token-type(含ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.project = 'ALL'
                                   and a1.type = a2.type
                                   and a2.data_subject = 'count'
        where (a1.token,a1.project) in (select distinct token,project from dim_project_token_type)
        group by
            a1.address,
            a2.label_type
    ) t
    where
        total_transfer_count >= 1 and address <>'0x000000000000000000000000000000000000dead';

